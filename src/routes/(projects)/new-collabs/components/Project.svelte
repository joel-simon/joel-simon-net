<script lang="ts">
  import { type ProjectData } from "../types";

  export let project: ProjectData;
  // export let hoveredProject: ProjectData | null = null;
  $: displayDescription = project.project.projectDescription.startsWith(
    "Create "
  )
    ? project.project.projectDescription.slice(7).charAt(0).toUpperCase() +
      project.project.projectDescription.slice(8)
    : project.project.projectDescription.charAt(0).toUpperCase() +
      project.project.projectDescription.slice(1);
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<!-- <div
  class="relative p-2 px-8 cursor-pointer transition border-b border-r border-dashed border-gray-200 flex flex-col justify-between hover:bg-sky-50"
> -->
<!-- Content of the project -->
<h2 class="text-lg font-bold relative z-10">
  {project.project.projectName}
</h2>
<p class="text-sm text-gray-600 mb-2 relative z-10 text-justify">
  {displayDescription}
</p>
<!-- <div class="flex flex-grow"></div> -->
<p class="text-sm relative z-10 lowercase">
  <!-- <a href=></a> -->
  <a
    on:click|stopPropagation
    href="https://twitter.com/{project.creatorNames[0]}"
    target="_blank"
    class="font-semibold hover:underline"
    rel="noopener noreferrer">{project.creatorNames[0]}</a
  >
  <a
    on:click|stopPropagation
    href="https://twitter.com/{project.creatorNames[1]}"
    target="_blank"
    class="font-semibold hover:underline"
    rel="noopener noreferrer">{project.creatorNames[1]}</a
  >
  <!-- {project.creatorNames.join(", ")} -->
</p>
<!-- </div> -->
