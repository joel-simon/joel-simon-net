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
    and Harold Cohen's AARON, which have demonstrated AI's potential to engage
    in creative tasks traditionally considered uniquely human. These efforts
    have not only produced intriguing artifacts but also deepened our
    understanding of creativity itself, challenging conventional notions of
    authorship and inspiration.
  </p>
  <p>
    In parallel to computational approaches, there are populat non-computational
    methods for fostering creativity such as Brian Eno's Oblique Strategies
    which is a deck of cards containing cryptic phrases or abstract directions
    designed to break creative blocks and encourage lateral thinking. Similar
    tools include Roger von Oech's Creative Whack Pack and IDEO's Method Cards,
    which provide prompts and techniques to stimulate innovative thinking. These
    analog methods are forms of random algorithm and share a common goal of
    expanding and augmenting human creativity with elements of randomness,
    constraints, or unexpected perspective shifts.
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
    <b>Prompt Engineering</b> for large language models has emerged as a crucial
    skill in effectively leveraging AI capabilities. This involves crafting
    input prompts that guide LLMs to produce desired outputs, often by providing
    context, examples, or specific instructions. Techniques like few-shot
    learning <Citation name={["few-shot-learners"]}></Citation>
    and chain-of-thought prompting <Citation name={["chain-of-thought"]}
    ></Citation>
    have shown significant improvements in task performance. The field continues
    to evolve rapidly, with researchers exploring methods to enhance model reliability,
    reduce hallucinations, and improve task-specific performance through careful
    prompt design.
  </p>
</div>
