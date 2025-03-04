<script lang="ts">
  import { onMount } from "svelte";
  import mermaid from "mermaid";

  // Props
  export let diagram: string = "";
  export let config: any = {
    startOnLoad: true,
    theme: "default",
    logLevel: "fatal",
    securityLevel: "strict",
    // fontFamily: "monospace",
  };
  export let id: string =
    "mermaid-diagram-" + Math.random().toString(36).substring(2, 9);
  export let className: string = "";

  let element: HTMLElement;
  let rendered = false;

  // Initialize mermaid
  onMount(() => {
    mermaid.initialize(config);
    renderDiagram();
    setTimeout(() => {
      // console.log("rendered");
      // renderDiagram();
    }, 1000);
  });

  // Watch for diagram content changes
  // Watch for diagram content changes
  // $: if (diagram && element && mermaid) {
  //   renderDiagram();
  // }

  async function renderDiagram() {
    if (!diagram || !element) return;

    try {
      // Clear previous rendering
      element.innerHTML = "";
      rendered = false;

      // Check for valid diagram syntax
      const { svg } = await mermaid.render(id, diagram);
      element.innerHTML = svg;
      rendered = true;
      const svgElement = element.querySelector("svg");
      if (svgElement) {
        svgElement.style.width = "100%";
        svgElement.style.maxWidth = "none";
        svgElement.style.height = "auto";
        svgElement.setAttribute("preserveAspectRatio", "xMinYMin meet");
      }
    } catch (error: any) {
      console.error("Mermaid rendering error:", error);
      element.innerHTML = `<pre class="error">Error rendering diagram: ${error.message}</pre>`;
    }
  }
</script>

<div
  bind:this={element}
  class="mermaid-container w-full {className}"
  class:rendered
  aria-label="Mermaid diagram"
>
  {#if !rendered}
    <pre>{diagram}</pre>
  {/if}
</div>

<style>
  .mermaid-container {
    width: 100%;
    overflow: auto;
  }

  .mermaid-container.rendered :global(svg) {
    max-width: 100%;
    height: auto;
  }

  .error {
    color: red;
    padding: 1rem;
    background-color: #ffeeee;
    border-left: 3px solid red;
  }
</style>
