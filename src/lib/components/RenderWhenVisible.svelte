<script lang="ts">
  import { onMount, onDestroy } from "svelte";

  // Props
  export let margin: number = 200; // Default margin of 200px
  export let once: boolean = true; // Only trigger once by default

  let visible: boolean = false;
  let container: HTMLElement;
  let observer: IntersectionObserver;

  function setupObserver() {
    // Create IntersectionObserver with options
    observer = new IntersectionObserver(
      (entries) => {
        const [entry] = entries;
        if (entry.isIntersecting) {
          visible = true;

          // If once is true, disconnect the observer after content becomes visible
          if (once && observer) {
            observer.disconnect();
          }
        } else if (!once) {
          // If not once mode, toggle visibility off when out of view
          visible = false;
        }
      },
      {
        rootMargin: `${margin}px`,
        threshold: 0,
      }
    );

    // Start observing the container element
    if (container) {
      observer.observe(container);
    }
  }

  onMount(() => {
    // Set up the IntersectionObserver when component is mounted
    setupObserver();
  });

  onDestroy(() => {
    // Clean up the observer when component is destroyed
    if (observer) {
      observer.disconnect();
    }
  });
</script>

<div bind:this={container} class="render-when-visible-container">
  {#if visible}
    <slot></slot>
  {:else}
    <!-- Optional placeholder element when content is not visible -->
    <div class="render-when-visible-placeholder">
      <slot name="placeholder"></slot>
    </div>
  {/if}
</div>

<style>
  .render-when-visible-container {
    width: 100%;
    min-height: 1px; /* Ensure container has height even when empty */
  }

  .render-when-visible-placeholder {
    width: 100%;
  }
</style>
