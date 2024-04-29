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

<h1 class="text-4xl">Joel Simon</h1>

<div id="label-container" class="w-full">
  {#each labels as label}
    {#key label}
      <Label {label} {selectedLabel} />
    {/key}
  {/each}
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
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    margin: 16px;
  }
</style>
