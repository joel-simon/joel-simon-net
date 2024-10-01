<script lang="ts">
  import { type ProjectData } from "./types";
  import Document from "$lib/components/citations/Document.svelte";
  import ProjectGrid from "./components/ProjectGrid.svelte";
  import StartingTemplates from "./components/StartingTemplates.svelte";
  import Intro from "./sections/Intro.svelte";
  import Background from "./sections/Background.svelte";
  import Methods from "./sections/Methods.svelte";
  import { citationsData } from "./data/citations";
  import Discussion from "./sections/Discussion.svelte";
  import Conclusion from "./sections/Conclusion.svelte";

  export let data: { projects: ProjectData[] };
</script>

{#if true}
  <div id="ideas-page">
    <Document {citationsData}>
      <div class="flex flex-col gap-4">
        <div class="text_body">
          <div class="flex flex-col gap-2 mb-2 mt-6">
            <h1 class="m-0">New Collabs</h1>
            <h3 class="!m-0 text-zinc-500">2024</h3>
          </div>
          <Intro />
          <div class="flex gap-4 w-full justify-center sticky my-4">
            {#each ["examples", "background", "methods", "discussion"] as sectionName}
              <a
                class="capitalize !text-zinc-800 !no-underline hover:!underline"
                href={"#" + sectionName}>{sectionName}</a
              >
            {/each}
          </div>
        </div>
        <ProjectGrid projects={data.projects} />
        <div class="text_body">
          <Background />
          <Methods />
        </div>
        <StartingTemplates />
        <Discussion />
        <Conclusion />
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
  }
</style>
