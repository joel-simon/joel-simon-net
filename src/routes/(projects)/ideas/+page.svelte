<script lang="ts">
  import { type ProjectData } from "./types";
  import Document from "$lib/components/citations/Document.svelte";
  import Citation from "$lib/components/citations/Citation.svelte";

  import ProjectGrid from "./ProjectGrid.svelte";
  import StartingTemplates from "./components/StartingTemplates.svelte";
  import SmallProjectLink from "$lib/components/SmallProjectLink.svelte";
  import { projects } from "$lib/data";
  import ProjectCard from "$lib/components/ProjectCard.svelte";
  import { writable } from "svelte/store";

  export let data: { projects: ProjectData[] };

  export const citationsData = [
    {
      paperName: "creativity and artificial intelligence",
      fullCitation: `Boden, Margaret A. "Creativity and artificial intelligence." Artificial intelligence 103.1-2 (1998).`,
    },
    {
      paperName: "diverse-mcce",
      fullCitation: `Brant, Jonathan C., and Kenneth O. Stanley. "Diversity preservation in minimal criterion coevolution through resource limitation." Proceedings of the 2020 Genetic and Evolutionary Computation Conference. 2020."`,
    },
    {
      paperName: "mcce",
      fullCitation: `Brant, Jonathan C., and Kenneth O. Stanley. "Minimal criterion coevolution: a new approach to open-ended search." Proceedings of the Genetic and Evolutionary Computation Conference. 2017.`,
    },

    // {
    //   paperName: "paper name 3",
    //   fullCitation: "Author C. Title of Paper 3. Journal Name, Year.",
    // },
  ];
</script>

<Document {citationsData}>
  <div class="flex flex-col gap-4">
    <div class="text_body">
      <h1>New Ideas</h1>
      <!-- <p class="w-full !text-center">2024</p> -->
      <!-- <p class="w-full !text-center">Ggenerative Research-art 2024</p> -->
      <p>
        <b>New Ideas</b> is a research project combining open-ended evolutionary
        algorithms with large language models (LLMs) to generate candidate ideas
        for real-world creative technology collaborations. It presents a novel algorithm
        for open-ended ideation using co-evolved creative-chain-of-thought (ccot)
        templates.
      </p>
      <br />
      <p>
        The creative motivation is to explore whether the internet - and the
        LLMs trained on it - offer new opportunities for human creative
        collaborations, inverting the usual dynamic of internet scraping taking
        our data to train models to one where LLMs can give back to us. The
        technical motivation is to investigate if open-ended evolutionary
        algorithms can complement LLMs and produce genuinely surprising novelty.
        The philosophical motivation is not to determine whether 'AI' can
        automate human creativity - a question that is deemed inhumane - but
        rather to inspire humans with possible directions for them to continue
        and fuel their own creativity, and potentially even foster new creative
        relationships.
      </p>
      <a href={"https://github.com/joel-simon/open_ended_ideas"}>
        <p>Repo</p>
      </a>
      <h2>Background</h2>
      <div class="flex flex-col gap-4">
        <p>
          <b>Computational Creativity</b> has been an active field of research
          since the late 20th century, with pioneers like Margaret A. Boden
          exploring the intersection of artificial intelligence and creative
          processes <Citation name={["creativity and artificial intelligence"]}
          ></Citation>. Researchers such as Simon Colton, Geraint A. Wiggins,
          and David Cope have expanded this domain, developing systems that
          generate art, music, and literature. Their work spans from formal
          models of creativity to practical applications in various artistic
          domains. Notable projects include Colton's Painting Fool, Cope's EMI
          (Experiments in Musical Intelligence), and Harold Cohen's AARON, which
          have demonstrated AI's potential to engage in creative tasks
          traditionally considered uniquely human. These efforts have not only
          produced intriguing artifacts but also deepened our understanding of
          creativity itself, challenging conventional notions of authorship and
          inspiration.
        </p>
        <p>
          In parallel to computational approaches, there are populat
          non-computational methods for fostering creativity such as Brian Eno's
          Oblique Strategies which is a deck of cards containing cryptic phrases
          or abstract directions designed to break creative blocks and encourage
          lateral thinking. Similar tools include Roger von Oech's Creative
          Whack Pack and IDEO's Method Cards, which provide prompts and
          techniques to stimulate innovative thinking. These analog methods are
          forms of random algorithm and share a common goal of expanding and
          augmenting human creativity with elements of randomness, constraints,
          or unexpected perspective shifts.
        </p>
        <p>
          <b>Open-ended Evolution</b> (OEE) in artificial life and evolutionary computation
          seeks to create systems that continually produce novel and increasingly
          complex forms, mirroring the diversity and innovation seen in biological
          evolution. Key works include Lehman and Stanley's novelty search [1], which
          rewards behavioral novelty rather than progress towards a fixed goal, and
          Soros and Stanley's minimal criterion coevolution [2], which demonstrates
          how simple reproductive criteria can lead to ongoing innovation. These
          approaches aim to overcome the tendency of traditional evolutionary algorithms
          to converge on local optima, instead promoting unbounded exploration of
          possibility spaces.
        </p>
        <p>
          <b>Prompt Engineering</b> for large language models has emerged as a crucial
          skill in effectively leveraging AI capabilities. This involves crafting
          input prompts that guide LLMs to produce desired outputs, often by providing
          context, examples, or specific instructions. Techniques like few-shot learning
          [3] and chain-of-thought prompting [4] have shown significant improvements
          in task performance. The field continues to evolve rapidly, with researchers
          exploring methods to enhance model reliability, reduce hallucinations,
          and improve task-specific performance through careful prompt design.
        </p>
      </div>
      <h2>Methods</h2>
      <p>
        <b class="font-bold">Data:</b> A corpus of creators with personal
        websites are scrapped and then summarized with a LLM to a standard
        format. These a people I follow on twitter who have websites with good
        documentation on their projects. The vast majority are people I know
        personally who work around creative technology, but there are also a few
        well known artists and some wildcards from twitter added.
        <a
          href={"https://github.com/joel-simon/open_ended_ideas/blob/main/data/user_summaries/_joelsimon.json"}
          >Example.</a
        >
      </p>
      <br />
      <p>
        <b>Algorithm:</b> The core algorithm is a based on
        <Citation name={["mcce"]}>Minimal Criterion Coevolution</Citation> - which
        introducing a novel approach to open-ended evolutionary search. It coevolves
        two populations - mazes and maze-solving agents - each subject to a minimal
        criterion for reproduction rather than a traditional fitness function. This
        generates a wide variety of both maze structures and solving strategies without
        relying on explicit behavioral characterizations or an archive of past solutions.-
        we Implement the modified method proposed in

        <Citation name={["diverse-mcce"]}
          >Diversity preservation in minimal criterion coevolution through
          resource limitation</Citation
        > which introduced diversity preserving mechanic. The main change in this
        paper are to 1: Treat the ccot as the "agent" and the collaborator pair as
        the "environment." This allows
      </p>

      <h2>Examples</h2>
      <!-- <div class="w-full center-text"> -->
      <p class="w-full !text-center">
        Select an idea to see its creative chain of thought.
      </p>
      <!-- </div> -->
    </div>
    <ProjectGrid projects={data.projects} />
    <StartingTemplates />
    <div class="text_body">
      <h2>Discussion</h2>
      <p>
        We stand upon the precipice of a world of slop - regurgitated AI
        averngess rehashed and then retrained upon itself in a sick recursive
        mad cow loop. To work criticallt with technology is not to derailit ,
        but rather to find way to repurporse and reframe it.
      </p>
      <p>Ultimately, this work has to be evaluated subjectively,</p>

      <h2>Future Work</h2>
      Interactive evolution with human in the loop Focused on single pairs Social
      netoworks

      <!-- <h2>Acknowledgements</h2>
      <p>Thanks to Joel Lehmanm nad  -->

      <h2>Other Projects</h2>
      <p>
        If you enjoyed this you may also enjoy my other independent research-art
        projects.
      </p>
      <div class="w-full grid grid-cols-4 gap-4 my-4">
        {#each projects as project}
          {#if project.labels.includes("research-art")}
            <SmallProjectLink projectName={project.name} />
          {/if}
        {/each}
        <!-- <SmallProjectLink projectName="Derivative Works" />
        <SmallProjectLink projectName="Forms Of Life" /> -->
      </div>

      <div>
        <p>To cite this blog:</p>

        <p>
          Simon, J. (2024, September 26). New Ideas. <i>JoelSimon.net</i>.
          <a href="https://www.joelsimon.net/ideas"
            >https://www.joelsimon.net/ideas</a
          >
        </p>
      </div>
      <!-- <div id="project-container grid grid-cols-3">
        {#each projects as project}
          {#if project.labels.includes("research-art")}
            <ProjectCard {project} selectedLabel={writable(null)} />
          {/if}
        {/each}
      </div> -->
    </div>
  </div>
</Document>

<style>
  b {
    font-weight: 500;
  }
</style>
