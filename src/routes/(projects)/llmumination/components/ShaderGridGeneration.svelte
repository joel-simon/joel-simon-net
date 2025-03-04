<script lang="ts">
  import ShaderViewer from "./MultiShaders/ShaderViewer.svelte";
  import { type ShaderLoadResult } from "../shaderLoader";
  export let generation: number = 0;
  export let shaderData: ShaderLoadResult;
  export let rows = 4;
  export let cols = 4;
  export let singleViewId: string =
    shaderData.populationData[generation].genome_ids[0];

  $: genomeIds = shaderData.populationData[generation].genome_ids;
  $: shaders = genomeIds.map((id) => shaderData.shaderMap.get(id));
  // $:shades
</script>

<div
  class="shader-grid-container w-full px-2 flex flex-row gap-4 justify-center items-start"
>
  <!-- <div class="flex w-[450px] h-[450px] grow-0">
      <ShaderViewer
        fragmentShader={shaderData.shaderMap.get(singleViewId) ?? ""}
        classes="w-full h-full cursor-pointer bg-white"
      />
    </div> -->
  <div
    class="shader-grid"
    style="grid-template-rows: repeat({rows}, 1fr); grid-template-columns: repeat({cols}, 1fr);"
  >
    {#each genomeIds.slice(0, rows * cols) as genomeId, index}
      <div
        class="shader-item cursor-pointer"
        style="grid-row: {Math.floor(index / cols) + 1}; grid-column: {(index %
          cols) +
          1};"
        class:active={singleViewId === genomeId}
      >
        <ShaderViewer
          fragmentShader={shaderData.shaderMap.get(genomeId) ?? ""}
          classes="w-full h-full aspect-square cursor-pointer"
          on:mouseover={() => (singleViewId = genomeId)}
        />
      </div>
    {/each}
  </div>

  <!-- <p class="font-bold">Evolved</p> -->
  <!-- </div> -->
</div>

<style>
  .shader-grid-container {
    width: 100%;
  }

  .shader-grid {
    display: grid;
    gap: 0px;
  }

  /* .shader-name {
    margin-bottom: 0.5rem;
    font-size: 1rem;
    font-weight: bold;
  } */

  .shader-item {
    display: flex;
    flex-direction: column;
    width: 36px;
    height: 36px;
    background-color: #000;
    aspect-ratio: 1/1; /* Ensure each cell is square */
  }

  .shader-item.active {
    border: 1px solid yellow;
  }
  .shader-item:not(.active) {
    border: 1px solid #000;
  }
</style>
