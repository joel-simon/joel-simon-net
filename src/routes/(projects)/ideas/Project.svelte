<script lang="ts">
  import { type ProjectData } from "./types";

  export let project: ProjectData;
  export let selectedProject: ProjectData | null = null;
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="relative p-2 px-8 cursor-pointer transition border-b border-r border-dashed border-gray-200 flex flex-col justify-between hover:bg-sky-50"
  class:selected={selectedProject === project}
  class:bg-sky-100={selectedProject === project}
  on:click={() => (selectedProject = project)}
  on:mouseover={() => (selectedProject = project)}
>
  <!-- Content of the project -->
  <h2 class="text-lg font-bold relative z-10">
    {project.project.projectName}
  </h2>
  <p class="text-sm text-gray-600 mb-2 relative z-10 text-justify">
    {project.project.projectDescription}
  </p>
  <!-- <div class="flex flex-grow"></div> -->
  <p class="text-sm font-semibold relative z-10">
    <!-- <a href=></a> -->
    {project.creatorNames[0]}
    {project.creatorNames[1]}
    <!-- {project.creatorNames.join(", ")} -->
  </p>
</div>
