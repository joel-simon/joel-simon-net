<script lang="ts">
  import ShaderManager from "./components/MultiShaders/ShaderManager.svelte";
  import ShaderGrid from "./components/ShaderGrid.svelte";
  import gameTestHTML from "./data/gametest.html?raw";
  import { loadShadersFromZip } from "./shaderLoader";
  import { onMount } from "svelte";
  import ShaderGridGeneration from "./components/ShaderGridGeneration.svelte";
  import Algorithm from "./sections/Algorithm.svelte";

  let instance;
  let shaderDataPromise: Promise<any> | null = null;
  let singleViewId: string = "";

  //   const zipURL = "/lluminate/shader_strat_variation_medium_summ_seed42.zip";
  const zipURL = "/lluminate/long-run.zip";
  //   const zipURL = "/lluminate/longer-shader-run-128.zip";

  onMount(() => {
    shaderDataPromise = loadShadersFromZip(zipURL);
  });
</script>

<div class="text_body">
  <h1>Creative Exploration with LLMs</h1>
  <p>
    This research introduces an algorithm for open-ended discovery with large
    large language models (LLMs). It is an LLM based genetic algorithm that
    combines foundation models, self-reflection and creative thinking strategies
    from psychology. The goal is to both probe the creative boundaries of LLMs
    and explore new possibilities for assisted creative exploration. Below I
    demonstrate several experiments across multiple domains as well as ablation
    studies on the algorithm.
  </p>

  <!-- {#each ["methods", "experiments", "results"] as section}
  <div class="flex flex-row gap-2 items-center justify-center w-full">
    <a href={`#${section}`}>{section}</a>
  </div>
{/each} -->

  <ShaderManager>
    {#if shaderDataPromise}
      {#await shaderDataPromise}
        <p>Loading shaders...</p>
      {:then shaderData}
        <h2>
          Prompt: <span class="italic">make an interesting shader</span>
        </h2>
        <p class="w-full !text-center">Baseline</p>
        <ShaderGridGeneration
          {shaderData}
          rows={2}
          cols={10}
          bind:singleViewId
        />

        <p class=" mb-1 w-full !text-center mt-8">Evolved</p>
        <p class="mb-1 w-full !text-center !text-small">Hover to view</p>
        <ShaderGrid {shaderData} bind:singleViewId />
        <p>
          The baseline represents what you would get by asking a chatbot such as
          ChatGPT directly. The results for "make an interesting shader" are
          fairly homogeneous with a bias towards saturated colors and rotating
          spiral patterns. This is the classic case of the language models
          defaulting towards average solutions. In the evolved map, we see a
          more diverse set of results including varied shapes, structures and
          colors.
        </p>
        <p class="w-full !text-center">Novelty analysis</p>
        <div class="flex flex-row gap-2 w-full justify-center h-fit">
          <div class="max-h-[300px]">
            <img
              src="/lluminate/long-run/novelty_plot.png"
              alt="gen_2"
              class="h-full w-auto object-contain"
            />
          </div>
          <div class="max-h-[300px]">
            <img
              src="/lluminate/long-run/latents_by_generation_umap.png"
              alt="gen_1"
              class="h-full w-auto object-contain"
            />
          </div>
        </div>
        <p class="!text-sm">
          This figure illustrates the evolutionary progression of our system
          across 60 generations, viewed through complementary perspectives. The
          novelty metric (blue), measuring average cosine distance to k-nearest
          neighbors, shows three distinct phases: rapid initial exploration
          (generations 0-10), steady incremental growth (10-20), and a mature
          phase of oscillation with continued innovation (20-60). Genome length
          (red) follows a similar trajectory but with a notable delay in early
          generations and step-like increases around generations 25 and 50,
          suggesting complexity thresholds that enable new capabilities. The
          UMAP visualization confirms this progression spatially, showing early
          generations (purple) concentrated in the lower left, with a gradual
          expansion toward upper and rightward regions in later generations
          (yellow). Together, these patterns demonstrate sustained, non-random
          exploration of latent space with intriguing dynamics between novelty
          discovery and genomic complexity.
        </p>
      {:catch error}
        <p>Error loading shaders: {error.message}</p>
      {/await}
    {:else}
      <p>Initializing shader loader...</p>
    {/if}

    <!-- <ShaderGrid zipUrl="/lluminate/gen_1.zip" />
  <ShaderGrid zipUrl="/lluminate/artifacts.zip" /> -->
  </ShaderManager>

  <div class="flex flex-col items-center justify-center">
    <h2>
      Prompt: <span class="italic">make a variation of the snake game</span>
    </h2>
    <p class="mb-1 w-full !text-center text-sm">(TODO show more games)</p>
  </div>

  <div class="w-[512px] h-[512px] max-w-full">
    <iframe srcdoc={gameTestHTML} width="100%" height="100%"></iframe>
  </div>
</div>

<Algorithm />

<style>
  .panzoom-wrapper {
    width: 100%;
    height: 80vh; /* Set an explicit height */
    position: relative;
    overflow: hidden;
    /* background-color: red; */
    border: 1px solid black;
  }
</style>
