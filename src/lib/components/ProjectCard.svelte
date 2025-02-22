<script lang="ts">
  import type { Project } from "$lib/types";
  import Label from "$lib/components/Label.svelte";
  import type { Writable } from "svelte/store";
  import * as Projects from "$lib/Projects";

  export let project: Project;
  export let selectedLabel: Writable<string | null>;

  $: state = getState(project, $selectedLabel);

  interface State {
    labels: string[];
    classes: string;
    path: string;
    target: string;
    visible: boolean;
  }

  // We've packaged up all the logic for computing e.g. the classes and
  // the href to the project in this function so we can easily make it reactive.
  function getState(project: Project, selectedLabel: string | null): State {
    const visible = isVisible(project, selectedLabel);
    const labels = getLabels(project);

    const slug = Projects.getSlug(project);
    const classes = [...labels, slug].join(" ");

    const path = Projects.getHref(project);
    const target = project.externalPath ? "_blank" : "";

    return {
      visible,
      labels,
      classes,
      path,
      target,
    };
  }

  // Determines whether to show a project based on the label the user has selected.
  function isVisible(project: Project, selectedLabel: string | null): boolean {
    if (selectedLabel == null) {
      return true;
    }

    return (
      project.labels.includes(selectedLabel) ||
      project.year?.toString() === selectedLabel
    );
  }

  // Add year to labels if it exists.
  function getLabels(project: Project): string[] {
    // Make a copy of the labels array so we don't mutate the original.
    const labels = [...project.labels];
    if (project.year) {
      labels.push(project.year.toString());
    }

    return labels;
  }
</script>

{#if !project.hide}
  <div
    class="project {state.classes}"
    style="display: {state.visible ? 'block' : 'none'}"
  >
    <!-- use data-sveltekit-reload to let the browser handle these links. -->
    <a
      href={state.path}
      data-sveltekit-reload
      target={state.target}
      class="hover:drop-shadow-lg transition-all"
    >
      <div class="preview-container hover:drop-shadow-2xl">
        <img
          class="main-image"
          src={project.img}
          alt={project.name}
          title={project.name}
        />
        <div
          class="description-container flex flex-col justify-center items-center"
        >
          <!-- {#if project.description} -->
          <p class="description text-lg">
            {project.description ?? project.name}
          </p>
          <!-- {/if} -->
        </div>
      </div>
      <div class="project-content mt-1">
        <div class="flex w-full justify-center">
          {#if project.externalPath}
            <!-- Offset -->
            <img
              class="opacity-0"
              style="width:28px;height:28px;"
              src="/imgs/icons/arrow-up-right.svg"
            />
          {/if}
          <h3 class="project-name text-lg">
            {project.name}
          </h3>
          {#if project.externalPath}
            <img
              style="width:28px;height:28px;"
              src="/imgs/icons/arrow-up-right.svg"
            />
          {/if}
        </div>

        <div class="project-labels show-on-hover">
          {#each state.labels as label}
            <Label {label} {selectedLabel} />
          {/each}
        </div>
      </div>
    </a>
  </div>
{/if}

<style>
  .project {
    width: 100%;
    /* width: 375px; */
    max-width: 400px;
    /* height: 200px; */
    display: flex;
    /* max-width: 350px;
    min-width: 300px; */
    flex-grow: 1;
    display: flex;
    /* background-color: red; */

    transition: all 0.2s ease-in-out;
    vertical-align: top;
    /* margin: 16px;
    margin-bottom: 0px; */
    /* position: relative; */
    /* overflow: hidden; */
    /* padding-bottom: 4px; */
  }
  .project .preview-container {
    position: relative;
    /* display: flex; */
    /* background-color: white; */
    -webkit-mask-image: url(/imgs/squircles/squircle_6.2.png);
    mask-image: url(/imgs/squircles/squircle_6.2.png);
    mask-size: cover;
    mask-size: 100%, 100%;
    -webkit-mask-size: cover;
    -webkit-mask-size: 100%, 100%;
    mask-repeat: no-repeat;
    -webkit-mask-repeat: no-repeat;
  }

  .project:hover .description-container {
    background: rgba(0, 0, 0, 0.7);
    opacity: 1;
  }

  .description-container {
    width: 100%;
    height: 100%;
    text-align: center;
    position: absolute;
    opacity: 0;
    bottom: 0px;

    -webkit-transition: background-color 150ms ease;
    -ms-transition: background-color 150ms ease;
    transition: background-color 150ms ease;

    backdrop-filter: blur(4px);
  }
  .project .description {
    color: white;
    opacity: 1;
    /* font-size: 1.2em; */
    margin: 16px;
  }

  .project .main-image {
    width: 100%;
    /* width: 315px; */
  }

  .show-on-hover {
    opacity: 0;
  }
  .project:hover .show-on-hover {
    opacity: 1;
  }

  .project.forms-of-life img {
    image-rendering: pixelated;
    filter: drop-shadow(0px 0px 4px rgba(0, 0, 0, 0.4));
  }

  .project.reaction-diffusion-3d img {
    filter: invert() drop-shadow(0px 0px 4px rgba(0, 0, 0, 0.4));
  }

  /* -------------------------------------------------------------------------- */
  /* Labels in projects. */

  .project .label h3 {
    margin-top: 0px;
    margin-bottom: 0px;
  }
</style>
