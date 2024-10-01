<script lang="ts">
  import { createEventDispatcher, onMount } from "svelte";

  export let min = 0;
  export let max = 100;
  export let defaultValue = min;
  export let trackAnchorValue = defaultValue;
  export let label: string | null = null;
  export let name: string = label ?? "";
  export let step: number | "any" = 1;
  export let value: number = defaultValue;
  export let height: number = 22;
  export let thumbColor: string = "#CCCCCC"; // Fallback color
  export let containerStyle: string = "";
  export let classes = "";
  export let inputClasses = "";
  export let labelClasses = "";
  export let showArrows = true;
  export let showNumber = true;
  export let showX = true;

  const dispatch = createEventDispatcher();

  // If the slider step is 'any', we want the arrows to have a reasonable default.
  $: arrowStepAmount = step == "any" ? (max - min) / 20 : step;

  let inputWidth: number = 0;

  function adjustValue(amount: number) {
    value = Math.max(min, Math.min(value + amount, max));
  }

  function percentToPx(inputWidth: number, p: number) {
    return height / 2 + (inputWidth - height) * p;
  }

  $: valuePercent = Math.max(0, Math.min((value - min) / (max - min), 1));
  $: trackAnchorPercent = Math.max(
    0,
    Math.min((trackAnchorValue - min) / (max - min), 1)
  );
  $: thumbX = percentToPx(inputWidth, valuePercent);
  $: anchorX = percentToPx(inputWidth, trackAnchorPercent);
  $: X0 = Math.min(thumbX, anchorX) - height / 2;
  $: X1 = Math.max(thumbX, anchorX) + height / 2;
  $: trackWidth = X1 - X0;

  $: radius = height / 2 + 6;

  let mousedownSlider = false;
  let draggingSlider = false;
  let clientWidth: number;

  let recentSizeChange = true;
  let recentSizeChangeTimeout: null | ReturnType<typeof setTimeout> = null;

  function onChange() {
    recentSizeChange = true;
    if (recentSizeChangeTimeout) {
      clearTimeout(recentSizeChangeTimeout);
    }
    recentSizeChangeTimeout = setTimeout(() => (recentSizeChange = false), 20);
  }

  $: dispatch("change", { value });

  $: if (clientWidth) {
    onChange();
  }
  onMount(() => {
    onChange();
  });

  $: shouldAnimate = !draggingSlider && !recentSizeChange;
</script>

<svelte:body
  on:touchend={() => (mousedownSlider = false)}
  on:mouseup={() => (mousedownSlider = false)}
/>

<div
  class="slider flex flex-row gap-0 p-[6px] h-fit bg-sky-300 {classes}"
  bind:clientWidth
  style=" {containerStyle}; border-radius:{radius}px"
>
  {#if label}
    <label
      for={name}
      class="text-sm font-semibold !pt-0 ml-2 text-style-head absolute z-10 pointer-events-none {labelClasses}"
    >
      {label}
    </label>
  {/if}

  <div
    class="flex flex-row w-full flex-wrap justify-center items-center"
    class:gap-1={showArrows || showNumber}
  >
    <div class="flex flex-row flex-grow flex-1" bind:clientWidth={inputWidth}>
      <input
        type="range"
        class="m-0 h-fit min-w-[48px] {inputClasses}"
        name="{name} slider"
        {min}
        {max}
        bind:value
        on:input
        on:mousedown={() => (mousedownSlider = true)}
        on:mousemove={() => (draggingSlider = mousedownSlider)}
        on:touchstart={() => (mousedownSlider = true)}
        on:touchmove={() => (draggingSlider = mousedownSlider)}
        {step}
        style="height:{height}px;"
        style:--height="{height}px"
        style:--thumbHeight="{height}px"
      />
      {#if inputWidth}
        <div class="pointer-events-none">
          <div
            class="absolute h-full z-9 rounded-full"
            class:transition-all={shouldAnimate}
            style="background-color: var(--control-pressed); z-index:1; left: {X0}px; width:{trackWidth}px"
          />
          <div
            class="absolute h-full w-[24px] top-0 rounded-full border border-2 -translate-x-1/2"
            class:transition-all={shouldAnimate}
            style="background-color: {thumbColor}; z-index:2; border-color: var(--control-pressed); width: {height}px; height:{height}px; left:{thumbX}px"
          />
        </div>
      {/if}
    </div>
    <div class="flex items-center">
      {#if showNumber}
        <input
          type="number"
          class="!max-w-[32px] text-sm text-center p-0 !border-none {inputClasses}"
          bind:value
          on:input
          {step}
        />
      {/if}

      {#if showArrows || showX}
        <div class="flex flex-row items-center">
          {#if showArrows}
            <button
              class="toggle-arrow !bg-transparent"
              on:click={() => adjustValue(-arrowStepAmount)}
            >
              &#8595;
            </button>
            <button
              class="toggle-arrow !bg-transparent"
              on:click={() => adjustValue(arrowStepAmount)}
            >
              &#8593;
            </button>
          {/if}
          {#if showX}
            <button
              class="toggle-arrow !bg-transparent"
              on:click={() => (value = defaultValue)}
            >
              &#x2716;
            </button>
          {/if}
        </div>
      {/if}
    </div>
  </div>
</div>

<style>
  .slider {
    align-items: center;
    width: 100%;
    flex-shrink: 1;
    margin: 0 auto;
  }
  input[type="range"] {
    -webkit-appearance: none;
    appearance: none;
    width: 100%;
    cursor: pointer;
    outline: none;
    overflow: hidden;
    user-select: none;
    border-radius: calc(var(--height) * 0.5);
  }
  input[type="range"]::-webkit-slider-runnable-track {
    height: var(--thumbHeight);
  }
  input[type="range"]::-moz-range-track {
    height: var(--thumbHeight);
  }
  input[type="range"]::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    opacity: 0;
    height: var(--thumbHeight);
    width: var(--thumbHeight);
    border-radius: 50%;
    border: none;
    background-color: transparent;
  }
  input[type="range"]::-moz-range-thumb {
    height: var(--thumbHeight);
    width: var(--thumbHeight);
    border-radius: 50%;
    opacity: 0;
    background-color: transparent;
    border: none;
  }
  .toggle-arrow {
    cursor: pointer;
    display: flex;
    padding: 0 0.25rem;
    margin: 0 0.25rem;
  }
</style>
