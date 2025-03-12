<script lang="ts">
  import ClickToModal from "$lib/components/ClickToModal.svelte";
  import RenderWhenVisible from "$lib/components/RenderWhenVisible.svelte";
</script>

<div class="text_body">
  <!-- <h3>Population Management</h3> -->
  <!-- <p>
      <span class="font-bold">Population Management:</span>
      After each generation, we select the next population based on novelty metrics,
      maintaining a fixed population size while preserving the most diverse artifacts.
      This ensures continuous exploration of the creative space rather than convergence
      to a single solution.
    </p>

    <p>
      <span class="font-bold">Summary Generation:</span>
      To provide context and encourage novel exploration a summary of the current
      population is generated using the LLM. These summaries are a straightforward
      way to capture emerging patterns and themes, which then inform subsequent
      generations. This mechanism allows the model to develop a form of awareness
      about its previous outputs, enabling it to build upon, contrast with, or
      diverge from established patterns in the population.
    </p> -->

  <h2 id="results">Results</h2>
  <p>
    Test were conducted on the shader and clock (website with p5.js library)
    domains. Each configuration was run with the 30-mini model from OpenAI. It
    is worth noting that small change in cosine distance can correspond to large
    perceptual changes. Two prompt-modes for evolution were tested, variation
    means a random artifact is mutated while "creation" means a wholly new
    artifact is created from scratch given the current population summary.
  </p>
  <!-- <p>Combinations of o3-mini reasoning amoutn and </p> -->
  <!--  First a 2x2 comparison
    was done between reasoning strength and use of creative strategies. Then
    ablation was done on use of strategies and summary and crossover. Additionally mode -->
  <RenderWhenVisible>
    <ClickToModal let:isOpen>
      <p class="!w-full !text-center font-bold !text-sm">
        Shader Domain, "make an interesting shader"
      </p>
      <img
        class:w-[75%]={!isOpen}
        alt="novelty and length comparison"
        src="/lluminate/ShaderArtifact_novelty_and_length_comparison_2.png"
      />
    </ClickToModal>
  </RenderWhenVisible>
  <p class="!text-sm">
    Comparing final population novelty and genome length (source code string
    length) of each configuration. Each was run with the 30-mini model from
    OpenAI with 30 generation and population size of 20 and 10 new children per
    generation. All tests were repeated three times. Novelty is the average
    distance to 3 nearest neighbors for each member of final population. Above
    is the fold increase over the baseline of random population.
  </p>
  <!-- <RenderWhenVisible>
    <p class="!w-full !text-center">HTML Domain, "make a clock"</p>
    <img src="/lluminate/website_novelty_and_length_comparison.png" />
  </RenderWhenVisible> -->
  <!-- <p>
    Our experimental results demonstrate the effectiveness of our LLM-based
    genetic algorithm in generating novel artifacts across multiple domains.
    We conducted a series of ablation studies to evaluate the impact of
    different components of our algorithm, with a focus on the SHADER domain
    as shown in the provided visualization.
  </p> -->
  <p class="mt-2">
    Each artifact is tagged with the creative strategy used to create it, which
    allows is to compare the improvement by each strategy. Below is the
    percentage of each strategy used in population.
  </p>
  <RenderWhenVisible>
    <ClickToModal let:isOpen>
      <div style="height:{isOpen ? '100%' : '350px'}">
        <img
          style="height:100%; width:auto;"
          width={"2968px"}
          height={"2968px"}
          alt="strategy usage comparison"
          src="/lluminate/strategy_usage_website_vs_ShaderArtifact.png"
        />
      </div>
    </ClickToModal>
  </RenderWhenVisible>
  <p class="!text-sm">
    Strategy Usage Comparison Between Website and ShaderArtifact Domains. The
    scatter plot shows the percentage usage of different creative strategies
    across two domains, with website usage on the x-axis and ShaderArtifact
    usage on the y-axis. Error bars indicate standard deviation across multiple
    experimental runs. The diagonal dashed line represents equal usage in both
    domains. The plot reveals no significant correlation between strategy usage
    patterns across domains (r=-0.02, p=0.963), with some strategies showing
    domain-specific preferences. Notably, Replacement Template is used
    substantially more in ShaderArtifact generation, while Conceptual Blending
    shows higher usage in website generation. Other strategies like SCAMPER
    Transformation, Distance Association, Oblique Strategies, and Assumption
    Reversal demonstrate more balanced usage across both domains.
  </p>
</div>
