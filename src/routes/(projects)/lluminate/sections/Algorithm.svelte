<script lang="ts">
  import { onMount } from "svelte";
  import MermaidRenderer from "$lib/components/MermaidRenderer.svelte";
  import algorithmDiagram from "../data/diagram.mermaid?raw";
  import luminateAlgorithmPdf from "../data/lluminate-algo.pdf?url";
  import Document from "$lib/components/citations/Document.svelte";
  import { type Citation as CitationType } from "$lib/components/citations/types";
  import Citation from "$lib/components/citations/Citation.svelte";
  import CreativeStrategies from "../components/CreativeStrategies.svelte";

  const citationsData: CitationType[] = [
    {
      paperName: "homogenization",
      fullCitation: `Anderson, Barrett R., Jash Hemant Shah, and Max Kreminski. "Homogenization effects of large language models on human creative ideation." Proceedings of the 16th conference on creativity & cognition. 2024.`,
    },
    {
      paperName: "llm-creativity",
      fullCitation:
        "Soros, L., & Stanley, K. O. (2024). On Creativity and Open-Endedness.",
    },
    {
      paperName: "holland",
      fullCitation:
        "Holland, J. H. (1975). Adaptation in natural and artificial systems: An introductory analysis with applications to biology, control, and artificial intelligence. University of Michigan Press.",
    },
    {
      paperName: "novelty-search",
      fullCitation:
        "Lehman, J., & Stanley, K. O. (2011). Abandoning objectives: Evolution through the search for novelty alone. Evolutionary computation, 19(2), 189-223.",
    },
    {
      paperName: "map-elites",
      fullCitation:
        "Mouret, J. B., & Clune, J. (2015). Illuminating search spaces by mapping elites. arXiv preprint arXiv:1504.07467.",
    },
    {
      paperName: "qdlm",
      fullCitation:
        "Wang, R., Lehman, J., Clune, J., & Stanley, K. O. (2023). Quality diversity optimization with language models. Advances in Neural Information Processing Systems, 36.",
    },
    {
      paperName: "evolution-large-models",
      fullCitation:
        "Lehman, J., et al. (2023). Evolution through large models. arXiv preprint arXiv:2206.08896.",
    },
    {
      paperName: "sakana-ai",
      fullCitation:
        "Sakana AI et al. (2024). Automating the Search for Artificial Life with Foundation Models.",
    },
    {
      paperName: "boden",
      fullCitation:
        "Boden, M. A. (2004). The creative mind: Myths and mechanisms. Routledge.",
    },
    {
      paperName: "conceptual-blending",
      fullCitation:
        "Fauconnier, G., & Turner, M. (2008). The way we think: Conceptual blending and the mind's hidden complexities. Basic Books.",
    },
    {
      paperName: "lateral-thinking",
      fullCitation:
        "De Bono, E. (2015). Lateral thinking: Creativity step by step. Harper Colophon.",
    },
    {
      paperName: "oblique-strategies",
      fullCitation:
        "Eno, B., & Schmidt, P. (1975). Oblique Strategies: Over One Hundred Worthwhile Dilemmas.",
    },
    {
      paperName: "koestler",
      fullCitation: "Koestler, A. (1964). The act of creation. Hutchinson.",
    },
  ];
</script>

<Document {citationsData}>
  <div class="text_body">
    <h2 id="background">Background</h2>

    <p>
      Language models have demonstrated remarkable capabilities in generating
      coherent text, but their creative boundaries remain underexplored.
      Traditional prompt-based approaches produce outputs that fall within
      predictable distributions However, these methods fail to systematically
      explore the possible outputs of models or to discover truly novel outputs.
      Recent work shows this can actually make users less creative <Citation
        name={["homogenization"]}
      /> when using LLMs.
    </p>
    <p>
      Genetic algorithms (GAs) provide a framework for evolutionary search that
      mimics natural selection processes <Citation name={["holland"]} />. By
      iteratively selecting, recombining, and mutating candidate solutions, GAs
      can efficiently explore complex solution spaces and discover novel
      solutions. While GAs have been extensively applied in various domains
      including neural architecture search and procedural content generation,
      their integration with LLMs for creative exploration remains nascent.
    </p>

    <p>
      More recent developments in evolutionary computation have shifted focus
      from pure optimization to quality diversity algorithms, which aim to
      discover a diverse collection of high-performing solutions rather than a
      single optimum. Algorithms such as Novelty Search <Citation
        name={["novelty-search"]}
      />
      explicitly reward behavioral diversity, challenging the assumption that objective-based
      search is always optimal. MAP-Elites <Citation name={["map-elites"]} />
      extends this idea by maintaining an archive of diverse elite solutions organized
      along dimensions of interest, creating a "map" of the possibility space. Quality
      diversity algorithms have shown impressive results in domains like robot locomotion,
      game level design, and molecule discovery, where diverse solutions offer greater
      value than a single optimized answer.
    </p>

    <p>
      The concept of open-endedness—systems capable of producing novel and
      interesting artifacts indefinitely without external input—represents a
      grand challenge in artificial intelligence <Citation
        name={["llm-creativity"]}
      />. Recent work by Wang et al.
      <Citation name={["qdlm"]} /> on Quality Diversity Optimization with Language
      Models demonstrates the potential for applying quality diversity techniques
      to language generation, using diversity metrics to guide exploration of a model's
      latent space. Similarly, Lehman et al. <Citation
        name={["evolution-large-models"]}
      /> explored evolutionary approaches to prompt engineering, showing how diverse
      prompt strategies can elicit different capabilities from language models.
    </p>

    <p>
      A parallel development is seen in the field of Artificial Life (ALife),
      where researchers at Sakana AI and collaborators <Citation
        name={["sakana-ai"]}
      /> recently introduced ASAL (Automated Search for Artificial Life), which uses
      vision-language foundation models to discover diverse artificial lifeforms
      across various simulation environments. While ASAL focuses on parameter search
      within predefined simulation substrates, this approach goes further by evolving
      the actual code that defines the simulations, potentially enabling a more comprehensive
      exploration of the creative space.
    </p>

    <p>
      This approach uniquely differs from previous methods in several important
      ways. While existing quality diversity algorithms like MAP-Elites focus on
      maintaining diversity across predefined behavioral dimensions, this method
      introduces creative strategies as dynamic guidance mechanisms that adapt
      to the evolving population. Unlike previous work that treats LLMs
      primarily as evaluation functions or uses them for fixed template filling,
      we leverage the LLM's generative capabilities in all aspects of the
      evolutionary process—from population initialization to mutation,
      crossover, and even population summarization.
    </p>

    <p>
      Furthermore, our incorporation of population-level summaries creates a
      form of collective memory that allows the system to recognize patterns and
      themes across generations, enabling more deliberate exploration of novel
      territories by reflecting on past outputs. This combination of
      psychological creativity strategies, dynamic population awareness, and
      full utilization of the LLM's generative capabilities represents a
      significant departure from previous evolutionary approaches to text
      generation and other creative domains.
    </p>

    <p>
      A key innovation in our approach is the systematic application of formal
      creativity theories from psychology and art to guide LLM generation.
      Drawing from established frameworks such as Margaret Boden's conceptual
      spaces theory <Citation name={["boden"]} />, which distinguishes between
      combinatorial, exploratory, and transformational creativity, our system
      implements strategies that push language models beyond conventional
      outputs. We also incorporate Brian Eno's Oblique Strategies <Citation
        name={["oblique-strategies"]}
      />, Edward de Bono's lateral thinking techniques
      <Citation name={["lateral-thinking"]} />, Arthur Koestler's bisociation
      theory <Citation name={["koestler"]} />, and Fauconnier and Turner's
      conceptual blending <Citation name={["conceptual-blending"]} />—approaches
      that have proven effective in human creative contexts but have not been
      systematically applied to language model generation until now.
    </p>

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
      To measure diversity and guide selection, we compute embeddings for each artifact
      using the LLM's representation space. Novelty is calculated as the average
      distance to k-nearest neighbors (k=3 in our implementation), promoting artifacts
      that occupy unique regions in the embedding space.
    </p>

    <p>
      <span class="font-bold">Domains:</span> Each domain (shader, clock, etc) is
      represented with both a system prompt and embedding method. This is simpler
      than traditional genetic representations where each domain needs custom crossover
      and mutate methods. The embedding occurs on the phenotype, in our example on
      the image embeddings (CLIP) on the final render, but also can work on the text
      emebdding if no image exists.
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
      thinking strategies from psychology. We maintain a database of creativity techniques
      (e.g., conceptual blending, assumption reversal, forced connections) that are
      randomly selected and injected into prompts during the evolution process to
      guide the LLM toward more diverse and novel outputs. Current "reasoning models"
      use reinformed learned chain of thoughts to optimzie results, we beleive we
      are the first to begin investigating chain of thougth templates for divergent
      creative thinking.
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
      way to capture emerging patterns and themes, which then inform subsequent generations.
      This mechanism allows the model to develop a form of awareness about its previous
      outputs, enabling it to build upon, contrast with, or diverge from established
      patterns in the population.
    </p>

    <h2 id="results">Results</h2>
    <p>
      Our experimental results demonstrate the effectiveness of our LLM-based
      genetic algorithm in generating novel artifacts across multiple domains.
      We conducted a series of ablation studies to evaluate the impact of
      different components of our algorithm, with a focus on the SHADER domain
      as shown in the provided visualization.
    </p>

    <p>
      The baseline configuration—without creative strategies, using variation
      mode with medium summary—achieved a novelty score of 0.1584. We evaluated
      multiple configurations against this baseline, measuring percentage
      improvement in novelty scores.
    </p>

    <p>Key findings include:</p>

    <ol>
      <li>
        <strong>Creative Strategies Impact</strong>: Configurations using
        creative strategies consistently outperformed those without. The highest
        performing configuration (Strategies ON, Variation, Low Summary,
        Crossover) achieved a 43.1% improvement over baseline with a novelty
        score of 0.2267.
      </li>

      <li>
        <strong>Operator Effectiveness</strong>: The variation operator
        generally produced higher novelty scores compared to the creation
        operator. This is counter-intuitive, as one might expect that creating
        entirely new artifacts would produce more novelty than modifying
        existing ones. However, our results suggest that the constraint of
        working from an existing artifact actually promotes more divergent
        outputs.
      </li>

      <li>
        <strong>Crossover Benefits</strong>: The addition of crossover
        operations provided the largest single boost to novelty, with a 43.1%
        improvement over baseline when combined with strategies and variation
        mode. This highlights the value of combining genetic algorithm
        principles with LLM capabilities.
      </li>

      <li>
        <strong>Summary Influence</strong>: Configurations with population
        summaries enabled generally outperformed those without, though the
        effect was smaller than that of creative strategies or crossover
        operations. Low summary settings often performed better than medium
        summary settings.
      </li>

      <li>
        <strong>Reasoning Amount</strong>: Our 2×2 ablation study on reasoning
        amount (not shown in the chart) indicated that increasing the reasoning
        effort did not significantly impact novelty scores, suggesting that the
        structural aspects of the algorithm are more important than the depth of
        reasoning.
      </li>
    </ol>

    <p>
      The worst-performing configuration was "No Strategies, Variation, Medium
      Summary ON" with a 0.0% improvement over baseline (as it was the baseline
      itself). Even the second-worst configuration ("No Strategies, Variation,
      Medium Summary ON") showed a modest 9.3% improvement with a novelty score
      of 0.1731.
    </p>

    <p>
      These results demonstrate that our approach effectively enhances the
      creative capabilities of LLMs, with the full algorithm (including creative
      strategies, variation mode, summaries, and crossover) producing
      significantly more novel outputs than simpler configurations.
    </p>

    <h2>Discussion</h2>
    <p>
      Our findings reveal several important insights about creativity in
      language models and the effectiveness of evolutionary approaches for
      creative exploration.
    </p>

    <h3>Constrained Variation vs. Open-ended Creation</h3>
    <p>
      One of the most surprising results is that variation mode consistently
      outperformed creation mode in terms of novelty. This suggests that the
      constraint of modifying an existing artifact may actually promote more
      creative thinking in LLMs rather than limiting it. This phenomenon aligns
      with theories in creativity research that suggest constraints can
      paradoxically enhance creativity by forcing exploration of less obvious
      solutions. The finding may also relate to assembly theory, where building
      upon existing structures leads to greater complexity and novelty than
      creating from scratch.
    </p>

    <h3>Model Laziness and Evolutionary Pressure</h3>
    <p>
      The superior performance of variation mode may also reflect a form of
      "laziness" in language models, where they tend to produce outputs that
      require minimal cognitive effort. By providing an existing artifact as a
      starting point but requiring significant modifications, we create a
      tension that pushes the model to explore further regions of its latent
      space. The evolutionary pressure from novelty selection further encourages
      this exploration.
    </p>

    <h3>The Value of Crossover in Semantic Spaces</h3>
    <p>
      The substantial boost in novelty from crossover operations highlights the
      power of combining elements from different artifacts. Unlike traditional
      genetic algorithms where crossover operates on clearly defined genetic
      encodings, our approach performs crossover in the semantic space of
      language. This allows for conceptual combination—a key mechanism in human
      creativity—to emerge through the LLM's interpretation and integration of
      disparate ideas.
    </p>

    <h3>Creative Strategies as Exploration Heuristics</h3>
    <p>
      The consistent improvement from creative strategies demonstrates their
      effectiveness as exploration heuristics. These strategies likely help the
      model escape local optima in its generation process, guiding it toward
      unexplored regions of its possibility space. The interaction between
      creative strategies and evolutionary operators appears to be synergistic,
      with strategies providing direction and operators providing the mechanisms
      for discovery.
    </p>

    <h3>Limitations and Future Work</h3>
    <p>
      While our approach shows promising results, several limitations warrant
      further investigation. First, novelty as measured by embedding distance
      may not perfectly correlate with human judgments of creativity or
      usefulness. Future work should incorporate multi-objective evaluation that
      considers both novelty and quality.
    </p>

    <p>
      Second, our current implementation uses a single LLM architecture.
      Different models may respond differently to evolutionary pressure and
      creative strategies, suggesting potential for meta-evolution of the system
      itself to find optimal configurations for different models and domains.
    </p>

    <p>
      Third, the relationship between population diversity, summary abstraction
      level, and creative output quality requires deeper analysis. More
      sophisticated summary techniques could potentially enhance the algorithm's
      performance further.
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
      In conclusion, our LLM-based genetic algorithm represents a promising
      approach to open-ended discovery with foundation models. By combining
      evolutionary principles with psychological insights on creativity, we can
      systematically explore and expand the creative boundaries of language
      models, potentially leading to new applications in assisted creative
      exploration.
    </p>
  </div>
</Document>

<style lang="postcss">
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
