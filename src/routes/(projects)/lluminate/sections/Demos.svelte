<script lang="ts">
  import ShaderManager from "../components/MultiShaders/ShaderManager.svelte";
  import ShaderGrid from "../components/ShaderGrid.svelte";
  import { loadShadersFromZip } from "../shaderLoader";
  import { onMount } from "svelte";
  import ShaderGridGeneration from "../components/ShaderGridGeneration.svelte";
  import ArtifactGrid from "../components/ArtifactGrid.svelte";
  import ClockGallery from "../components/ClockGallery.svelte";
  import ClickToModal from "$lib/components/ClickToModal.svelte";
  import RenderWhenVisible from "$lib/components/RenderWhenVisible.svelte";
</script>

<div class="text_body overflow-x-hidden">
  <ShaderManager>
    <div id="demos" />
    <ArtifactGrid
      prompt="make an interesting shader"
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
      If you wanted the code for a shader animation, the baseline (above)
      represents what you could get by asking a chatbot such as ChatGPT to "make
      an interesting shader". The results are fairly homogeneous with a bias
      towards saturated colors and rotating spiral patterns. This is the classic
      case of the language models defaulting towards average solutions.
      Lluminate can evolve a more diverse set of results including varied
      shapes, structures and colors.
    </p>
    <h2 class="w-full !text-center">Novelty analysis</h2>
    <p>
      The system explicitly searches for a set of novel solutions and works for
      any type of text or image output. These are represented in a semantic
      space using CLIP (Contrastive Language-Image Pretraining), an AI model
      that understands relationships between images and text. This allows us to
      measure how different and innovative each solution is compared to others.
      We can analyze the increase in novelty for the run that produced the above
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
      This figure illustrates the evolutionary progression across 60
      generations, viewed through complementary perspectives. The novelty metric
      (left-blue), measuring average cosine distance to k=3 nearest neighbors,
      shows two distinct phases: rapid initial exploration (generations 0-15),
      steady incremental growth (15-60). Genome length (left-red) - which is the
      length of the code in characters - follows a similar trajectory. The UMAP
      visualization (right) confirms this progression spatially, showing early
      generations (purple) concentrated in the lower left, with a gradual
      expansion toward upper and rightward regions in later generations
      (yellow). Together, these patterns demonstrate sustained exploration of
      latent space with intriguing dynamics between novelty discovery and
      genomic complexity.
    </p>
  </ShaderManager>
</div>

<div class="">
  <ClockGallery />
  <div class="text_body">
    <p class="!text-sm">
      Hover to see an explanation. Creating a creative clock display is a
      standard intro to creative programming class assignment due to its vast
      creative potentials. The baseline clocks are pretty much all the same
      exact radial format with minor color variation.
    </p>
  </div>

  <!-- <RenderWhenVisible>
    <ArtifactGrid
      artifactType="image-gen"
      prompt="a full glass of wine"
      runId="image_gen_20250312_143222"
      startGeneration={[
        "a3aaccf7-36c9-4de2-9d4f-03abab4bdea1",
        "7a66996a-ca98-4988-95e5-802aee3de163",
        "3363f24b-ecf1-4e2b-abd0-9cc3aa89af8a",
        "5f661d0f-2b48-44c6-98ae-554960410447",
        "a1760403-38d0-4999-8ce0-ddd44b24ea04",
        "47844208-2cd5-4f60-89e0-100188afce21",
        "e640e91b-3921-4d8b-8e8e-cba2d62cead7",
        "d98b4a58-806d-4be9-99da-f6a4d0aa1c0f",
        "dbf866c4-42fc-461f-9a42-b6d81a816e95",
        "88d09f63-c615-49f1-bfc8-a3994d6012b5",
        "d029a783-777b-44be-8851-7a5554dcf12f",
        "8fd640eb-2bc9-43a7-8ddf-d69753e6d7a5",
        "c0680555-0875-4b37-a1d7-780626d98c5c",
        "c01a46f1-5e10-423c-975b-3862539f3e3d",
        "f4f52ec7-c2af-4649-85f6-e455971b4174",
        "8c5c2246-361a-49cb-b5fe-b7c6ec41d4cc",
        "b0667824-3992-486e-8d14-dfccc3819107",
        "f86b5e57-0661-4424-8b09-852ec98dcb95",
        "a0391a4c-8226-4c63-8458-f27a6a4ad481",
        "9e1a9b68-5843-4cb6-9506-88ebafe62366",
      ]}
    />
  </RenderWhenVisible> -->
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
    <p class="!text-sm mt-2">
      Image descriptions are evolved and converted into images with the Flux-dev
      model. The baseline images have a consistent bobby white and neon blue
      color palette. The evolved images are more diverse and include a variety
      of styles and colors although remain limited by the capacity of the image
      generator.
    </p>
  </div>
  <div class="text_body">
    <p class=" my-4">
      All domains exhibit similar novelty dynamics and remain unsaturated after
      60 generation each.
    </p>
    <div
      class="flex flex-row gap-2 items-center md:justify-center w-full relative overflow-x-auto"
    >
      <div class="flex flex-col w-fit shrink-0">
        <ClickToModal let:isOpen>
          <p class="label">Shaders</p>
          <img
            src="/lluminate/long-run/novelty_plot.png"
            alt="novelty plot"
            class="h-full w-auto object-contain min-w-[200px]"
            class:h-[200px]={!isOpen}
          />
        </ClickToModal>
      </div>
      <div class="flex flex-col w-fit shrink-0">
        <ClickToModal let:isOpen>
          <p class="label">p5js Clocks</p>
          <img
            src="/lluminate/website_20250304_171531/novelty_plot.png"
            alt="clock novelty plot"
            class="h-full w-auto object-contain h-[200px] min-w-[200px]"
            class:h-[200px]={!isOpen}
          />
        </ClickToModal>
      </div>
      <div class="flex flex-col w-fit shrink-0">
        <ClickToModal let:isOpen>
          <p class="label">Image Prompts</p>
          <img
            src="/lluminate/imagegen_20250303_220737/novelty_plot.png"
            alt="novelty plot"
            class="h-full w-auto object-contain h-[200px] min-w-[200px]"
            class:h-[200px]={!isOpen}
          />
        </ClickToModal>
      </div>
    </div>
  </div>
</div>
