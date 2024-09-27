<!-- src/components/Citation.svelte -->
<script lang="ts">
  import type { ContextType } from "./types";
  import { getContext, onDestroy } from "svelte";
  export let name: string[]; // Array of paper names

  const context: ContextType = getContext("citationContext");
  const numbers = context.registerCitation(name);

  // Optional: Handle cleanup if needed
  onDestroy(() => {
    // Implement if you need to unregister citations on component destroy
  });
</script>

<i>
  <slot></slot>
</i>
<span
  >[{#each numbers as num, i}{i > 0 ? ", " : ""}{num}{/each}]</span
>
