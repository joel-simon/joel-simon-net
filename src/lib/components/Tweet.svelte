<script lang="ts">
  import { onMount } from "svelte";
  import { assets } from "$app/paths";

  export let url: string;
  let container: HTMLElement;
  let spinner: HTMLDivElement;

  // @ts-ignore
  onMount(() => window?.twttr.ready(load));

  let tries = 0;
  const maxTries = 3;

  async function load(): Promise<Function | void> {
    tries++;
    try {
      // @ts-ignore
      await window.twttr.widgets.createTweet(url, container, {
        align: "center",
        dnt: "true",
        theme: "light",
        // cards: "hidden",
        conversation: "none",
        width: "100%",
      });
      spinner.style.display = "none";
    } catch (error) {
      if (tries < maxTries) return load();
      console.error(
        `Errored ${tries} times while fetching tweet: ${url}`,
        error
      );
      container.style.display = "none";
    }
  }
</script>

<div class="tweet" bind:this={container}>
  <div class="spinner" bind:this={spinner}>
    <img src="{assets}/loading-spinner.svg" alt="Loading" />
  </div>
</div>

<style lang="postcss">
  .tweet {
    margin-top: 18px;
    width: 425px;
  }

  .spinner {
    display: flex;
    align-content: center;
    justify-content: center;
    margin-top: 18px;
    /* width: 375px; */
    height: 400px;
    border: 1px var(--gray-20) solid;
    border-radius: 8px;
  }
</style>
