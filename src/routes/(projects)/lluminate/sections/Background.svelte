<script lang="ts">
  import Citation from "$lib/components/citations/Citation.svelte";
</script>

<div class="text_body">
  <h2 id="background">Background</h2>

  <!-- <p>
    Language models generate coherent text but their creative boundaries remain
    underexplored. Traditional prompt-based approaches produce predictable
    outputs without systematically exploring novel possibilities. Reasoning
    models using reinforcement learning can solve computer science problems, but
    focus primarily on math and logic rather than divergent thinking.
  </p> -->

  <p>
    Genetic algorithms (GAs) mimic natural selection to efficiently explore
    complex solution spaces <Citation name={["holland"]} />. While extensively
    applied in neural architecture search and procedural content generation,
    their integration with LLMs for creative exploration is still emerging.
  </p>

  <p>
    Recent evolutionary computation has explored quality-diversity algorithms,
    seeking diverse high-performing solutions rather than a single optimum.
    Novelty Search <Citation name={["abandoning-objectives"]} /> rewards behavioral
    diversity, while MAP-Elites <Citation name={["map-elites"]} /> maintains an archive
    of diverse solutions along dimensions of interest. These approaches have demonstrate
    how rewarding behavioral novelty rather than fixed goals can drive ongoing innovation,
    mirroring biological evolution's diversity.
  </p>
  <!-- locomotion, game design, and molecule discovery.  Approaches like Lehman and Stanley's novelty search <Citation
name={["abandoning-objectives"]}
/> and Soros and Stanley's minimal criterion coevolution <Citation
name={["minimal-conditions-oee"]}
/>
demonstrate how rewarding behavioral novelty rather than fixed goals can drive
ongoing innovation, mirroring biological evolution's diversity.
</p> -->

  <p>
    Open-endedness expands on the insights of novelty search and aims to create
    systems that continually produce novel, increasingly complex forms
    <Citation name={["open-endedness-matters"]} />. Soros et al. <Citation
      name={["creativity-and-open-endedness"]}
    /> bridged computational creativity and open-endedness research although it has
    not been applied to language models.
  </p>
  <!-- <Citation name={["llm-creativity"]} />. Wang et al. <Citation
  name={["qdlm"]}
/> demonstrated quality diversity techniques for language generation, while Lehman
et al. <Citation name={["evolution-large-models"]} /> explored evolutionary approaches
to prompt engineering. -->

  <!-- <p> -->
  <!-- Open-ended Evolution (OEE) seeks to create systems that continually produce
    novel, increasingly complex forms 
  </p> -->
  <!-- </p> -->
  <!-- <p>
    Open-endedness and creativity enhance human-AI collaboration. While
    traditional LLM interactions often homogenize ideas <Citation
      name={["homogenization"]}
    />
  </p> -->
  <!-- 
  <p>
    In parallel, Artificial Life researchers at Sakana AI <Citation
      name={["sakana-ai"]}
    /> introduced ASAL (Automated Search for Artificial Life), using vision-language
    models to discover diverse artificial lifeforms across simulation environments.
    While ASAL focuses on parameter search within predefined simulation substrates,
    this approach goes further by evolving the actual code that defines the simulations,
    potentially enabling a more comprehensive exploration of the creative space.
  </p> -->
  <!-- 
  <p>
    This approach differs from previous methods by introducing creative
    strategies as dynamic guidance mechanisms that adapt to evolving
    populations. We leverage LLMs' generative capabilities throughout the
    evolutionary process and incorporate population-level summaries as
    collective memory, enabling deliberate exploration of novel territories.
  </p> -->
  <!-- <p>Within the language model domain, there has be</p> -->
  <p>
    For large language models prompting has emerged as a crucial skill in
    effectively leveraging LLM's. This involves crafting prompts, often by
    providing context, examples, or specific instructions. Techniques like
    few-shot learning <Citation name={["few-shot-learners"]}></Citation>
    and chain-of-thought prompting <Citation name={["chain-of-thought"]}
    ></Citation> have shown significant improvements in task performance. Recently,
    OpenAI released their
    <a
      target="_blank"
      href="https://openai.com/index/introducing-openai-o1-preview/"
    >
      reasoning</a
    >
    that use reinforcement learning to generate prompts. This is very effective for
    convergent logic problem like programming and math but did worse on creative
    tasks. In contrast to the expansive creativity of open endedness, language models
    has proven to increase teh homogenization of ideas <Citation
      name={["homogenization"]}
    />
  </p>
  <p>
    A key and novel component in this work is the systematic application of
    formal creativity theories to facilitate creative thinking. Drawing from
    Margaret Boden's conceptual spaces theory <Citation name={["boden"]} /> and her
    foundational work on creativity and artificial intelligence <Citation
      name={["creativity-and-artificial-intelligence"]}
    />, I implement strategies pushing language models beyond conventional
    outputs. I also incorporate Brian Eno's Oblique Strategies <Citation
      name={["oblique-strategies"]}
    />, Edward de Bono's lateral thinking <Citation
      name={["lateral-thinking"]}
    />, Arthur Koestler's bisociation theory <Citation name={["koestler"]} />,
    and Fauconnier and Turner's conceptual blending <Citation
      name={["conceptual-blending"]}
    />—approaches proven effective in human creativity but not previously
    applied systematically to language model generation.
  </p>
</div>
<!-- <h2 id="background">Background</h2>

<p>
  Language models have demonstrated remarkable capabilities in generating
  coherent text, but their creative boundaries remain underexplored. Traditional
  prompt-based approaches produce outputs that fall within predictable
  distributions However, these methods fail to systematically explore the
  possible outputs of models or to discover truly novel outputs. Reasoning
  models have emerged using reinforcement leanring to generate computer science
  problems where converse on a correct solution is more chains of thought.
  However these are primarily trained on math and logic puzzles rather than
  divergent and creative thinking.
</p>

<p>
  Genetic algorithms (GAs) provide a framework for evolutionary search that
  mimics natural selection processes <Citation name={["holland"]} />. By
  iteratively selecting, recombining, and mutating candidate solutions, GAs can
  efficiently explore complex solution spaces and discover novel solutions.
  While GAs have been extensively applied in various domains including neural
  architecture search and procedural content generation, their integration with
  LLMs for creative exploration remains nascent.
</p>

<p>
  More recent developments in evolutionary computation have shifted focus from
  pure optimization to quality diversity algorithms, which aim to discover a
  diverse collection of high-performing solutions rather than a single optimum.
  Algorithms such as Novelty Search <Citation name={["novelty-search"]} />
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
  interesting artifacts indefinitely without external input—represents a grand
  challenge in artificial intelligence <Citation name={["llm-creativity"]} />.
  Recent work by Wang et al.
  <Citation name={["qdlm"]} /> on Quality Diversity Optimization with Language Models
  demonstrates the potential for applying quality diversity techniques to language
  generation, using diversity metrics to guide exploration of a model's latent space.
  Similarly, Lehman et al. <Citation name={["evolution-large-models"]} /> explored
  evolutionary approaches to prompt engineering, showing how diverse prompt strategies
  can elicit different capabilities from language models.
</p>

<p>
  The concept of open-endedness—systems capable of producing novel and
  interesting artifacts indefinitely without external input—represents a grand
  challenge in artificial intelligence. Open-ended Evolution (OEE) in artificial
  life seeks to create systems that continually produce novel and increasingly
  complex forms, mirroring biological evolution's diversity and innovation. Key
  approaches like Lehman and Stanley's novelty search <Citation
    name={["abandoning-objectives"]}
  />
  and Soros and Stanley's minimal criterion coevolution <Citation
    name={["minimal-conditions-oee"]}
  />
  demonstrate how rewarding behavioral novelty rather than progress toward fixed
  goals can lead to ongoing innovation.
</p>

<p>
  Open-endedness and creativity are deeply interconnected concepts that can
  enhance human-AI collaboration. Recent work by Soros et al. <Citation
    name={["creativity-and-open-endedness"]}
  /> has bridged the conceptual gap between computational creativity and open-endedness
  research, examining their relationship rather than treating them as separate domains.
  While traditional LLM interactions often lead to homogenization of ideas <Citation
    name={["homogenization"]}
  />, open-ended systems can counteract this tendency by continuously generating
  diverse and surprising outputs. By incorporating principles from open-ended
  evolution into LLM interactions—such as rewarding novelty over optimization
  and implementing minimal criteria for quality—we can create tools that expand
  rather than narrow the creative possibilities available to users. This
  approach shifts the paradigm from LLMs as mere assistants that converge on
  expected outputs to co-creative partners that help users explore unfamiliar
  regions of conceptual space, potentially leading to transformative ideas that
  neither human nor AI would discover independently.
</p>

<p>
  A parallel development is seen in the field of Artificial Life (ALife), where
  researchers at Sakana AI and collaborators <Citation name={["sakana-ai"]} /> recently
  introduced ASAL (Automated Search for Artificial Life), which uses vision-language
  foundation models to discover diverse artificial lifeforms across various simulation
  environments. While ASAL focuses on parameter search within predefined simulation
  substrates, this approach goes further by evolving the actual code that defines
  the simulations, potentially enabling a more comprehensive exploration of the creative
  space.
</p>

<p>
  This approach uniquely differs from previous methods in several important
  ways. While existing quality diversity algorithms like MAP-Elites focus on
  maintaining diversity across predefined behavioral dimensions, this method
  introduces creative strategies as dynamic guidance mechanisms that adapt to
  the evolving population. Unlike previous work that treats LLMs primarily as
  evaluation functions or uses them for fixed template filling, we leverage the
  LLM's generative capabilities in all aspects of the evolutionary process—from
  population initialization to mutation, crossover, and even population
  summarization.
</p>

<p>
  Furthermore, our incorporation of population-level summaries creates a form of
  collective memory that allows the system to recognize patterns and themes
  across generations, enabling more deliberate exploration of novel territories
  by reflecting on past outputs. This combination of psychological creativity
  strategies, dynamic population awareness, and full utilization of the LLM's
  generative capabilities represents a significant departure from previous
  evolutionary approaches to text generation and other creative domains.
</p>

<p>
  A key innovation in our approach is the systematic application of formal
  creativity theories from psychology and art to guide LLM generation. Drawing
  from established frameworks such as Margaret Boden's conceptual spaces theory <Citation
    name={["boden"]}
  /> and her foundational work on creativity and artificial intelligence <Citation
    name={["creativity-and-artificial-intelligence"]}
  />, which distinguishes between combinatorial, exploratory, and
  transformational creativity, our system implements strategies that push
  language models beyond conventional outputs. We also incorporate Brian Eno's
  Oblique Strategies <Citation name={["oblique-strategies"]} />, Edward de
  Bono's lateral thinking techniques
  <Citation name={["lateral-thinking"]} />, Arthur Koestler's bisociation theory <Citation
    name={["koestler"]}
  />, and Fauconnier and Turner's conceptual blending <Citation
    name={["conceptual-blending"]}
  />—approaches that have proven effective in human creative contexts but have
  not been systematically applied to language model generation until now.
</p> -->
