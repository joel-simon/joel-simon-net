<script lang="ts">
  export let classes = "";
  export let options: { label: string; value: string }[];
  export let selected: string = options[0].value;
</script>

<div class="flex gap-2 {classes}">
  {#each options as option}
    <p
      class="text-radio-button {option.value === selected ? 'selected' : ''}"
      on:click={() => (selected = option.value)}
    >
      {option.label}
    </p>
  {/each}
</div>

<style>
  .text-radio-button {
    @apply cursor-pointer transition-all duration-300 ease-in-out px-4 py-1 capitalize select-none rounded-full;
  }
  .text-radio-button:hover {
    @apply bg-gray-100;
  }
  .text-radio-button.selected {
    @apply bg-gray-200;
  }
</style>
