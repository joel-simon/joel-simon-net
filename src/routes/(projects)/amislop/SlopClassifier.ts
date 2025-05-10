import {
  env,
  AutoTokenizer,
  AutoModelForCausalLM,
  type PreTrainedTokenizer,
  type PreTrainedModel,
  // Tensor, // Tensor is used by custom.ts, not directly here for new tensors
} from "@xenova/transformers";
// import * as tf from "@tensorflow/tfjs"; // Not strictly needed here if not directly using tf.Tensor
import { getNextTokenProbabilities } from "./custom";

// Configure Transformers.js environment
// These settings are global, so they only need to be set once.
env.allowLocalModels = false;
env.useBrowserCache = true;

export interface AnalysisResultItem {
  token: string;
  tokenId: number;
  probability: number;
  logProbability: number;
}

export interface AnalysisResults {
  tokens: string[];
  results: AnalysisResultItem[];
  averageLogProb: number;
  perplexity: number;
}

export class SlopAnalyzer {
  private tokenizer: PreTrainedTokenizer | null = null;
  private model: PreTrainedModel | null = null;
  private currentModelName: string = "";

  private updateProgressCallback: (p: number, text: string) => void;
  private setErrorMessageCallback: (message: string | null) => void;
  private onTokenProcessedCallback?: (
    item: AnalysisResultItem | string
  ) => void; // Can be a single token string (first token) or an item

  constructor(
    updateProgressCallback: (p: number, text: string) => void,
    setErrorMessageCallback: (message: string | null) => void,
    onTokenProcessedCallback?: (item: AnalysisResultItem | string) => void
  ) {
    this.updateProgressCallback = updateProgressCallback;
    this.setErrorMessageCallback = setErrorMessageCallback;
    this.onTokenProcessedCallback = onTokenProcessedCallback;
  }

  private async _loadModel(modelName: string): Promise<void> {
    this.setErrorMessageCallback(null);
    try {
      this.updateProgressCallback(0.1, `Loading tokenizer for ${modelName}...`);
      this.tokenizer = await AutoTokenizer.from_pretrained(
        `Xenova/${modelName}`
      );
      this.updateProgressCallback(
        0.4,
        `Loading model weights for ${modelName}...`
      );
      this.model = await AutoModelForCausalLM.from_pretrained(
        `Xenova/${modelName}`
      );
      this.currentModelName = modelName;
      this.updateProgressCallback(1, `${modelName} model loaded successfully!`);
    } catch (err: any) {
      console.error(`Error loading model ${modelName}:`, err);
      const errorMessage = `Error loading model ${modelName}: ${err.message}`;
      this.setErrorMessageCallback(errorMessage);
      this.updateProgressCallback(0, `Error loading ${modelName}.`);
      this.tokenizer = null;
      this.model = null;
      this.currentModelName = "";
      throw new Error(errorMessage);
    }
  }

  public async analyzeText(
    text: string,
    modelName: string
  ): Promise<AnalysisResults> {
    this.setErrorMessageCallback(null);

    try {
      if (
        !this.model ||
        this.currentModelName !== modelName ||
        !this.tokenizer
      ) {
        this.updateProgressCallback(0, `Switching to ${modelName} model...`);
        await this._loadModel(modelName);
      }

      if (!this.tokenizer || !this.model) {
        const errMessage =
          "Model or tokenizer not available. Load attempt might have failed.";
        this.setErrorMessageCallback(errMessage);
        throw new Error(errMessage);
      }

      this.updateProgressCallback(0.1, "Tokenizing text...");
      console.time("Tokenizing text");
      const { input_ids } = await this.tokenizer(text, {
        add_special_tokens: false,
        padding: false,
        truncation: true,
      });
      console.timeEnd("Tokenizing text");

      const tokenIds = Array.from(input_ids.data).map(Number);

      if (!tokenIds.length) {
        this.setErrorMessageCallback("Input text resulted in no tokens.");
        return {
          tokens: [],
          results: [],
          averageLogProb: -Infinity,
          perplexity: Infinity,
        };
      }

      const tokens = tokenIds.map((id) =>
        this.tokenizer!.decode([id], { skip_special_tokens: true })
      );

      // Immediately provide the first token if the callback exists
      if (this.onTokenProcessedCallback && tokens.length > 0) {
        this.onTokenProcessedCallback(tokens[0]);
      }

      this.updateProgressCallback(0.2, "Computing token-level stats...");
      const results: AnalysisResultItem[] = [];

      if (tokenIds.length <= 1) {
        this.updateProgressCallback(1, "Analysis complete (only one token).");
        return {
          tokens: tokens,
          results: [],
          averageLogProb: -Infinity,
          perplexity: Infinity,
        };
      }

      for (let i = 0; i < tokenIds.length - 1; i++) {
        const prefixTokenIds = tokenIds.slice(0, i + 1);
        const targetTokenId = tokenIds[i + 1];
        const targetTokenString = tokens[i + 1];

        const prefixText = this.tokenizer.decode(prefixTokenIds, {
          skip_special_tokens: true,
        });

        const loopProgress = ((i + 1) / (tokenIds.length - 1)) * 0.7;
        this.updateProgressCallback(
          0.2 + loopProgress,
          `Analyzing token ${i + 2}/${tokenIds.length}: '${targetTokenString}'`
        );

        console.time("getNextTokenProbabilities");
        const probability = await getNextTokenProbabilities(
          this.model,
          this.tokenizer,
          prefixText,
          targetTokenString
        );
        console.timeEnd("getNextTokenProbabilities");

        const logProbability =
          probability > 0 ? Math.log(probability) : -Infinity;

        results.push({
          token: targetTokenString,
          tokenId: targetTokenId,
          probability: probability,
          logProbability: logProbability,
        });

        // Provide the processed item if the callback exists
        if (this.onTokenProcessedCallback) {
          this.onTokenProcessedCallback(results[results.length - 1]);
        }

        // Yield to the event loop to allow UI updates
        await new Promise((resolve) => setTimeout(resolve, 0));
      }

      const logs = results.map((r) => r.logProbability).filter(Number.isFinite);
      const avgLog = logs.length
        ? logs.reduce((a, b) => a + b, 0) / logs.length
        : -Infinity;

      this.updateProgressCallback(1, "Analysis complete.");
      return {
        tokens: tokens,
        results,
        averageLogProb: avgLog,
        perplexity: isFinite(avgLog) ? Math.exp(-avgLog) : Infinity,
      };
    } catch (err: any) {
      console.error("Error in SlopAnalyzer.analyzeText:", err);
      if (err.message) {
        this.setErrorMessageCallback(err.message);
      } else {
        this.setErrorMessageCallback(
          "An unexpected error occurred during analysis."
        );
      }
      this.updateProgressCallback(0, "Error during analysis.");
      return {
        tokens: [],
        results: [],
        averageLogProb: -Infinity,
        perplexity: Infinity,
      };
    }
  }
}
