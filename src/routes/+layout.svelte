<script lang="ts">
  import "../app.css";
  import Footer from "$lib/components/Footer.svelte";

  import { page } from "$app/stores";

  // Define routes that should not show footer
  const routesWithoutFooter = ["forgotten-dreams"];
  $: showFooter = !routesWithoutFooter.some((route) =>
    $page.url.pathname.includes(route)
  );
</script>

<div class:mb-16={showFooter}>
  <slot />
</div>

{#if showFooter}
  <Footer />
{/if}
