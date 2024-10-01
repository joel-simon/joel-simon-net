<script lang="ts">
  import type { ContextType } from "./types";
  import { getContext, onDestroy } from "svelte";
  import { tooltip } from "$lib/actions/tooltip";

  export let name: string[]; // Array of paper names

  const context: ContextType = getContext("citationContext");
  const numbers = context?.registerCitation(name);

  // Get full citations for tooltip
  $: fullCitations = name.map((n) => context.getCitation(n)?.fullCitation || n);

  // Optional: Handle cleanup if needed
  onDestroy(() => {
    // Implement if you need to unregister citations on component destroy
  });
</script>

<span class="citation-wrapper">
  <i>
    <slot></slot>
  </i>
  <span
    class="citation-number z-10 font-medium"
    title={fullCitations.join("\n\n")}
    use:tooltip
  >
    [{#each numbers as num, i}{i > 0 ? ", " : ""}{num}{/each}]
  </span>
</span>

<style>
  .citation-wrapper {
    position: relative;
  }
  .citation-number {
    cursor: help;
  }
</style>
