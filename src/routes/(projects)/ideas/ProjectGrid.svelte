<!-- ProjectGrid.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import { type ProjectData } from "./types";
  import Project from "./Project.svelte";

  export let projects: Array<ProjectData> = [];

  let selectedProject: ProjectData | null = null;

  onMount(() => {
    // Select the first project as default when the component loads
    if (projects.length > 0) {
      selectedProject = projects[0];
    }
  });
</script>

<!-- Main container for grid and sticky sidebar -->
<div class="flex flex-col md:flex-row w-full gap-4">
  <!-- Grid Section -->
  <div class="flex-1 overflow-x-auto md:overflow-hidden">
    <!-- Grid Container with no gaps and borders -->
    <div
      class="grid md:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 border-t border-dashed border-gray-200 h-fit"
    >
      {#each projects as project, index}
        <Project {project} bind:selectedProject />
      {/each}
    </div>
  </div>

  <!-- Sticky Sidebar Section -->
  <div
    class="hidden md:block md:sticky md:top-0 md:h-screen bg-white p-4 shadow-lg md:overflow-y-auto border-l border-t border-dashed border-gray-200"
    style="width: 400px;"
  >
    {#if selectedProject}
      <!-- <h2 class="text-xl font-bold mb-4">
        {selectedProject.project.projectName}
      </h2> -->
      <!-- <p class="mb-4">{selectedProject.project.projectDescription}</p> -->
      <img
        src={`/ideas/images/${selectedProject.key}.png`}
        alt="project preview"
      />

      <h3 class="font-semibold">Steps:</h3>
      <ol class="list-decimal ml-6 mb-4 text-left">
        {#each selectedProject.template.steps as step}
          <li class="whitespace-normal text-left">{step}</li>
        {/each}
      </ol>
      <pre
        class="bg-gray-100 p-4 rounded-md overflow-x-auto whitespace-pre-wrap">{selectedProject
          .project.completedTemplate}</pre>
    {/if}
  </div>

  <!-- Sidebar for Mobile -->
  <div
    class="md:hidden bg-white p-4 shadow-lg border-t border-dashed border-gray-300 mt-4"
  >
    {#if selectedProject}
      <h2 class="text-xl font-bold mb-4">
        {selectedProject.project.projectName}
      </h2>
      <!-- <p class="mb-4">{selectedProject.project.projectDescription}</p> -->
      <h3 class="font-semibold">Steps:</h3>
      <ol class="list-decimal ml-6 mb-4 text-left">
        {#each selectedProject.template.steps as step}
          <li class="whitespace-normal">{step}</li>
        {/each}
      </ol>
      <pre
        class="bg-gray-100 p-4 rounded-md overflow-x-auto whitespace-pre-wrap">{selectedProject
          .project.completedTemplate}</pre>
    {/if}
  </div>
</div>

<style>
  /* Ensure no gap between grid items */
  .grid > div {
    position: relative;
  }

  @media (max-width: 768px) {
    /* Horizontal scrolling for grid on mobile */
    .grid {
      display: flex;
      overflow-x: auto;
      scroll-snap-type: x mandatory;
    }
    .grid > div {
      flex: 0 0 auto;
      scroll-snap-align: start;
      width: 100%;
    }
  }
</style>
