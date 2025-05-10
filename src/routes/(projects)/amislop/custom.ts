import {
  AutoTokenizer,
  PreTrainedModel,
  PreTrainedTokenizer,
  Tensor,
} from "@xenova/transformers";

/**
 * Prepares an attention mask for a sequence of tokens
 * @param model The model that defines pad token configuration
 * @param tokens The input tokens tensor (from Xenova/Transformers)
 * @returns A tensor with the attention mask (from Xenova/Transformers)
 */
function prepareAttentionMask(model: PreTrainedModel, tokens: Tensor): Tensor {
  const pad_token_id = model.config.pad_token_id ?? null;
  const eos_token_id_value = model.config.eos_token_id;

  const eos_token_ids_array: number[] | null = Array.isArray(eos_token_id_value)
    ? eos_token_id_value
    : typeof eos_token_id_value === "number"
      ? [eos_token_id_value]
      : null;

  const tokenData = tokens.data; // This is a TypedArray, e.g., BigInt64Array
  const tokenDims = tokens.dims;

  let is_pad_token_in_inputs = false;
  if (pad_token_id !== null) {
    const padTokenComparable =
      typeof tokenData[0] === "bigint" ? BigInt(pad_token_id) : pad_token_id;
    for (let i = 0; i < tokenData.length; ++i) {
      if (tokenData[i] === padTokenComparable) {
        is_pad_token_in_inputs = true;
        break;
      }
    }
  }

  const is_pad_token_not_equal_to_eos_token_id =
    pad_token_id === null ||
    eos_token_ids_array === null ||
    !eos_token_ids_array.includes(pad_token_id);

  let attentionDataValues: BigInt64Array;

  if (is_pad_token_in_inputs && is_pad_token_not_equal_to_eos_token_id) {
    attentionDataValues = new BigInt64Array(tokenData.length);
    const padTokenComparable =
      typeof tokenData[0] === "bigint" ? BigInt(pad_token_id!) : pad_token_id!;
    for (let i = 0; i < tokenData.length; i++) {
      attentionDataValues[i] = tokenData[i] === padTokenComparable ? 0n : 1n;
    }
  } else {
    attentionDataValues = new BigInt64Array(tokenData.length).fill(1n);
  }
  return new Tensor("int64", attentionDataValues, tokenDims.slice());
}

/**
 * Apply softmax to convert logits to probabilities
 * @param logitsBatch Array of logit arrays (each inner array is for one item in a batch)
 * @returns Array of probability arrays
 */
function softmax(logitsBatch: number[][]): number[][] {
  const result: number[][] = [];

  for (let i = 0; i < logitsBatch.length; i++) {
    const row = logitsBatch[i];
    if (!row || row.length === 0) {
      result.push([]);
      continue;
    }
    const maxLogit = Math.max(...row);

    const expValues = row.map((x) => Math.exp(x - maxLogit));
    const sumExp = expValues.reduce((a, b) => a + b, 0);

    result.push(expValues.map((x) => x / sumExp));
  }

  return result;
}

/**
 * Calculates the probability of a specific next token given a prefix text.
 * @param model The PreTrainedModel to use for prediction.
 * @param tokenizer The PreTrainedTokenizer to process text.
 * @param prefixText The text preceding the target token.
 * @param targetNextTokenString The string representation of the single target token.
 * @returns Promise<number> The probability of the targetNextTokenString following the prefixText.
 */
export async function getNextTokenProbabilities(
  model: PreTrainedModel,
  tokenizer: PreTrainedTokenizer,
  prefixText: string,
  targetNextTokenString: string
): Promise<number> {
  if (!model || !model.can_generate) {
    throw new Error(
      "Model must be a PreTrainedModel with generation capability"
    );
  }
  if (!tokenizer) {
    throw new Error("Tokenizer must be provided");
  }

  // Tokenize the prefix text
  const prefixTokenizedInputs = await tokenizer(prefixText, {
    add_special_tokens: true, // Assuming model expects special tokens for context
    return_tensors: "pt", // Ensure tensors are returned for the model
  });

  const model_inputs: Record<string, Tensor> = {
    [model.main_input_name]: prefixTokenizedInputs.input_ids,
  };

  if (prefixTokenizedInputs.attention_mask) {
    model_inputs.attention_mask = prefixTokenizedInputs.attention_mask;
  } else {
    // Fallback if tokenizer doesn't provide it, though it usually does with return_tensors.
    model_inputs.attention_mask = prepareAttentionMask(
      model,
      prefixTokenizedInputs.input_ids
    );
  }

  // Run model forward pass
  console.time("model.forward");
  const output = await model.forward(model_inputs);
  console.timeEnd("model.forward");

  // Get logits for the last token prediction (shape [batch_size, 1, vocab_size])
  // Since prefixText is a single string, batch_size is 1.
  const logits_for_next_token_prediction = output.logits.slice(null, -1, null);

  // Extract the 1D array of logits for the next token prediction
  // Data is Float32Array for [1, 1, vocab_size], so it's already effectively 1D for our purposes.
  const logits1D = logits_for_next_token_prediction.data as Float32Array;

  // Apply softmax to get probabilities
  // softmax function expects number[][], so wrap and unwrap
  const probabilitiesMatrix = softmax([Array.from(logits1D)]);
  const probabilities1D = probabilitiesMatrix[0];

  if (!probabilities1D || probabilities1D.length === 0) {
    throw new Error("Could not compute probability distribution.");
  }

  // Tokenize the targetNextTokenString to get its ID
  // We don't want special tokens here, as it's a single target token.
  const targetTokenizedOutput = await tokenizer(targetNextTokenString, {
    add_special_tokens: false,
    padding: false, // No padding needed for single token
    truncation: false, // No truncation needed
  });

  const targetTokenIds = targetTokenizedOutput.input_ids.data;

  if (targetTokenIds.length === 0) {
    console.warn(
      `Target token string '${targetNextTokenString}' could not be tokenized. Returning 0 probability.`
    );
    return 0;
  }
  if (targetTokenIds.length > 1) {
    // If the target string tokenizes to more than one ID (e.g., "hello world" as targetNextTokenString)
    // this approach will use the ID of the first token.
    // The function expects targetNextTokenString to represent a single token concept.
    const firstTokenText = await tokenizer.decode([targetTokenIds[0]], {
      skip_special_tokens: true,
    });
    console.warn(
      `targetNextTokenString '${targetNextTokenString}' tokenized into multiple IDs: ${JSON.stringify(
        Array.from(targetTokenIds)
      )}. Using the first token ID ${
        targetTokenIds[0]
      } (decoded: '${firstTokenText}').`
    );
  }

  const targetTokenId = Number(targetTokenIds[0]); // data is a TypedArray, ensure it's a number

  if (targetTokenId < 0 || targetTokenId >= probabilities1D.length) {
    console.warn(
      `Target token ID ${targetTokenId} (for token '${targetNextTokenString}') is out of bounds for the probability distribution (length ${probabilities1D.length}). Returning 0 probability.`
    );
    return 0;
  }

  return probabilities1D[targetTokenId];
}
