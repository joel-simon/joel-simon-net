<!-- HtmlContainer.svelte -->
<script lang="ts">
  import { onMount, onDestroy } from "svelte";

  // Props
  export let htmlSource: string;
  // export let key: string;
  // export let htmlPath: string = `/sourcdir/source/${key}.html`;
  // export let imagePath: string = `/sourcdir/images/${key}.jpg`;
  export let width: string = "512px";
  export let height: string = "512px";
  export let classes = "";
  export let scale: number = 1;
  // State
  let htmlContent: string | null = null;
  let loading: boolean = false;
  let error: string | null = null;
  let isVisible: boolean = false;

  // Observer reference
  let containerElement: HTMLElement;
  let observer: IntersectionObserver;

  // Load content when component becomes visible
  async function loadHtmlContent(): Promise<void> {
    loading = true;

    try {
      const response = await fetch(htmlSource);
      if (response.ok) {
        htmlContent = await response.text();
      } else {
        error = `Failed to load content (${response.status})`;
      }
    } catch (e) {
      const err = e as Error;
      error = err.message || "Failed to load content";
    } finally {
      loading = false;
    }
  }

  // Setup intersection observer when the component mounts
  onMount(() => {
    observer = new IntersectionObserver(
      (entries) => {
        const entry = entries[0];
        isVisible = entry.isIntersecting;

        // Only load content the first time it becomes visible
        if (entry.isIntersecting && !htmlContent && !loading) {
          loadHtmlContent();
        }
      },
      {
        rootMargin: "100px 0px",
        threshold: 0.1,
      }
    );

    observer.observe(containerElement);
  });

  onDestroy(() => {
    if (observer) {
      observer.disconnect();
    }
  });
</script>

<div class="html-container {classes}" bind:this={containerElement}>
  {#if loading}
    <div class="loading">
      <div class="spinner"></div>
      <p>Loading...</p>
    </div>
  {:else if error}
    <div class="error">
      <p>{error}</p>
      <button on:click={loadHtmlContent}>Retry</button>
    </div>
  {:else if htmlContent}
    <div
      class="iframe-container"
      style="width: {width}; height: {height}; overflow: hidden;"
    >
      {#if isVisible}
        <iframe
          srcdoc={htmlContent}
          title={`Content for page`}
          sandbox="allow-scripts"
          frameborder="0"
          loading="lazy"
          width={`${parseInt(width) * (1 / scale)}px`}
          height={`${parseInt(height) * (1 / scale)}px`}
          style="transform: scale({scale}); transform-origin: 0 0;"
        ></iframe>
      {/if}
    </div>
  {:else}
    <div class="placeholder">
      <p>Component will load when visible</p>
    </div>
  {/if}
</div>

<style>
  .loading,
  .error,
  .placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    min-height: 120px;
    text-align: center;
  }

  .error {
    color: red;
  }

  .spinner {
    width: 40px;
    height: 40px;
    border: 4px solid #f3f3f3;
    border-top: 4px solid #3498db;
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin-bottom: 12px;
  }

  .iframe-container {
    position: relative;
  }

  .iframe-container iframe {
    border: none;
    position: absolute;
    top: 0;
    left: 0;
  }

  @keyframes spin {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }
</style>
