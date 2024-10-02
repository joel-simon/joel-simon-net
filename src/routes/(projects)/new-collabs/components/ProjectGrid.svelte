<!-- ProjectGrid.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import { Button, Modal } from "flowbite-svelte";
  import { type ProjectData } from "../types";
  import Project from "./Project.svelte";
  import SvelteMarkdown from "svelte-markdown";
  export let projects: Array<ProjectData> = [];

  // let defaultModal = false;

  let hoveredProject: ProjectData | null = null;
  let selectedProject: ProjectData | null = null;

  function removeCodeBlocks(input: string): string {
    // This regex matches code blocks (including the ``` delimiters) and any optional language identifier
    const codeBlockRegex = /```[\s\S]*?```/g;

    // Replace all matches with an empty string
    return input.replace(codeBlockRegex, "");
  }

  function parseCompletedTemplate(template: string): string {
    template = template.replace(
      "Let's think through this step-by-step using the creative prompts:",
      ""
    );
    return removeCodeBlocks(template);
  }
</script>

<Modal
  title={selectedProject?.project.projectName}
  open={selectedProject != null}
  autoclose
  class="mb-[50px]"
>
  {#if selectedProject}
    <div class="flex w-full justify-center">
      <img
        src={`/ideas/images_dev/${selectedProject?.key}.webp`}
        alt="project preview"
        class="border border-gray-200 max-w-[300px] rounded-md"
      />
    </div>
    <SvelteMarkdown
      source={parseCompletedTemplate(selectedProject.project.completedTemplate)}
    />
    <!-- <p class="text-gray-500 dark:text-gray-400 whitespace-pre-line">
      {parseCompletedTemplate(selectedProject.project.completedTemplate)}
    </p> -->
  {/if}
</Modal>

<div class="flex flex-col gap-2">
  <h2 id="examples" class="!m-0">Examples</h2>
  <p class="w-full !text-center !m-0">
    Select an idea to see its creative chain of thought.
  </p>
</div>

<!-- Main container for grid and sticky sidebar -->
<div class="flex flex-col md:flex-row w-full gap-4">
  <!-- Grid Section -->
  <div class="flex-1 overflow-x-auto md:overflow-hidden">
    <!-- Grid Container with no gaps and borders -->
    <div
      class="grid md:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 border-t border-dashed border-gray-200 h-fit"
    >
      {#each projects as project, index}
        <!-- svelte-ignore a11y-click-events-have-key-events -->
        <!-- svelte-ignore a11y-mouse-events-have-key-events -->
        <div
          role="button"
          class="relative p-2 px-8 cursor-pointer transition border-b border-r border-dashed border-gray-200 flex flex-col justify-between hover:bg-sky-50"
          tabindex="0"
          class:selected={hoveredProject === project}
          class:bg-sky-100={hoveredProject === project}
          on:click={() => (selectedProject = project)}
          on:mouseover={() => (hoveredProject = project)}
        >
          <Project {project} />
        </div>
      {/each}
    </div>
  </div>

  <!-- Sticky Sidebar Section -->
  <div
    class="hidden md:block md:sticky md:top-0 md:h-screen bg-white p-4 shadow-lg md:overflow-y-auto border-dashed border-gray-200"
    style="width: 400px;"
  >
    {#if hoveredProject}
      <!-- <h2 class="text-xl font-bold mb-4">
        {hoveredProject.project.projectName}
      </h2> -->
      <img
        src={`/ideas/images_dev/${hoveredProject.key}.webp`}
        alt="project preview"
        class="border border-gray-200"
      />
      <h3 class="font-semibold mt-2">Steps:</h3>
      <ol class="list-decimal ml-6 mb-4 text-left">
        {#each hoveredProject.template.steps as step}
          <li class="whitespace-normal text-left">{step}</li>
        {/each}
      </ol>
    {/if}
  </div>
</div>

<style>
  /* Ensure no gap between grid items */
  .grid > div {
    position: relative;
  }
</style>
