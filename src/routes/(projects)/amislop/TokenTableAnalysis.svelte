<script lang="ts">
  import type { AnalysisResultItem, AnalysisResults } from "./SlopClassifier";

  export let results: AnalysisResultItem[];
  export let tokens: string[]; // Used to check if only one token was provided
  export let formatToken: (tok: string) => string;
  export let getProbabilityColor: (logProb: number) => string;
</script>

<!-- Token Analysis Table -->
<div>
  <h3 class="text-lg font-semibold text-gray-800 mb-4">
    Token-by-Token Analysis
  </h3>

  <!-- Legend -->
  <div class="flex justify-between mb-3 text-xs text-gray-600 px-1">
    <div class="flex items-center">
      <span
        class="w-4 h-2.5 rounded-sm mr-1.5"
        style="background-color: #ff6b6b;"
      ></span> Unexpected
    </div>
    <div class="flex items-center">
      <span
        class="w-4 h-2.5 rounded-sm mr-1.5"
        style="background-color: #ffe66d;"
      ></span> Average
    </div>
    <div class="flex items-center">
      <span
        class="w-4 h-2.5 rounded-sm mr-1.5"
        style="background-color: #4ecdc4;"
      ></span> Expected
    </div>
  </div>

  <!-- Token Grid -->
  <div class="space-y-1">
    <!-- Header -->
    <div
      class="grid grid-cols-[minmax(100px,_auto)_1fr_auto] gap-x-3 items-center text-sm font-medium text-gray-500 px-1 pb-1 border-b border-gray-200"
    >
      <div>Token</div>
      <div>Predictability</div>
      <div class="text-right">LogProb</div>
    </div>
    <!-- Data Rows -->
    {#each results as result, i (result.tokenId + "-" + i)}
      {@const tokenText = formatToken(result.token)}
      {@const logProb = result.logProbability}
      {@const color = getProbabilityColor(logProb)}
      {@const normalizedProb = isFinite(logProb)
        ? Math.max(0, Math.min(1, (logProb + 15) / 15))
        : 0}

      <div
        class="grid grid-cols-[minmax(100px,_auto)_1fr_auto] gap-x-3 items-center text-sm py-1 px-1 hover:bg-gray-50 rounded"
      >
        <!-- Token Text -->
        <div
          class="font-mono bg-gray-100 px-2 py-0.5 rounded text-gray-800 truncate"
          title={tokenText}
        >
          {tokenText}
        </div>
        <!-- Probability Bar -->
        <div class="h-5 bg-gray-200 rounded relative overflow-hidden my-0.5">
          <div
            class="absolute top-0 left-0 h-full rounded"
            style="width: {normalizedProb * 100}%; background-color: {color};"
            title={`LogProb: ${isFinite(logProb) ? logProb.toFixed(2) : "N/A"}`}
          ></div>
        </div>
        <!-- Log Probability Value -->
        <div class="text-right text-gray-700 font-mono text-xs">
          {isFinite(logProb) ? logProb.toFixed(2) : "-Inf"}
        </div>
      </div>
    {/each}
  </div>
  {#if tokens.length > 0 && results.length === 0}
    <p class="text-sm text-gray-500 mt-4 px-1">
      Only one token was provided. Cannot calculate predictability for the first
      token.
    </p>
  {/if}
</div>
