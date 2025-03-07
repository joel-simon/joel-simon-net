<script lang="ts">
  import ShaderManager from "./components/MultiShaders/ShaderManager.svelte";
  import ShaderGrid from "./components/ShaderGrid.svelte";
  import { loadShadersFromZip } from "./shaderLoader";
  import { onMount } from "svelte";
  import ShaderGridGeneration from "./components/ShaderGridGeneration.svelte";
  import Algorithm from "./sections/Algorithm.svelte";
  // import TextRadioButton from "$lib/components/TextRadioButton.svelte";
  import ArtifactGrid from "./components/ArtifactGrid.svelte";
  import ClockGallery from "./components/ClockGallery.svelte";
  import RenderWhenVisible from "$lib/components/RenderWhenVisible.svelte";

  let instance;
  let shaderDataPromise: Promise<any> | null = null;
  let singleViewId: string = "";
  let selected: string = "image-gen";
  // let selected: string = "clocks";
  const zipURL = "/lluminate/long-run.zip";

  onMount(() => {
    // shaderDataPromise = loadShadersFromZip(zipURL);
  });
</script>

<div class="text_body">
  <h1>Creative Exploration with LLMs</h1>
  <p>
    This research introduces Lluminate, an algorithm for open-ended discovery
    and exploration (illumination) with large language models (LLMs). It is an
    LLM based genetic algorithm that combines foundation models, self-reflection
    and creative thinking strategies from psychology. The goal is to both probe
    the creative boundaries of LLMs and explore new possibilities for assisted
    creative exploration. Below I demonstrate experiments across multiple
    domains as well as ablation studies, the results of which shed some light on
    the the creative process of LLMs.
  </p>

  <div class="flex gap-2 mt-2 bg-white">
    <div class="flex flex-row gap-2 items-center justify-center w-full">
      {#each ["demos", "background", "algorithm", "results", "discussion"] as section}
        <a class="!no-underline hover:!underline" href={`#${section}`}>
          {section}
        </a>
      {/each}
    </div>
  </div>

  <ShaderManager>
    <!-- {#if shaderDataPromise}
      {#await shaderDataPromise}
        <p>Loading shaders...</p>
      {:then shaderData} -->
    <!-- <h2>
          Prompt: <span class="italic">make an interesting shader</span>
        </h2> -->
    <!-- <p class="w-full !text-center">Baseline</p> -->
    <!-- <ShaderGridGeneration
          {shaderData}
          rows={2}
          cols={10}
          bind:singleViewId
        />

        <p class=" mb-1 w-full !text-center mt-8">Evolved</p>
        <ShaderGrid {shaderData} bind:singleViewId /> -->

    <ArtifactGrid
      artifactType="shaders"
      runId="long-run"
      startGeneration={[
        "80fc49f2-4b71-4f65-ad05-d0d7d1d074cf",
        "2330269e-adcf-466a-811a-5a092dda143f",
        "1c5542e2-3b04-4ed7-959f-dc107171635e",
        "b1050c04-70da-42ce-a55c-0f05ca233a20",
        "fa5938a0-a7da-4a3d-aa94-5c62c1cee08c",
        "83f624ce-c65e-4dc2-83e0-60adad728226",
        "c91a3941-c9ab-4071-8ac1-cc47808f8522",
        "6249237f-be99-48e3-b8cd-af2d9077cdaa",
        "a176c42d-bae8-4cdd-b026-b892eecfeef8",
        "6b8cab9c-d7ae-44b5-9ce6-e8865fee3a54",
        "130bf63b-9ffa-48d0-875a-43abc49da9cd",
        "a33de066-88b2-4990-b3aa-f7d470dfb6fb",
        "2b0af6ac-58f3-458c-bc43-5d1497452584",
        "36591aa9-ffbf-4c35-97a6-d8c0cb10b8b1",
        "991317b6-3329-45f6-a4e6-4d511b675ba0",
        "c5546ccf-95e4-4f61-8446-3ca9b06b468d",
        "1595db0d-32b2-40ed-b105-0e70d8030c94",
        "f82c44c8-b978-4a03-bbed-6f444df52a5c",
        "a5bd49ff-2ab7-4a54-864f-c20abcd7086d",
        "e5369118-86aa-44ac-8f61-3f0529c73281",
      ]}
    />
    <p class="my-2 w-full !text-center !text-sm">(Hover to view)</p>
    <p>
      The baseline represents what you would get by asking a chatbot such as
      ChatGPT directly. The results for "make an interesting shader" are fairly
      homogeneous with a bias towards saturated colors and rotating spiral
      patterns. This is the classic case of the language models defaulting
      towards average solutions. In the evolved map, we see a more diverse set
      of results including varied shapes, structures and colors.
    </p>
    <h2 class="w-full !text-center">Novelty analysis</h2>
    <p>
      The system explicitly searches for a set of novel solutions and works for
      any type of artifact that is generated in text and can have its embedding
      in the latent space encoded by a foundation model such as clip. We can
      analyze the increase in novelty for the run that produced the above
      shaders.
    </p>
    <div class="flex flex-row gap-2 w-full justify-center h-fit my-2">
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
      This figure illustrates the evolutionary progression of our system across
      60 generations, viewed through complementary perspectives. The novelty
      metric (left-blue), measuring average cosine distance to k=3 nearest
      neighbors, shows two distinct phases: rapid initial exploration
      (generations 0-15), steady incremental growth (15-60). Genome length
      (left-red) - which is the length of the code in characters - follows a
      similar trajectory. The UMAP visualization (right) confirms this
      progression spatially, showing early generations (purple) concentrated in
      the lower left, with a gradual expansion toward upper and rightward
      regions and rightward regions in later generations (yellow). Together,
      these patterns demonstrate sustained, non-random exploration of latent
      space with intriguing dynamics between novelty discovery and genomic
      complexity. Below I show similar results across multiple domains.
    </p>
    <!-- {:catch error}
        <p>Error loading shaders: {error.message}</p> -->
    <!-- {/await}
    {:else}
      <p>Initializing shader loader...</p>
    {/if} -->

    <!-- <ShaderGrid zipUrl="/lluminate/gen_1.zip" />
  <ShaderGrid zipUrl="/lluminate/artifacts.zip" /> -->
  </ShaderManager>
  <!-- 
  <div class="flex flex-col items-center justify-center">
    <h2>
      Prompt: <span class="italic">make a variation of the snake game</span>
    </h2>
    <p class="mb-1 w-full !text-center text-sm">(TODO show more games)</p>
  </div> -->

  <!-- <div class="w-[512px] h-[512px] max-w-full">
    <iframe srcdoc={gameTestHTML} width="100%" height="100%"></iframe>
  </div> -->
</div>
<!-- 
<div class="flex flex-row gap-2 items-center justify-center w-full my-4">
  <TextRadioButton
    bind:selected
    classes="text-xl gap-4"
    options={[
      { label: "Clocks", value: "clocks" },
      { label: "Image-Gen", value: "image-gen" },
      // { label: "Genetic-Algorithms", value: "genetic-algorithms" },
    ]}
  />
</div> -->
<div class="">
  <!-- {#if selected === "clocks"} -->
  <!-- <ArtifactGrid /> -->
  <!-- <h2>Clocks</h2> -->
  <ClockGallery />
  <div class="text_body">
    <p class="!text-sm">
      Hover to see an explanation. Creating a creative clock display is a
      standard intro to creative programming class assignment due to its vast
      creative potentials. The baseline clocks are pretty much all the same
      exact radial format with minor color variation.
    </p>
  </div>
  <!-- {:else if selected == "image-gen"} -->
  <!-- <h2>Images</h2> -->
  <RenderWhenVisible>
    <ArtifactGrid
      artifactType="image-gen"
      prompt="an architectural style that has never been seen before"
      runId="imagegen_20250303_220737"
      startGeneration={[
        "7039fbc0-9e65-4535-8567-f6f4758300b9",
        "11f1f3fb-0c6c-4f3f-9d1f-0e503ecbb2b3",
        "5d268974-d315-4b0e-afe9-4cc560266976",
        "bc3b2528-b658-49a4-872d-c001a26af936",
        "f8492131-6126-47c3-869a-f0c3a6a6a1b5",
        "df2ba192-34a6-4302-b83d-646be298189e",
        "8362e59f-e80d-4484-91c7-c52ac8ac1e58",
        "cc97c1fc-73d5-4f99-baa3-d739ea01ca72",
        "7d9efafb-a7e9-4166-97c9-5f60656f8d8d",
        "89bce5d5-56b4-4beb-ad45-2b541af17ecc",
        "2f208e8e-f57a-4dbb-b61d-e12d440f9dc8",
        "c7ee7f5d-144d-465b-8bab-bea2c1b93041",
        "50d1af4a-4dc4-4ff7-9fdb-a96b08dfc323",
        "00969cc6-3a05-4ba0-832f-f561b2bf8e9a",
        "55393203-20fb-4117-9bd4-e26698072f33",
        "8632adb7-27ee-42ff-957f-539d73d890e8",
        "5f020b8c-ef92-4a1f-97c1-06fb41e250a5",
        "e99c9e97-054d-4114-acd1-b8cf621ff85d",
        "9d0a5ec2-ac57-4e1d-baed-d0650c70f9da",
        "d6ee7e77-5ba1-4aca-a7b1-0c3970228ec4",
      ]}
    />
  </RenderWhenVisible>
  <div class="text_body">
    <p class="!text-sm">
      Image descriptions are evolved and converted into images with the flux-dev
      model. The baseline images have a consistent bobby white and neon blue
      color palette. The evolved images are more diverse and include a variety
      of styles and colors although remain limited by the capacity of the image
      generator.
    </p>
  </div>
  <div class="text_body">
    <p class=" my-4">
      All domains seem to exhibit similar novelty dynamics and remain
      unsaturated after 60 generation each.
    </p>
    <div class="flex flex-row gap-2 items-center justify-center w-full">
      <div class="flex flex-col w-fit">
        <p class="label">Shaders</p>
        <img
          src="/lluminate/long-run/novelty_plot.png"
          alt="novelty plot"
          class="h-full w-auto object-contain h-[200px]"
        />
      </div>
      <div class="flex flex-col w-fit">
        <p class="label">p5js Clocks</p>
        <img
          src="/lluminate/website_20250304_171531/novelty_plot.png"
          alt="clock novelty plot"
          class="h-full w-auto object-contain h-[200px]"
        />
      </div>
      <div class="flex flex-col w-fit">
        <p class="label">Image Prompts</p>
        <img
          src="/lluminate/imagegen_20250303_220737/novelty_plot.png"
          alt="novelty plot"
          class="h-full w-auto object-contain h-[200px]"
        />
      </div>
    </div>
  </div>

  <!-- {:else if selected == "genetic-algorithms"}
    <p>TODO</p>
  {/if} -->
</div>

<Algorithm />

<style lang="postcss">
  p.label {
    @apply !w-full !text-center;
  }
</style>
