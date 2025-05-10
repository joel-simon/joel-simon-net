<script lang="ts">
  import { onMount } from "svelte";
  import {
    env,
    AutoTokenizer,
    AutoModelForCausalLM,
    type PreTrainedTokenizer,
    type PreTrainedModel,
  } from "@xenova/transformers";
  import * as tf from "@tensorflow/tfjs";
  import { getNextTokenProbabilities } from "./custom";
  // Disable remote models, use browser cache
  env.allowLocalModels = false;
  env.useBrowserCache = true;

  // --- Component State ---
  let inputText = "The quick brown fox jumps over the lazy dog.";
  let selectedModel = "distilgpt2"; // 'distilgpt2' or 'gpt2'
  let loading = false;
  let progress = 0;
  let statusText = "Ready to analyze text.";
  let analysisResults: AnalysisResults | null = null;
  let errorMessage: string | null = null;

  // Track which model is currently loaded
  let currentModelName = "";

  // References to tokenizer & model
  let tokenizer: PreTrainedTokenizer | null = null;
  let model: PreTrainedModel | null = null;

  // --- Types ---
  interface AnalysisResultItem {
    token: string;
    tokenId: number;
    probability: number;
    logProbability: number;
  }

  interface AnalysisResults {
    tokens: string[];
    results: AnalysisResultItem[];
    averageLogProb: number;
    perplexity: number;
  }

  // Update loading bar & status
  function updateProgress(p: number, text: string) {
    progress = p;
    statusText = text;
  }

  // Load tokenizer & model for a given name
  async function loadModel(modelName: string) {
    errorMessage = null;
    try {
      updateProgress(0.1, `Loading tokenizer...`);
      tokenizer = await AutoTokenizer.from_pretrained(`Xenova/${modelName}`);
      updateProgress(0.4, `Loading model weights...`);
      model = await AutoModelForCausalLM.from_pretrained(`Xenova/${modelName}`);
      currentModelName = modelName;
      updateProgress(1, "Model loaded successfully!");
    } catch (err: any) {
      console.error("Error loading model:", err);
      errorMessage = `Error loading model: ${err.message}`;
      statusText = "Error loading model.";
      tokenizer = null;
      model = null;
      throw err;
    }
  }
  /**
   * Gets probabilities for the next token in a sequence.
   * @param {import('./generation/parameters.js').GenerationFunctionParameters} options
   * @returns {Promise<Object>} The output containing next token probabilities
   */

  // Compute per-token probabilities & log-probs
  async function calculateTokenProbabilities(
    text: string
  ): Promise<AnalysisResults> {
    if (!tokenizer || !model) {
      throw new Error("Model or tokenizer not loaded.");
    }
    errorMessage = null; // Clear previous errors
    const tensorsToDispose: tf.Tensor[] = []; // Keep for tf.js specific tensors if any future use, though not used in this flow now

    try {
      updateProgress(0.1, "Tokenizing text...");
      // Tokenize the entire input text once
      const { input_ids, attention_mask } = await tokenizer(text, {
        add_special_tokens: false, // Usually false for this kind of analysis
        padding: false, // No padding needed for the full sequence analysis here
        truncation: true, // Truncate if too long for the model
        // return_tensors: "pt" // Not strictly needed here as we operate on IDs directly
      });

      const tokenIds = Array.from(input_ids.data).map(Number); // Convert BigInt64Array to number[]

      if (!tokenIds.length) {
        throw new Error("No tokens returned by tokenizer.");
      }

      const tokens = tokenIds.map((id) =>
        tokenizer!.decode([id], { skip_special_tokens: true })
      );

      updateProgress(0.2, "Computing token-level stats...");
      const results: AnalysisResultItem[] = [];

      // We can only calculate probability for tokens from the second one onwards,
      // as the first token has no preceding context in this simple setup.
      for (let i = 0; i < tokenIds.length - 1; i++) {
        const prefixTokenIds = tokenIds.slice(0, i + 1);
        const targetTokenId = tokenIds[i + 1];
        const targetTokenString = tokens[i + 1];

        // Decode prefix token IDs to string for the custom function
        // We need to be careful here: tokenizer.decode might add/remove spaces differently
        // than how tokens were originally joined. For P(target | prefix),
        // the prefix should ideally be what the model saw to produce that target.
        // Let's decode the prefix and pass it. custom.ts will re-tokenize this prefix.
        const prefixText = tokenizer.decode(prefixTokenIds, {
          skip_special_tokens: true,
        });

        updateProgress(
          0.2 + ((i + 1) / (tokenIds.length - 1)) * 0.7,
          `Analyzing token ${i + 2}/${tokenIds.length}: '${targetTokenString}'`
        );

        const probability = await getNextTokenProbabilities(
          model,
          tokenizer,
          prefixText,
          targetTokenString
        );

        const logProbability =
          probability > 0 ? Math.log(probability) : -Infinity;

        results.push({
          token: targetTokenString,
          tokenId: targetTokenId,
          probability: probability,
          logProbability: logProbability,
        });
      }

      const logs = results.map((r) => r.logProbability).filter(Number.isFinite);
      const avgLog = logs.length
        ? logs.reduce((a, b) => a + b, 0) / logs.length
        : -Infinity;

      updateProgress(1, "Done.");
      return {
        tokens: tokens, // Full list of token strings from the input
        results, // Results for tokens 1 to N (predictability of token k given 0..k-1)
        averageLogProb: avgLog,
        perplexity: isFinite(avgLog) ? Math.exp(-avgLog) : Infinity,
      };
    } catch (err: any) {
      console.error("Error in calculateTokenProbabilities:", err);
      errorMessage =
        err.message || "An unexpected error occurred during analysis.";
      statusText = "Error during analysis.";
      // Return a dummy/error result to satisfy the Promise type if needed, or rethrow
      // For now, let's ensure it always returns an AnalysisResults object or throws.
      // If an error is caught, it should be handled by the caller, but we need to satisfy the type.
      return {
        tokens: [],
        results: [],
        averageLogProb: -Infinity,
        perplexity: Infinity,
      };
    } finally {
      tf.dispose(tensorsToDispose); // Dispose any tf.js tensors if they were used
    }
  }

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

    loading = true;
    analysisResults = null;
    errorMessage = null;
    updateProgress(0, "Starting…");

    try {
      // Reload model if selection changed
      if (!model || currentModelName !== selectedModel) {
        await loadModel(selectedModel);
      }
      updateProgress(0.6, "Computing token-level stats…");
      analysisResults = await calculateTokenProbabilities(inputText);
      updateProgress(1, "Done.");
    } catch (err: any) {
      console.error(err);
      if (!errorMessage) errorMessage = err.message;
    } finally {
      loading = false;
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
    Text Averageness Analyzer
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
