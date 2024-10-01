<script lang="ts">
  import Citation from "$lib/components/citations/Citation.svelte";
</script>

<h2 id="methods">Methods</h2>
<div class="flex flex-col gap-4">
  <p>
    <b class="font-bold">Data:</b> A corpus of creators with personal websites
    are scrapped and then summarized with a LLM to a standard format. These a
    people I follow on twitter who have websites with good documentation on
    their projects. The vast majority are people I know personally who work
    around creative technology, but there are also a few well known artists and
    some wildcards from twitter added.
    <a
      href={"https://github.com/joel-simon/open_ended_ideas/blob/main/data/user_summaries/_joelsimon.json"}
      >Example.</a
    >
  </p>
  <p>
    <b class="font-bold">Algorithm:</b> The core algorithm is a based on
    <Citation name={["mcce"]}>Minimal Criterion Coevolution</Citation> - which introducing
    a novel approach to open-ended evolutionary search. It coevolves two populations
    - mazes and maze-solving agents - each subject to a minimal criterion for reproduction
    rather than a traditional fitness function. This generates a wide variety of
    both maze structures and solving strategies without relying on explicit behavioral
    characterizations or an archive of past solutions. We implement the modified
    method proposed in

    <Citation name={["diverse-mcce"]}
      >Diversity preservation in minimal criterion coevolution through resource
      limitation</Citation
    > which introduced diversity preserving mechanic.

    <!-- This allows -->
    <!-- </p>
  <p> -->
  </p>
  <p>
    <b>Main changes:</b>
  </p>

  <ul class=" overview list-disc pl-5 text-gray-800">
    <li>
      <p>
        Treat the chain of thought as the "agent" and the collaborator pair as
        the "environment." The chain of thought is a series of thinking
        instructions represented as an array of strings. This enables simple
        genetic crossover operators as well as mutation by sampling other steps
        as well as dynamically generating new steps during the run.
      </p>
    </li>

    <li>
      <p>
        The previous N most recent projects from the the given environment
        (collaborator pair) are used to inform the generation of new projects by
        being passed in as context to the LLM. This is a simple method of
        pushing of the project generation towards a less explored regions,
        defined by the embedding space.
      </p>
    </li>
    <li>
      <p>
        Use a ranking method for the minimal criterion. Evaluating the quality
        of the generated idea is very finicky with LLM's and multiple methods
        were evaluated. We first retrieve the top N most similar projects to the
        generated project and then use the LLM to rank the generated project
        among them. If it does not rank last it is added to the archive.
        Controlling the number of comparisons also controls the difficulty
        threshold.
      </p>
    </li>
    <li>
      <p>
        Add an archive back of past projects and their text embeddings (using
        <a
          target="_blank"
          href="https://huggingface.co/sentence-transformers/all-MiniLM-L6-v2"
          >sentence-transformers</a
        >) in order to look up nearest neighbors of a project for the ranking
        algorithm.
      </p>
    </li>
  </ul>
  <p>
    The fact that past runs contribute to future generations and new steps are
    dynamically generated means there is a potentially infinite number of new
    ideas to explore.
  </p>
  <!-- 3: Use a ranking method for the minimal criterion. -->
  <!-- </p> -->
  <!-- 
<p class="">
  The algorithm maintains two populations: agents (representing project
  templates) and environments (representing pairs of creators).
</p> -->

  <!-- <div class="overview w-full grid grid-cols-2 gap-2">

    <div>
      <h3 class="text-xl font-semibold mb-2">Key Components:</h3>
      <ul class="list-disc pl-5 text-gray-600">
        <li>Agent: Contains a project template</li>
        <li>Environment: Contains two creators</li>
        <li>
          Project: Generated from an agent's template and an environment's
          creators
        </li>
      </ul>
    </div>

    <div>
      <h3 class="text-xl font-semibold mb-2">Main Loop:</h3>
      <ol class="list-decimal pl-5 text-gray-600">
        <li>Initialize populations of agents and environments</li>
        <li>
          In each iteration:
          <ul class="list-disc pl-5 mt-2">
            <li>Select parents from both populations</li>
            <li>
              Create offspring through reproduction (crossover and mutation)
            </li>
            <li>Evaluate offspring by generating projects</li>
            <li>Accept or reject offspring based on novelty and quality</li>
          </ul>
        </li>
      </ol>
    </div>

    <div>
      <h3 class="text-xl font-semibold mb-2">Reproduction:</h3>
      <ul class="list-disc pl-5 mb-4 text-gray-600">
        <li>Agents and environments can crossover or be selected directly</li>
        <li>Mutation is applied with a certain probability</li>
      </ul>
    </div>

    <div>
      <h3 class="text-xl font-semibold mb-2">Evaluation:</h3>
      <ul class="list-disc pl-5 mb-4 text-gray-600">
        <li>
          Generate a project using the agent's template and environment's
          creators
        </li>
        <li>
          Compare the new project to existing projects using sentence embeddings
        </li>
        <li>Rank the new project among its nearest neighbors</li>
        <li>Accept if the new project ranks higher than existing projects</li>
      </ul>
    </div>

    <div>
      <h3 class="text-xl font-semibold mb-2">Diversity Preservation:</h3>
      <ul class="list-disc pl-5 mb-4 text-gray-600">
        <li>
          Use of PopulationQueue to maintain a diverse set of agents and
          environments
        </li>
        <li>Age-based removal of individuals</li>
        <li>Limit on how often each environment can be used</li>
      </ul>
    </div> -->

  <!-- <div> -->
  <!-- <h3 class="text-xl font-semibold mb-2">
      Additional Features:
    </h3>
    <ul class="list-disc pl-5 mb-4 text-gray-600">
      <li>Parallel execution for improved performance</li>
      <li>Logging of statistics and accepted projects</li>
      <li>Use of past projects to inform new project generation</li>
    </ul> -->

  <!-- <h3 class="text-xl font-semibold mb-2">Termination:</h3>
      <p class=" text-gray-600">
        The algorithm runs for a specified number of epochs or indefinitely
      </p>
    </div> -->
  <!-- <p class="text-gray-600">
    This algorithm aims to continuously generate novel and high-quality project
    ideas by evolving both the project templates and the creator pairings, while
    maintaining diversity in both populations.
  </p> -->
  <!-- </div> -->
  <!-- </div> -->
</div>

<style>
  .overview * {
    text-align: left;
  }
</style>
