<script lang="ts">
  import Algorithm from "./sections/Algorithm.svelte";
  import Intro from "./sections/Intro.svelte";
  import Demos from "./sections/Demos.svelte";
  import { citationsData } from "./data/citations";
  import Document from "$lib/components/citations/Document.svelte";
  import Background from "./sections/Background.svelte";
  import Results from "./sections/Results.svelte";
  import Insights from "./sections/Insights.svelte";
  import FutureWork from "./sections/FutureWork.svelte";
</script>

<div id="lluminate">
  <Intro />
  <Demos />
  <Document {citationsData}>
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

    <Algorithm />
    <Results />
    <Insights />
    <Background />
    <FutureWork />
  </Document>
</div>

<style lang="postcss">
  :global(#lluminate p) {
    @apply !my-2;
  }
  :global(#lluminate p.label) {
    @apply !w-full !text-center;
  }
  /* ol {
    padding-left: 2rem;
    text-align: left;
  } */

  :global(#lluminate li) {
    list-style-type: decimal;
    margin-bottom: 0.5rem;
    text-align: left;
    @apply !ml-8;
  }
  :global(#lluminate strong) {
    @apply font-bold;
  }
</style>
