<script lang="ts">
  import { projects } from "$lib/data";
  import { getHref } from "$lib/Projects";

  export let projectName: string;
  $: project = projects.find((p) => p.name == projectName);
  //   $: console.log(projectName, project?.externalPath ?? project?.path);
</script>

{#if project}
  <a
    class="!no-underline rounded-xl h-20 shadow hover:shadow-md flex cursor-pointer overflow-hidden"
    href={getHref(project)}
    target={project.externalPath ? "_blank" : "_self"}
  >
    <!-- <div class=""> -->
    <img src={project.img} class="h-full" />
    <div class="flex flex-col m-1 my-2">
      <p class="!text-left !text-sm !md:text-lg no-underline">{project.name}</p>
      <!-- <p class="!text-left">{project.description}</p> -->
    </div>
    <!-- </div> -->
  </a>
{/if}
