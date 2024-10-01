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
  import Discussion from "./sections/Discussion.svelte";

  export let data: { projects: ProjectData[] };
</script>

<!-- <div class="relative sticky"><h2>New Collabs</h2></div>
<div class="h-[2000px]"></div> -->
{#if true}
  <div id="ideas-page">
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

          <div class="flex gap-4 w-full justify-center sticky my-4">
            {#each ["examples", "background", "methods", "discussion"] as sectionName}
              <a
                class="capitalize !text-zinc-800 !no-underline hover:!underline"
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
        <Discussion />
        <div class="text_body">
          <h2>Related Art/Research Projects:</h2>
          <!-- <p>
          If you enjoyed this you may also enjoy my other independent
          research-art projects.
        </p> -->
          <div class="w-full grid grid-cols-2 md:grid-cols-4 gap-4 my-4">
            {#each projects as project}
              {#if project.labels.includes("research-art")}
                <SmallProjectLink projectName={project.name} />
              {/if}
            {/each}
          </div>
          <h2>Acknowledgements</h2>
          <p>
            Thanks to Joel Lehman and Kenneth Stanley for their very helpful
            feedback and kind encouragement. This was done while in-residence at
            <a href="https://stochasticlabs.org/">Stochastic Labs.</a>
          </p>
        </div>

        <div class="text_body">
          <div>
            <h2>To cite this blog</h2>
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
{/if}

<style>
  :global(#ideas-page b) {
    font-weight: 500;
    @apply text-gray-800;
  }
  :global(#ideas-page h1, #ideas-page h2, #ideas-page h3, #ideas-page h4) {
    @apply text-gray-800;
    /* font-weight: 500; */
  }
</style>
