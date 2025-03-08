<script lang="ts">
  import { fetchJson } from "$lib/Network";
  import { onMount } from "svelte";
  import { type GridPositions } from "../shaderLoader";
  import ShaderViewer from "./MultiShaders/ShaderViewer.svelte";

  let singleViewId: string | null = null;
  export let runId = "website_20250304_171531";
  export let prompt = "a creative time display.";
  export let artifactType = "website";
  export let startGeneration = [
    "aa4c77e1-e27c-4ce8-b182-ccf0c46181eb",
    "c37b9110-03f1-4ba2-8abe-e605c3f58c30",
    "e6250cfd-288b-42b6-a0d6-f160d6b1323d",
    "4180aff4-9891-466c-959f-b3eaea9aa1f4",
    "1068ec40-84c6-480c-b5df-d0c6d9f02562",
    "29ba48f2-35fd-4582-a7f9-c9da3c44492b",
    "334a469b-a331-4a2c-81da-7998bcef9363",
    "ddceff75-6464-42ad-9ada-77c0c9b2430d",
    "c42c1925-0a30-4675-854f-efe18ab5bc72",
    "3ce321a3-5665-4937-87be-89117f80bbc9",
    "800d764b-78cf-4cbb-8838-02878f31b040",
    "cbb9fe35-f210-4e42-aa1e-f3faad162074",
    "f9ef869d-35aa-4ff6-860f-09e2b89b3a6d",
    "4f361d98-4260-4c4a-8fe4-2d62e751a22d",
    "cb5a90c4-ad67-497f-8b79-72cbf9e2d047",
    "9173305a-ebc6-4c22-8431-6f79f7ac12f0",
    "ff9de492-fab9-48a8-8f4c-5c84f9a73a02",
    "7a8a905b-3612-4339-8ade-e7a171403716",
    "c81f0dc6-e899-4c46-8815-77a917a91b0a",
    "b322a583-27c5-4f08-baad-fe7e83a4e13a",
  ];

  let gridDataPromise: Promise<GridPositions> | null = null;
  let gridData: GridPositions | null = null;

  const iframeUrl = (key: string) =>
    `/lluminate/${runId}/artifacts/source/${key}.html`;
  const thumbnailUrl = (key: string) =>
    `/lluminate/${runId}/artifacts/thumbnails/${key}_small.webp`;
  const imageUrl = (key: string) =>
    `/lluminate/${runId}/artifacts/images/${key}.jpg`;

  const shaderMap = new Map<string, string>();
  const getShaderSource = async (key: string) => {
    if (shaderMap.has(key)) {
      return shaderMap.get(key);
    }
    const response = await fetch(
      `/lluminate/${runId}/artifacts/source/${key}.glsl`
    );
    const text = await response.text();
    shaderMap.set(key, text);
    return text;
  };

  function randomKey(gridData: GridPositions) {
    return Object.keys(gridData.grid_positions)[
      Math.floor(Math.random() * Object.keys(gridData.grid_positions).length)
    ];
  }

  let iframeElement: HTMLIFrameElement;

  onMount(async () => {
    gridDataPromise = fetchJson<GridPositions>(
      `/lluminate/${runId}/grid_positions.json`
    );
    gridData = await gridDataPromise;
    singleViewId = randomKey(gridData);
  });
</script>

<h2 class="my-4">
  Prompt: <span class="italic">{prompt}</span>
</h2>
<p>Baseline</p>
<div class="generation-grid max-w-full">
  {#each startGeneration as key}
    <div
      class="grid-cell cursor-pointer"
      class:!w-[36px]={artifactType == "shaders"}
      class:!h-[36px]={artifactType == "shaders"}
      on:mouseover={() => (singleViewId = key)}
      on:click={() => {
        singleViewId = key;
      }}
      class:active={singleViewId === key}
    >
      {#if artifactType == "shaders"}
        {#await getShaderSource(key) then source}
          <ShaderViewer
            fragmentShader={source}
            classes="w-full h-full aspect-square cursor-pointer"
          />
        {/await}
      {:else}
        <img
          src={thumbnailUrl(key)}
          class="w-full h-full aspect-square cursor-pointer"
        />
      {/if}
    </div>
  {/each}
</div>
<div
  class="shader-grid-container w-full px-2 flex flex-col-reverse md:flex-row-reverse gap-4 justify-center items-center mt-4"
>
  {#if gridData && singleViewId}
    <div class="flex w-[384px] h-[384px] m-4">
      {#if artifactType === "website"}
        <iframe
          bind:this={iframeElement}
          width="384"
          height="384"
          src={iframeUrl(singleViewId)}
          class="w-full h-full cursor-pointer bg-white"
        ></iframe>
      {:else if artifactType == "shaders"}
        <!-- <div class="w-[384px] h-[384px] drop-shadow"> -->
        {#await getShaderSource(singleViewId) then source}
          <ShaderViewer
            fragmentShader={source}
            classes="w-[full] h-[full] aspect-square
               cursor-pointer"
          />
        {/await}
        <!-- </div> -->
      {:else if artifactType == "image-gen"}
        <img src={imageUrl(singleViewId)} class="w-full h-full object-cover" />
      {/if}
    </div>
    <!-- {:else} -->
    <div class="flex flex-col grow-0">
      <p>Evolved</p>
      <div
        class="shader-grid w-[350px] h-[350px] md:w-[450px] md:h-[450px]"
        style="grid-template-rows: repeat({gridData.rows}, 1fr); grid-template-columns: repeat({gridData.cols}, 1fr);"
      >
        {#each Object.entries(gridData.grid_positions) as [id, cell]}
          <div
            class="generation-item cursor-pointer"
            style="grid-column: {cell.j + 1}; grid-row: {cell.i + 1};"
            class:active={singleViewId === id}
            on:mouseover={() => (singleViewId = id)}
            on:click={() => {
              singleViewId = id;
            }}
          >
            {#if artifactType == "shaders"}
              {#await getShaderSource(id) then source}
                <ShaderViewer
                  fragmentShader={source}
                  classes="w-full h-full aspect-square cursor-pointer"
                />
              {/await}
            {:else}
              <img
                src={thumbnailUrl(id)}
                class="w-full h-full aspect-square cursor-pointer"
              />
            {/if}
          </div>
        {/each}
      </div>
    </div>
  {/if}
</div>

<!-- <div class="text_body">
  <div class="flex flex-row gap-2 w-full justify-center h-fit my-2">
    <div class="flex w-fit max-h-[200px]">
      <img
        src="/lluminate/long-run/novelty_plot.png"
        alt="gen_2"
        class="object-contain"
      />
    </div>
    <div class="flex w-fit max-h-[200px]">
      <img
        src="/lluminate/long-run/latents_by_generation_umap.png"
        alt="gen_1"
        class=" object-contain"
      />
    </div>
  </div>
</div> -->

<style lang="postcss">
  .shader-grid-container {
    width: 100%;
  }

  .error {
    color: red;
  }
  p {
    @apply w-full !text-center;
    font-size: 1.25em;
  }
  .shader-grid {
    display: grid;
    gap: 0px;
    aspect-ratio: 1/1; /* Make the entire grid square */
  }

  .generation-item {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100%;
    background-color: #000;
    aspect-ratio: 1/1; /* Ensure each cell is square */
  }

  .generation-item.active {
    border: 1px solid yellow;
  }
  .generation-item:not(.active) {
    border: 1px solid #000;
  }

  .generation-grid {
    display: grid;
    grid-template-columns: repeat(10, auto);
    grid-template-rows: repeat(2, auto);
    gap: 0px;
    width: fit-content;
    margin: 0 auto;
  }

  .grid-cell {
    width: 48px;
    height: 48px;
    overflow: hidden;
    background-color: #000;
  }

  /* Add responsive sizing for mobile */
  @media (max-width: 768px) {
    .generation-grid {
      grid-template-columns: repeat(10, 36px);
      grid-template-rows: repeat(2, 36px);
    }

    .grid-cell {
      width: 36px;
      height: 36px;
    }
  }

  /* For very small screens */
  @media (max-width: 480px) {
    .generation-grid {
      grid-template-columns: repeat(10, 36px);
      grid-template-rows: repeat(2, 36px);
    }

    .grid-cell {
      width: 36px;
      height: 36px;
    }
  }

  .grid-cell.active {
    border: 1px solid yellow;
  }

  .grid-cell:not(.active) {
    border: 1px solid #000;
  }
</style>
