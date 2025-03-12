<script lang="ts">
  import { onMount } from "svelte";
  import strategiesData from "../data/strategies.json";
  import { shuffleCopy } from "$lib/Random";

  // Define types for the strategy data
  interface Operation {
    name: string;
    instruction: string;
  }

  interface Strategy {
    name: string;
    theory_base: string;
    description: string;
    operations: Operation[];
    example: string;
  }

  interface StrategiesData {
    strategies: Strategy[];
  }

  // Type assertion for imported data
  const typedStrategiesData = strategiesData as StrategiesData;

  // Colors for cards
  const cardColors = [
    { bg: "#f0f9ff", border: "#bae6fd", highlight: "#0ea5e9" }, // sky
    { bg: "#f0fdf4", border: "#bbf7d0", highlight: "#22c55e" }, // green
    { bg: "#fdf4ff", border: "#f5d0fe", highlight: "#d946ef" }, // fuchsia
    { bg: "#fff7ed", border: "#fed7aa", highlight: "#f97316" }, // orange
    { bg: "#f5f3ff", border: "#ddd6fe", highlight: "#8b5cf6" }, // violet
    { bg: "#ffedd5", border: "#fed7aa", highlight: "#f59e0b" }, // amber
    { bg: "#fef2f2", border: "#fecaca", highlight: "#ef4444" }, // red
  ];
</script>

<div class="strategies-container w-full overflow-x-auto flex gap-4">
  <!-- <h1>Creative Strategy Frameworks</h1> -->

  <!-- <div class="scroll-container" bind:this={scrollContainer}> -->
  {#each shuffleCopy(typedStrategiesData.strategies) as strategy, i}
    <div
      class="strategy-card"
      style="--card-bg: {cardColors[i % cardColors.length].bg}; 
               --card-border: {cardColors[i % cardColors.length].border}; 
               --card-highlight: {cardColors[i % cardColors.length].highlight};"
    >
      <div class="card-header">
        <h3>{strategy.name}</h3>
        <div class="theory-base">Based on: {strategy.theory_base}</div>
      </div>

      <!-- <div class="card-description">
        <p>{strategy.description}</p>
      </div> -->

      <div class="card-operations">
        <h3>Process:</h3>
        <ol>
          {#each strategy.operations as operation}
            <li class="text-left">
              <strong class="font-bold"
                >{operation.name.replace(/_/g, " ")}</strong
              >:
              {operation.instruction}
            </li>
          {/each}
        </ol>
      </div>

      <!-- <div class="card-example">
        <h3>Example:</h3>
        <p>{strategy.example}</p>
      </div> -->
    </div>
  {/each}
</div>

<style>
  .strategies-container {
    max-width: 100%;
    margin: 0 auto;
    padding: 1rem;
  }
  .strategy-card {
    flex: 0 0 auto;
    width: min(85%, 500px);
    border-radius: 12px;
    padding: 1.5rem;
    scroll-snap-align: center;
    background-color: var(--card-bg);
    border: 1px solid var(--card-border);
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
    display: flex;
    flex-direction: column;
  }

  .card-header {
    margin-bottom: 1rem;
    border-bottom: 1px solid var(--card-border);
    padding-bottom: 0.75rem;
  }

  .theory-base {
    font-size: 0.875rem;
    color: #64748b;
    font-style: italic;
  }

  .card-description {
    margin-bottom: 1rem;
  }

  .card-description p {
    line-height: 1.6;
    color: #334155;
  }

  .card-operations {
    margin-bottom: 1rem;
  }

  .card-operations h3 {
    margin: 0 0 0.5rem 0;
    color: #475569;
    font-size: 1rem;
  }

  .card-operations ol {
    padding-left: 1.5rem;
    margin: 0;
  }

  .card-operations li {
    margin-bottom: 0.5rem;
    color: #334155;
    font-size: 0.9rem;
  }

  @media (max-width: 640px) {
    .strategy-card {
      width: 90%;
      padding: 1rem;
    }

    .card-header h2 {
      font-size: 1.25rem;
    }

    .card-operations li,
    .card-example p {
      font-size: 0.85rem;
    }
  }
</style>
