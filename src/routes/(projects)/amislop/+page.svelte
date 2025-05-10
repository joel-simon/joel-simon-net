<script lang="ts">
  import { onMount } from "svelte";
  import {
    SlopAnalyzer,
    type AnalysisResults,
    type AnalysisResultItem,
  } from "./SlopClassifier";

  // --- Component State ---
  let inputText = "The quick brown fox jumps over the lazy dog.";
  let selectedModel = "gpt2"; // 'distilgpt2' or 'gpt2'
  let loading = false;
  let progress = 0;
  let statusText = "Ready to analyze text.";
  let analysisResults: AnalysisResults | null = null;
  let errorMessage: string | null = null;

  // Reference to the analyzer
  let slopAnalyzer: SlopAnalyzer;

  // Update loading bar & status
  function updateProgressExternal(p: number, text: string) {
    progress = p;
    statusText = text;
  }

  function setErrorMessageExternal(message: string | null) {
    errorMessage = message;
  }

  onMount(() => {
    // Initialize the SlopAnalyzer with callback functions
    slopAnalyzer = new SlopAnalyzer(
      updateProgressExternal,
      setErrorMessageExternal
    );
  });

  // Pick a color based on how "expected" a log-probability is
  function getProbabilityColor(logProb: number): string {
    if (!isFinite(logProb)) return "rgb(150,150,150)";
    const norm = Math.max(0, Math.min(1, (logProb + 15) / 15));
    if (norm < 0.5) {
      const t = norm * 2;
      return `rgb(255,${Math.floor(107 + t * (230 - 107))},${Math.floor(
        107 + t * (109 - 107)
      )})`;
    } else {
      const t = (norm - 0.5) * 2;
      return `rgb(${Math.floor(255 - t * (255 - 78))},${Math.floor(
        230 - t * (230 - 205)
      )},${Math.floor(109 + t * (196 - 109))})`;
    }
  }

  // When the user clicks "Analyze"
  async function analyzeText() {
    if (!inputText.trim()) {
      errorMessage = "Please enter some text.";
      return;
    }
    if (!slopAnalyzer) {
      errorMessage = "Analyzer not initialized. Please refresh.";
      return;
    }

    loading = true;
    analysisResults = null;
    // errorMessage = null; // Error message will be set by the analyzer via callback
    updateProgressExternal(
      0,
      "Starting analysis with " + selectedModel + "..."
    );

    try {
      analysisResults = await slopAnalyzer.analyzeText(
        inputText,
        selectedModel
      );
      // Progress and final status ("Analysis complete." or error status) are set by slopAnalyzer via callbacks.
      // If analyzeText throws, it will be caught below. If it returns an error-like AnalysisResults,
      // the UI will display that (e.g., perplexity Infinity).
    } catch (err: any) {
      console.error("Error during analysis:", err);
      // The slopAnalyzer's analyzeText method is designed to set the error message
      // via callback and return a default/error AnalysisResults object.
      // So, direct setting of errorMessage here might be redundant if slopAnalyzer always handles it.
      if (!errorMessage) {
        // Fallback if analyzer didn't set one (should not happen with current design)
        errorMessage = err.message || "An unexpected error occurred.";
      }
      statusText = "Analysis failed."; // General status update
    } finally {
      loading = false;
      // If analysisResults is still null here due to a deeper error not caught gracefully by analyzer,
      // ensure it's at least an empty structure to prevent UI errors.
      if (!analysisResults) {
        analysisResults = {
          tokens: [],
          results: [],
          averageLogProb: -Infinity,
          perplexity: Infinity,
        };
      }
    }
  }

  // Make spaces visible
  const formatToken = (tok: string) => tok.replace(/ /g, "␣");
</script>

<svelte:head>
  <title>Text Averageness Analyzer (Svelte)</title>
  <!-- TensorFlow.js and Transformers.js are loaded via imports -->
</svelte:head>

<div class="max-w-3xl mx-auto p-6 md:p-8 my-8 bg-white rounded-lg shadow-lg">
  <h1 class="text-2xl md:text-3xl font-bold text-center text-gray-800 mb-6">
    Are you Slop?
  </h1>
  <p class="text-gray-600 mb-6 text-center">
    Analyze how "average" or predictable your text is using a language model.
    Lower perplexity means more predictable text.
  </p>

  <!-- Input Section -->
  <div class="mb-6 space-y-4">
    <div>
      <label
        for="inputText"
        class="block text-sm font-medium text-gray-700 mb-1"
        >Enter your text:</label
      >
      <textarea
        id="inputText"
        bind:value={inputText}
        placeholder="Enter some text to analyze..."
        class="w-full h-40 p-3 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500 resize-y text-base"
        disabled={loading}
      ></textarea>
    </div>

    <div class="flex flex-col sm:flex-row justify-between items-center gap-4">
      <div>
        <label
          for="modelSelect"
          class="block text-sm font-medium text-gray-700 mb-1 sm:mb-0 sm:inline-block sm:mr-2"
          >Choose model:</label
        >
        <select
          id="modelSelect"
          bind:value={selectedModel}
          class="p-2 border border-gray-300 rounded-md shadow-sm focus:ring-blue-500 focus:border-blue-500"
          disabled={loading}
        >
          <option value="distilgpt2">DistilGPT-2 (Fast)</option>
          <option value="gpt2">GPT-2 (Better accuracy)</option>
        </select>
      </div>
      <button
        on:click={analyzeText}
        disabled={loading || !inputText.trim()}
        class="w-full sm:w-auto bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-5 rounded-md transition duration-200 ease-in-out disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {#if loading}
          <svg
            class="animate-spin -ml-1 mr-2 h-5 w-5 text-white inline"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
          >
            <circle
              class="opacity-25"
              cx="12"
              cy="12"
              r="10"
              stroke="currentColor"
              stroke-width="4"
            ></circle>
            <path
              class="opacity-75"
              fill="currentColor"
              d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
            ></path>
          </svg>
          Analyzing...
        {:else}
          Analyze Text
        {/if}
      </button>
    </div>
  </div>

  <!-- Loading/Status Indicator -->
  {#if loading || statusText !== "Ready to analyze text."}
    <div class="my-6 text-center">
      {#if loading}
        <div
          class="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700 mb-2"
        >
          <div
            class="bg-blue-600 h-2.5 rounded-full transition-all duration-300"
            style="width: {progress * 100}%"
          ></div>
        </div>
      {/if}
      <p class="text-sm text-gray-600">{statusText}</p>
    </div>
  {/if}

  <!-- Error Message -->
  {#if errorMessage}
    <div
      class="my-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded-md"
      role="alert"
    >
      <p><strong class="font-bold">Error:</strong> {errorMessage}</p>
    </div>
  {/if}

  <!-- Results Section -->
  {#if analysisResults && !loading}
    <div class="mt-8">
      <!-- Summary -->
      <div class="bg-blue-50 p-4 rounded-md mb-6 border border-blue-200">
        <h3 class="text-lg font-semibold text-gray-800 mb-2">
          Analysis Summary
        </h3>
        <p class="text-gray-700">
          Overall Perplexity Score:
          <strong class="text-blue-700">
            {isFinite(analysisResults.perplexity)
              ? analysisResults.perplexity.toFixed(2)
              : "Infinity"}
          </strong>
        </p>
        <p class="text-sm text-gray-600 mt-1">
          (Lower perplexity indicates more predictable/average text based on the
          model.)
        </p>
      </div>

      <!-- Token Analysis -->
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
          {#each analysisResults.results as result, i (result.tokenId + "-" + i)}
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
              <div
                class="h-5 bg-gray-200 rounded relative overflow-hidden my-0.5"
              >
                <div
                  class="absolute top-0 left-0 h-full rounded"
                  style="width: {normalizedProb *
                    100}%; background-color: {color};"
                  title={`LogProb: ${
                    isFinite(logProb) ? logProb.toFixed(2) : "N/A"
                  }`}
                ></div>
              </div>
              <!-- Log Probability Value -->
              <div class="text-right text-gray-700 font-mono text-xs">
                {isFinite(logProb) ? logProb.toFixed(2) : "-Inf"}
              </div>
            </div>
          {/each}
        </div>
        {#if analysisResults.tokens.length > 0 && analysisResults.results.length === 0}
          <p class="text-sm text-gray-500 mt-4 px-1">
            Only one token was provided. Cannot calculate predictability for the
            first token.
          </p>
        {/if}
      </div>
    </div>
  {/if}
</div>
