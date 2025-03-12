<script lang="ts">
  import Document from "$lib/components/citations/Document.svelte";
  import Citation from "$lib/components/citations/Citation.svelte";
  import CreativeStrategies from "../components/CreativeStrategies.svelte";
  import RenderWhenVisible from "$lib/components/RenderWhenVisible.svelte";
  import { citationsData } from "../data/citations";
  import Background from "./Background.svelte";
  import BibTexCitation from "$lib/components/BibTexCitation.svelte";
</script>

<div class="text_body">
  <h2 id="algorithm">Algorithm</h2>
  <p>
    The algorithm is combination of evolutionary computation principles with
    large language models to create an open-ended discovery system. All
    mutations happen on the genetic code and are rendered as a phenotype for
    embedding.
  </p>
  <!-- For text domains the text embedding can be used. -->
  <ol class="!text-left mt-2">
    <li>
      <span class="font-bold">Embedding and Novelty Calculation:</span> Measure how
      different each artifact is from others using embeddings (average distance to
      k nearest neighbors)
    </li>
    <li>
      <span class="font-bold">Summary Generation:</span> Create a summary of the
      current population to provide context for future generations
    </li>
    <li>
      <span class="font-bold">Creative Strategy Injection:</span> Randomly select
      and apply creative thinking strategies to guide the LLM
    </li>
    <li>
      <span class="font-bold">Evolutionary Operators:</span> Create new artifacts
      by modifying or combining existing ones via prompts using the current summary
      and strategies.
    </li>
    <li>
      <span class="font-bold">Population Management:</span> Select the most diverse
      artifacts for the next generation
    </li>
  </ol>

  <div class="w-full my-0 px-2">
    <img
      src="/lluminate/diagram5.png"
      width="1410"
      height="475"
      class="w-10/12"
      alt="lluminate algorithm diagram"
    />
  </div>
</div>

<h2>Example Strategies</h2>
<CreativeStrategies />
