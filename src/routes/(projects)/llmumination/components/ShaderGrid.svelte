<script lang="ts">
  import ShaderViewer from "./MultiShaders/ShaderViewer.svelte";
  import { type ShaderLoadResult } from "../shaderLoader";
  import { onMount } from "svelte";
  export let generation: number = 0;

  export let shaderData: ShaderLoadResult;
  export let singleViewId: string =
    shaderData.populationData[generation].genome_ids[0];

  onMount(() => {
    // singleViewId = shaderData.populationData[generation].genome_ids[0];
    singleViewId = Object.keys(shaderData.gridPositions.grid_positions)[4];
  });
  // $:shades
</script>

<div
  class="shader-grid-container w-full px-2 flex flex-col-reverse md:flex-row-reverse gap-4 justify-center items-center"
>
  {#if shaderData.error}
    <div class="error">Error: {shaderData.error}</div>
  {:else}
    <div class="flex w-[350px] h-[350px] grow-0">
      <ShaderViewer
        fragmentShader={shaderData.shaderMap.get(singleViewId) ?? ""}
        classes="w-full h-full cursor-pointer bg-white"
      />
    </div>
    <!-- {:else} -->
    <div class="flex flex-col grow-0">
      <div
        class="shader-grid w-[450px] h-[450px]"
        style="grid-template-rows: repeat({shaderData.gridPositions
          .rows}, 1fr); grid-template-columns: repeat({shaderData.gridPositions
          .cols}, 1fr);"
      >
        {#each Object.entries(shaderData.gridPositions.grid_positions) as [id, cell]}
          <div
            class="shader-item cursor-pointer"
            style="grid-column: {cell.j + 1}; grid-row: {cell.i + 1};"
            class:active={singleViewId === id}
          >
            <ShaderViewer
              fragmentShader={shaderData.shaderMap.get(id) ?? ""}
              classes="w-full h-full aspect-square cursor-pointer"
              on:mouseover={() => (singleViewId = id)}
            />
          </div>
        {/each}
      </div>
      <!-- <p class="font-bold">Evolved</p> -->
    </div>
  {/if}
</div>

<style>
  .shader-grid-container {
    width: 100%;
  }

  .loading,
  .error,
  .no-shaders {
    padding: 2rem;
    text-align: center;
  }

  .error {
    color: red;
  }

  .shader-grid {
    display: grid;
    gap: 0px;
    aspect-ratio: 1/1; /* Make the entire grid square */
  }

  /* .shader-name {
    margin-bottom: 0.5rem;
    font-size: 1rem;
    font-weight: bold;
  } */

  .shader-item {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
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
