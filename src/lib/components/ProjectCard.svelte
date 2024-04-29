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
    <a href={state.path} data-sveltekit-reload target={state.target}>
      <div class="preview-container">
        <img src={project.img} alt={project.name} title={project.name} />
        <div class="description-container">
          {#if project.description}
            <p class="description">{project.description}</p>
          {/if}
        </div>
      </div>
      <div class="project-content show-on-hover">
        <h3 class="project-name">{project.name}</h3>
        <div class="project-labels">
          {#each state.labels as label}
            <Label {label} {selectedLabel} />
          {/each}
        </div>
      </div>
    </a>
  </div>
{/if}
