<script lang="ts">
  import { type ProjectData } from "./types";
  import Document from "$lib/components/citations/Document.svelte";
  import Citation from "$lib/components/citations/Citation.svelte";

  import ProjectGrid from "./ProjectGrid.svelte";
  import StartingTemplates from "./components/StartingTemplates.svelte";
  import SmallProjectLink from "$lib/components/SmallProjectLink.svelte";
  import { projects } from "$lib/data";
  import ProjectCard from "$lib/components/ProjectCard.svelte";
  import { writable } from "svelte/store";
  import Intro from "./sections/Intro.svelte";
  import Background from "./sections/Background.svelte";
  import Methods from "./sections/Methods.svelte";
  import { citationsData } from "./data/citations";

  export let data: { projects: ProjectData[] };
</script>

<div id="projects-page">
  <Document {citationsData}>
    <div class="flex flex-col gap-4">
      <div class="text_body">
        <div class="flex flex-col gap-2 mb-2 mt-6">
          <h1 class="m-0">New Collabs</h1>
          <h3 class="!m-0 text-zinc-500">2024</h3>
        </div>
        <!-- <p class="w-full !text-center">2024</p> -->
        <!-- <p class="w-full !text-center">Ggenerative Research-art 2024</p> -->
        <Intro />

        <div class="flex gap-4 w-full justify-center sticky">
          {#each ["examples", "background", "methods", "discussion"] as sectionName}
            <a
              class="capitalize !text-zinc-500 underline-offset-2"
              href={"#" + sectionName}>{sectionName}</a
            >
          {/each}
        </div>

        <!-- </div> -->
      </div>

      <div class="flex flex-col gap-2">
        <h2 id="examples" class="!m-0">Examples</h2>
        <!-- <div class="w-full center-text"> -->
        <p class="w-full !text-center !m-0">
          Select an idea to see its creative chain of thought.
        </p>
      </div>
      <ProjectGrid projects={data.projects} />
      <div class="text_body">
        <Background />
        <Methods />
      </div>
      <StartingTemplates />
      <div class="text_body">
        <h2>Discussion</h2>
        <p>
          We stand upon the precipice of a world of slop - regurgitated AI
          averngess rehashed and then retrained upon itself in a sick recursive
          mad cow loop. To work criticallt with technology is not to derailit ,
          but rather to find way to repurporse and reframe it.
        </p>
        <p>Ultimately, this work has to be evaluated subjectively,</p>

        <h2>Future Work</h2>
        <p>
          Interactive evolution with human in the loop Focused on single pairs
          Social netoworks
        </p>
      </div>
      <div class="text_body">
        <!-- <h2>Acknowledgements</h2>
      <p>Thanks to Joel Lehmanm nad  -->

        <h2>Related Art/Research</h2>
        <!-- <p>
          If you enjoyed this you may also enjoy my other independent
          research-art projects.
        </p> -->
        <div class="w-full grid grid-cols-4 gap-4 my-4">
          {#each projects as project}
            {#if project.labels.includes("research-art")}
              <SmallProjectLink projectName={project.name} />
            {/if}
          {/each}
        </div>
      </div>
      <div class="text_body">
        <div>
          <p>To cite this blog:</p>

          <p>
            Simon, J. (2024, September 26). New Ideas. <i>JoelSimon.net</i>.
            <a href="https://www.joelsimon.net/ideas"
              >https://www.joelsimon.net/ideas</a
            >
          </p>
        </div>
      </div>
    </div>
  </Document>
</div>

<style>
  :global(#projects-page b) {
    font-weight: 500;
  }
</style>
