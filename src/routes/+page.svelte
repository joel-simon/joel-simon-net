<script lang="ts">
  import Label from "$lib/components/Label.svelte";
  import ProjectCard from "$lib/components/ProjectCard.svelte";
  import HeadTags from "$lib/components/HeadTags.svelte";
  import { labels, projects } from "$lib/data";
  import { writable, type Writable } from "svelte/store";

  const selectedLabel: Writable<string | null> = writable(null);
</script>

<HeadTags
  title="Joel Simon"
  description="Joel Simon Website portfolio project"
  imagePath="/imgs/cornered-hands/1.jpg"
  type="blog"
/>

<h1 class="text-4x -mb-1">Joel Simon</h1>

<div
  id="label-container"
  class="w-full my-4 md:my-6 sticky top-0 bg-white z-10 py-2"
>
  <div class="flex md:gap-2 w-full justify-center flex-wrap">
    {#each labels as label}
      {#key label}
        <Label {label} {selectedLabel} />
      {/key}
    {/each}
  </div>
</div>

<div id="project-container">
  {#each projects as project}
    {#key project.name}
      <ProjectCard {project} {selectedLabel} />
    {/key}
  {/each}
</div>

<style>
  #project-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(325px, max-content));
    padding-left: 24px;
    padding-right: 24px;
    gap: 24px;
    justify-items: center;
    justify-content: center;
  }

  @media (max-width: 768px) {
    #project-container {
      grid-template-columns: repeat(2, 1fr);
      padding-left: 8px;
      padding-right: 8px;
      gap: 8px;
    }
  }

  :global(.label) {
    /*float: left;*/
    color: gray;
    display: inline-block;
    margin-right: 1em;
    text-transform: capitalize;

    -webkit-touch-callout: none; /* iOS Safari */
    -webkit-user-select: none; /* Safari */
    -khtml-user-select: none; /* Konqueror HTML */
    -moz-user-select: none; /* Firefox */
    -ms-user-select: none; /* Internet Explorer/Edge */
    user-select: none; /* Non-prefixed version, currently
										supported by Chrome and Opera */
  }
  #label-container h3 {
    margin: 0px;
  }

  :global(.label.label-hidden) {
    opacity: 0.3;
  }

  :global(.label h3:hover) {
    cursor: pointer;
    text-decoration: underline;
  }

  /* -------------------------------------------------------------------------- */
  /* Projects. */
</style>
