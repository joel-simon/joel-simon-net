<script lang="ts">
  import SmallProjectLink from "$lib/components/SmallProjectLink.svelte";
  import { projects } from "$lib/data";
</script>

<div class="text_body">
  <h2>Related Art/Research Projects:</h2>
  <!-- <p>
    If you enjoyed this you may also enjoy my other independent
    research-art projects.
  </p> -->
  <div class="w-full grid grid-cols-2 md:grid-cols-4 gap-4 my-4">
    {#each projects as project}
      {#if project.labels.includes("research-art")}
        <SmallProjectLink projectName={project.name} />
      {/if}
    {/each}
  </div>
  <h2>Acknowledgements</h2>
  <p>
    Thanks to Joel Lehman and Kenneth Stanley for their very helpful feedback
    and kind encouragement. This was done while in-residence at
    <a href="https://stochasticlabs.org/">Stochastic Labs.</a>
  </p>
</div>

<div class="text_body">
  <div>
    <h2>To cite this blog</h2>
    <p>
      Simon, J. (2024, September 26). New Collabs. <i>JoelSimon.net</i>.
      <a href="https://www.joelsimon.net/new-collabs"
        >https://www.joelsimon.net/new-collabs</a
      >
    </p>
  </div>
</div>
