<script lang="ts">
  // Citation properties
  export let citationKey: string = "lluminate2025";
  export let title: string =
    "LLuminate: Exploring Creative Boundaries with LLM-based Evolutionary Algorithms";
  export let author: string = "Simon, Joel";
  export let journal: string = "arXiv preprint";
  export let year: number = 2025;
  export let url: string = "https://joelsimon.net/lluminate";
  export let type: string = "article"; // article, inproceedings, etc.

  // Optional fields
  export let publisher: string | null = null;
  export let booktitle: string | null = null;
  export let pages: string | null = null;
  export let volume: string | null = null;
  export let number: string | null = null;
  export let doi: string | null = null;

  // Generate the BibTeX citation string
  $: citation = generateCitation();

  function generateCitation(): string {
    let result = `@${type}{${citationKey},\n`;
    result += `  title={${title}},\n`;
    result += `  author={${author}},\n`;

    if (journal) result += `  journal={${journal}},\n`;
    if (booktitle) result += `  booktitle={${booktitle}},\n`;
    if (year) result += `  year={${year}},\n`;
    if (publisher) result += `  publisher={${publisher}},\n`;
    if (pages) result += `  pages={${pages}},\n`;
    if (volume) result += `  volume={${volume}},\n`;
    if (number) result += `  number={${number}},\n`;
    if (doi) result += `  doi={${doi}},\n`;
    if (url) result += `  url={${url}}\n`;

    result += `}`;
    return result;
  }

  //   function copyToClipboard() {
  //     navigator.clipboard.writeText(citation);
  //     const btn = document.querySelector(".copy-button") as HTMLButtonElement;
  //     const originalText = btn.textContent;
  //     btn.textContent = "Copied!";
  //     setTimeout(() => (btn.textContent = originalText), 2000);
  //   }
</script>

<div class="bibtex-citation !text-sm">
  <p class="!w-full !text-center font-bold">BibTeX Citation</p>
  <pre class="bibtex-code !text-left">{citation}</pre>
  <!-- <button class="copy-button" on:click={copyToClipboard}>Copy Citation</button> -->
</div>

<style lang="postcss">
  .bibtex-citation {
    @apply mt-8 mb-4 rounded-md;
  }

  .bibtex-citation h3 {
    @apply mb-2 text-lg font-medium;
  }

  .bibtex-code {
    @apply p-3 bg-white dark:bg-gray-900 rounded border border-gray-300 dark:border-gray-700 text-sm font-mono overflow-x-auto bg-gray-50 dark:bg-gray-800;
    white-space: pre-wrap;
  }

  .copy-button {
    @apply mt-2 px-3 py-1 bg-blue-600 hover:bg-blue-700 text-white rounded text-sm transition-colors;
  }
</style>
