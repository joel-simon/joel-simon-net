<script lang="ts">
  import Document from "$lib/components/citations/Document.svelte";
  import Citation from "$lib/components/citations/Citation.svelte";
  import CreativeStrategies from "../components/CreativeStrategies.svelte";
  import RenderWhenVisible from "$lib/components/RenderWhenVisible.svelte";
  import { citationsData } from "../data/citations";
  import Background from "./Background.svelte";
</script>

<div id="lluminate">
  <Document {citationsData}>
    <div class="text_body">
      <Background />
      <h2 id="algorithm">Algorithm</h2>
      <p>
        The algorithm is a fairly simple combination of evolutionary computation
        principles with large language models to create an open-ended discovery
        system.
      </p>
      <div class="w-full my-0 px-2">
        <img
          src="/lluminate/diagram5.png"
          width="1410"
          height="475"
          class="w-10/12"
        />
        <!-- <iframe
        src={luminateAlgorithmPdf}
        class="w-full"
        style="border: none; height: 1000px"
      ></iframe> -->
        <!-- <MermaidRenderer diagram={algorithmDiagram} /> -->
      </div>

      <!-- <h3>Population Initialization</h3> -->
      <!-- <p>
      <span class="font-bold">Population Initialization:</span>
      The algorithm begins by generating an initial population of artifacts based
      on an optional user-provided prompt and the domain system prompts.
    </p> -->

      <p>
        <span class="font-bold">Embedding and Novelty Calculation:</span>
        To measure diversity and guide selection, we compute embeddings for each
        artifact using the LLM's representation space. Novelty is calculated as the
        average distance to k-nearest neighbors (k=3 in our implementation), promoting
        artifacts that occupy unique regions in the embedding space.
      </p>

      <p>
        <span class="font-bold">Domains:</span> Each domain (shader, clock, etc)
        is represented with both a system prompt and embedding method. This is simpler
        than traditional genetic representations where each domain needs custom crossover
        and mutate methods. The embedding occurs on the phenotype, in our example
        on the image embeddings (CLIP) on the final render, but also can work on
        the text emebdding if no image exists.
      </p>

      <p>
        <span class="font-bold">Evolutionary Operators:</span> The algorithm implements
        variation and crossover as the two evolutionary operators. Variation prompts
        LLM to modify an existing artifact to create a significantly different version
        based on the current artifact, population summary and creative thinking strategy.
        Crossover is similar as above but encouraged to combine two different members
        of the current population.
      </p>

      <p>
        <span class="font-bold">Creative Strategy Injection:</span>
        A distinguishing feature of our algorithm is the incorporation of creative
        thinking strategies from psychology. We maintain a database of creativity
        techniques (e.g., conceptual blending, assumption reversal, forced connections)
        that are randomly selected and injected into prompts during the evolution
        process to guide the LLM toward more diverse and novel outputs. Current "reasoning
        models" use reinformed learned chain of thoughts to optimzie results, we
        beleive we are the first to begin investigating chain of thougth templates
        for divergent creative thinking.
      </p>
    </div>

    <CreativeStrategies />
    <div class="text_body">
      <!-- <h3>Population Management</h3> -->
      <p>
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
      </p>

      <h2 id="results">Results</h2>
      <p>
        Test were conducting on the shader and clock (website with p5.js
        library) domains. Each configuration was run with the 30-mini model from
        OpenAI with 30 generation and population size of 20 and 10 new children
        per generation. All tests were repeated three times. Novelty is the
        average distance to 3 nearest neighbors for each member of final
        population. it is worth noting that small change in cosine distance can
        correspond to large visual changes.
      </p>
      <!-- <p>Combinations of o3-mini reasoning amoutn and </p> -->
      <!--  First a 2x2 comparison
      was done between reasoning strength and use of creative strategies. Then
      ablation was done on use of strategies and summary and crossover. Additionally mode -->
      <RenderWhenVisible>
        <p class="!w-full !text-center font-bold !text-sm">
          Shader Domain, "make an interesting shader"
        </p>
        <img
          src="/lluminate/ShaderArtifact_novelty_and_length_comparison_2.png"
        />
      </RenderWhenVisible>
      <p class="!text-sm">
        Test were conducting on the shader and clock (website with p5.js
        library) domains. Each configuration was run with the 30-mini model from
        OpenAI with 30 generation and population size of 20 and 10 new children
        per generation. All tests were repeated three times. Novelty is the
        average distance to 3 nearest neighbors for each member of final
        population. Above is the fold increase over the baseline of random
        population. it is worth noting that small change in cosine distance can
        correspond to large visual changes. Two prompt-modes for evolution were
        tested, variation means a random artifact is mutated while "creation"
        means a wholly new artifact is created from scratch given the current
        population summary.
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
        Each artifact is tagged with the creative strategy used to create it,
        which allows is to compare the improvement by each strategy. Below is
        the percentage of each strategy used in population.
      </p>
      <RenderWhenVisible>
        <img
          width="400"
          src="/lluminate/strategy_usage_website_vs_ShaderArtifact.png"
        />
      </RenderWhenVisible>
      <p class="!text-sm">
        Strategy Usage Comparison Between Website and ShaderArtifact Domains.
        The scatter plot shows the percentage usage of different creative
        strategies across two domains, with website usage on the x-axis and
        ShaderArtifact usage on the y-axis. Error bars indicate standard
        deviation across multiple experimental runs. The diagonal dashed line
        represents equal usage in both domains. The plot reveals no significant
        correlation between strategy usage patterns across domains (r=-0.02,
        p=0.963), with some strategies showing domain-specific preferences.
        Notably, Replacement Template is used substantially more in
        ShaderArtifact generation, while Conceptual Blending shows higher usage
        in website generation. Other strategies like SCAMPER Transformation,
        Distance Association, Oblique Strategies, and Assumption Reversal
        demonstrate more balanced usage across both domains.
      </p>
      <!-- 
    <p>
      The baseline configuration—without creative strategies, using variation
      mode with medium summary—achieved a novelty score of 0.1584. We evaluated
      multiple configurations against this baseline, measuring percentage
      improvement in novelty scores.
    </p> -->

      <!-- <p>Key findings include:</p> -->
      <h2 id="discussion">Discussion</h2>
      <p>
        Our findings reveal key insights about creativity in language models and
        the effectiveness of evolutionary approaches for creative exploration.
      </p>

      <h3>Strategy Effectiveness Across Domains</h3>
      <p>
        We found domain-specificity in creative strategies, with no significant
        correlation (r=-0.02, p=0.963) between strategy effectiveness across
        domains. For example, Replacement Template was more effective for shader
        generation, while Conceptual Blending excelled in website development.
        This suggests strategies have inherent affinities with certain domains.
        Future work could explore automatically identifying optimal strategies
        for new domains.
      </p>

      <h3>The Surprising Power of Variation over Creation</h3>
      <p>
        Variation mode consistently outperformed creation mode in novelty
        metrics. This suggests that modifying existing artifacts promotes more
        creative exploration than creating from scratch, aligning with research
        showing constraints can enhance creativity by forcing exploration of
        less obvious pathways. The combination of novelty selection and
        structural constraints pushes LLMs toward more diverse possibilities.
      </p>

      <h3>Model Laziness and Evolutionary Pressure</h3>
      <p>
        Variation mode's superior performance reflects language models' tendency
        to produce outputs requiring minimal cognitive effort. Providing an
        existing artifact as a starting point while requiring significant
        modifications creates tension that pushes the model to explore further
        regions of its latent space, amplified by evolutionary pressure from
        novelty selection.
      </p>

      <h3>The Value of Crossover in Semantic Spaces</h3>
      <p>
        Crossover operations substantially boosted novelty, highlighting the
        power of combining elements from different artifacts. Unlike traditional
        genetic algorithms with defined genetic encodings, our approach performs
        crossover in the semantic space of language, enabling conceptual
        combination through the LLM's interpretation. The highest-performing
        configuration utilized crossover, suggesting its crucial role in
        reaching novel regions of the possibility space.
      </p>

      <h3>Creative Strategies as Exploration Heuristics</h3>
      <p>
        Creative strategies consistently improved outcomes by helping models
        escape local optima and explore unexplored regions. The interaction
        between creative strategies and evolutionary operators appears
        synergistic, with strategies providing direction and operators providing
        mechanisms for discovery.
      </p>

      <h3>Correlation Between Complexity and Novelty</h3>
      <p>
        We observed correlation between genome length and novelty scores.
        Configurations that produced higher novelty also generated longer
        artifacts, suggesting complex expressions may be necessary to explore
        novel regions. Strategies and crossover operations that increased
        novelty led to longer outputs, aligning with theories that novel ideas
        often require more elaborate conceptual structures.
      </p>

      <p>
        This connects to a fundamental principle: evolution within bounded
        domains typically requires complexification to maintain progress. As
        simpler forms exhaust their novelty potential, complexity becomes
        necessary to discover novel artifacts. This aligns with theories
        suggesting complexity growth enables sustained open-endedness. Future
        work could explore whether complexity is a necessary cost of novelty or
        if comparable novelty can be achieved with more concise expressions.
      </p>

      <h3>Limitations</h3>
      <p>
        Computational cost remains high, limiting population size and
        generations in practical applications. This algorithm is purely novelty
        seeking and works when any constraints are innately satisfied by the
        prompt, but does not have a way to repair infeasible solution or any
        kind of minimal criteria.
      </p>

      <h3>Future Work</h3>
      <p>
        This work sets the stage for potentially co-evolving strategies
        alongside artifacts that adapt to specific domains. These evolved "chain
        of creative thought templates" could even be reusable in direct
        prompting. The strong performance of crossover operations warrants
        further investigation into optimal crossover mechanisms and potential
        meta-evolution on the rest of the mutation and crossover prompts.
        Human-in-the-loop variants could combine this system's divergent
        thinking with human aesthetic judgment. At the time of writing this,
        image capacities were not yet available in the o3-api, but this will
        change soon and the model can view the output directly while evolving
        it. Potentially the entire population could be provided together as
        images directly.
      </p>

      <h3>Broader Implications</h3>
      <p>
        This research has implications beyond creative text generation. The
        demonstrated ability to systematically explore an LLM's creative
        boundaries could inform approaches to AI safety, interpretability, and
        alignment by revealing how models respond to different types of guidance
        and constraints. Additionally, the framework provides a foundation for
        human-AI collaborative creativity tools that can help users explore
        diverse possibilities they might not otherwise consider.
      </p>

      <p>
        In conclusion, this LLM-based genetic algorithm represents a promising
        approach to open-ended discovery with foundation models. By combining
        evolutionary principles with psychological insights on creativity, we
        can systematically explore and expand the creative boundaries of
        language models, potentially leading to new applications in assisted
        creative exploration.
      </p>
      <h2>Acknowledgments</h2>
      <p>
        This work was done and funded by myself while in-residence at Stochastic
        Labs. Last year I had an early version of the idea which Joel Lehman and
        Kenneth Stanley kindly gave very helpful and thoughtful feedback on.
      </p>
    </div>
  </Document>
</div>

<style lang="postcss">
  :global(#lluminate p) {
    @apply !my-2;
  }
  p {
    @apply py-1;
  }
  ol {
    padding-left: 2rem;
    text-align: left;
  }

  ol li {
    list-style-type: decimal;
    margin-bottom: 0.5rem;
    text-align: left;
  }

  ol li * {
    text-align: left;
  }

  strong {
    @apply font-bold;
  }

  .text_body p,
  .text_body h2,
  .text_body h3 {
    /* text-align: left; */
  }

  h3 {
    font-size: 1.25em;
    font-weight: 500;
    margin-top: 1.5rem;
    margin-bottom: 0.75rem;
  }
</style>
