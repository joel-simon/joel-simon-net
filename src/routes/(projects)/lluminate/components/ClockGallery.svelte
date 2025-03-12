<script lang="ts">
  import { fetchJson } from "$lib/Network";
  import { onMount } from "svelte";
  import { type GridPositions } from "../shaderLoader";
  import HTMLContainer from "$lib/components/HTMLContainer.svelte";
  import { shuffle } from "$lib/Random";
  import ClickToModal from "$lib/components/ClickToModal.svelte";

  export let runId = "website_20250304_171531";
  export let prompt = "a creative time display.";
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

  const iframeUrl = (key: string) =>
    `/lluminate/${runId}/artifacts/source/${key}.html`;

  function randomKeyOrdering(gridData: GridPositions): string[] {
    const keys = Object.keys(gridData.grid_positions);
    shuffle(keys);
    return keys;
  }

  onMount(() => {
    gridDataPromise = fetchJson<GridPositions>(
      `/lluminate/${runId}/grid_positions.json`
    );
  });
</script>

<h2 class="my-8">
  Prompt: <span class="italic">{prompt}</span>
</h2>
<p>Baseline</p>
<div class="flex w-screen overflow-x-auto gap-2 px-2 pb-4">
  {#each startGeneration as key}
    <ClickToModal let:isOpen classes="relative">
      {#if !isOpen}
        <div
          class="w-[256px] h-[256px] absolute top-0 left-0 z-10 pointer-events-auto cursor-pointer"
          style="pointer-events: auto;"
        ></div>
      {/if}
      <HTMLContainer
        htmlSource={iframeUrl(key)}
        width={isOpen ? "512px" : "256px"}
        height={isOpen ? "512px" : "256px"}
        scale={isOpen ? 1 : 0.5}
      />
    </ClickToModal>
  {/each}
</div>
<div class="flex flex-col w-full">
  {#if gridDataPromise}
    {#await gridDataPromise}
      <p>Loading grid data...</p>
    {:then gridData}
      <div class="flex w-full flex-col">
        <p>Evolved</p>
        <div class="flex w-screen overflow-x-auto gap-2 px-2 pb-4">
          {#each randomKeyOrdering(gridData) as id}
            <HTMLContainer
              htmlSource={iframeUrl(id)}
              width="256px"
              height="256px"
              scale={0.5}
            />
          {/each}
        </div>
      </div>
    {/await}
  {/if}
</div>

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
    grid-template-columns: repeat(10, 36px);
    grid-template-rows: repeat(2, 36px);
    gap: 0px;
    width: fit-content;
    margin: 0 auto;
  }

  .grid-cell {
    width: 36px;
    height: 36px;
    overflow: hidden;
    background-color: #000;
  }

  .grid-cell.active {
    border: 1px solid yellow;
  }

  .grid-cell:not(.active) {
    border: 1px solid #000;
  }
</style>
