<script lang="ts">
  import Citation from "$lib/components/citations/Citation.svelte";
</script>

<h2 id="background">Background</h2>
<div class="flex flex-col gap-4">
  <p>
    <b>Computational Creativity</b> has been an active field of research since
    the late 20th century, with pioneers like Margaret A. Boden exploring the
    intersection of artificial intelligence and creative processes <Citation
      name={["creativity and artificial intelligence"]}
    ></Citation>. Researchers such as Simon Colton, Geraint A. Wiggins, and
    David Cope have expanded this domain, developing systems that generate art,
    music, and literature. Their work spans from formal models of creativity to
    practical applications in various artistic domains. Notable projects include
    Colton's Painting Fool, Cope's EMI (Experiments in Musical Intelligence),
  </p>
  <!-- and Harold Cohen's AARON, which have demonstrated AI's potential to engage
  in creative tasks traditionally considered uniquely human. These efforts
  have not only produced intriguing artifacts but also deepened our
  understanding of creativity itself, challenging conventional notions of
  authorship and inspiration. -->
  <p>
    In parallel, there are non-computational methods for fostering creativity
    such as Brian Eno's Oblique Strategies which is a deck of cards containing
    cryptic phrases or abstract directions designed to break creative blocks and
    encourage lateral thinking. Similar tools include Roger von Oech's Creative
    Whack Pack and IDEO's Method Cards, which provide prompts and techniques to
    stimulate thinking. These analog methods are forms of random algorithm and
    share a common goal of expanding and augmenting human creativity with
    elements of randomness, constraints, or unexpected perspective shifts.
  </p>
  <p>
    <b>Open-ended Evolution</b> (OEE) in artificial life and evolutionary
    computation seeks to create systems that continually produce novel and
    increasingly complex forms, mirroring the diversity and innovation seen in
    biological evolution. Key works include Lehman and Stanley's novelty search <Citation
      name={["abandoning-objectives"]}
    ></Citation>, which rewards behavioral novelty rather than progress towards
    a fixed goal, and Soros and Stanley's minimal criterion coevolution <Citation
      name={["minimal-conditions-oee"]}
    ></Citation>, which demonstrates how simple reproductive criteria can lead
    to ongoing innovation. These approaches aim to overcome the tendency of
    traditional evolutionary algorithms to converge on local optima, instead
    promoting unbounded exploration of possibility spaces.
  </p>
  <p>
    Recent work by Soros et al. <Citation
      name={["creativity-and-open-endedness"]}
    ></Citation>
    has sought to bridge the conceptual gap between computational creativity and
    open-endedness research. Their paper differs from previous approaches by explicitly
    examining the relationship between creativity and open-endedness, rather than
    treating them as separate concepts. The authors argue that while there are similarities
    between the two fields, there are also important distinctions. For instance,
    they note that open-endedness in artificial life systems does not necessarily
    require the notion of value that is often central to definitions of creativity.
  </p>
  <p>
    There has been little to no generative work combining computational
    creativity and open-endedness—a gap this project seeks to address. During
    the course of this research, two relevant projects have emerged in the realm
    of LLMs and ideation. The first is <a href="https://sakana.ai/ai-scientist/"
      >the AI Scientist by sakana.ai</a
    >, which attempts to create a fully automated scientist capable of
    conceiving and executing machine learning research. While there are
    similarities in its use of automated reference lookups and a form of minimal
    criterion, our work differs in its aim: rather than automating the creative
    process, we seek to augment it, placing emphasis on the human aspect of
    creativity. The second is the recent paper <Citation
      name={["novel-research-ideas"]}
      >Can LLMs Generate Novel Research Ideas?</Citation
    >. The authors faced a similar challenge in evaluating ideas and also
    employed a methodical approach. However, their generation process was
    considerably simpler, primarily relying on the production of thousands of
    ideas. While this approach effectively generates diversity, it remains
    constrained by the initial prompt. An insightful overview and critique of
    this work can be found in
    <a
      target="_blank"
      href="https://x.com/colin_fraser/status/1833953195430719744"
      >this Twitter thread</a
    >.
  </p>
  <p>
    <b>Prompt Engineering</b> for large language models has emerged as a crucial
    skill in effectively leveraging LLM's. This involves crafting prompts, often
    by providing context, examples, or specific instructions. Techniques like
    few-shot learning <Citation name={["few-shot-learners"]}></Citation>
    and chain-of-thought prompting <Citation name={["chain-of-thought"]}
    ></Citation> have shown significant improvements in task performance. Recently,
    OpenAI released their
    <a
      target="_blank"
      href="https://openai.com/index/introducing-openai-o1-preview/"
    >
      o1 models</a
    > that use reinforcement learning to generate prompts. This is very effective
    for convergent logic problem like programming and math but did worse on creative
    tasks.
  </p>
</div>
