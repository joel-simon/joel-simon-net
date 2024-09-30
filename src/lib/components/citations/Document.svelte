<script lang="ts">
  import { setContext } from "svelte";
  import type { Citation, ContextType } from "./types";

  export let citationsData: Citation[]; // Array of all possible citations

  // Map to store citation names and their assigned numbers
  const citationsMap = new Map<string, number>();
  const orderedCitations: string[] = [];

  // Function to register citations and assign numbers
  function registerCitation(names: string[]): number[] {
    const numbers: number[] = [];
    names.forEach((name) => {
      if (!citationsMap.has(name)) {
        orderedCitations.push(name);
        citationsMap.set(name, orderedCitations.length);
      }
      const num = citationsMap.get(name)!;
      numbers.push(num);
    });
    return numbers;
  }

  // Function to get full citation data
  function getCitation(name: string): Citation | undefined {
    return citationsData.find((c) => c.paperName === name);
  }

  // Provide the context to child components
  setContext<ContextType>("citationContext", { registerCitation, getCitation });
</script>

<!-- Slot for document content -->
<slot />

<!-- References Section -->
<!-- <hr /> -->
<div class="text_body">
  <h2>References</h2>
  <ol>
    {#each orderedCitations as name, index}
      {@const citation = citationsData.find((c) => c.paperName === name)}
      <li>
        {#if citation}
          <p>{index + 1}. {citation.fullCitation}</p>
        {:else}
          {name} <!-- Fallback if citation data is missing -->
        {/if}
      </li>
    {/each}
  </ol>
</div>
