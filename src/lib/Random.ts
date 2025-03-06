/**
 * Returns a random integer between min (inclusive) and max (inclusive)
 * @param min - The minimum value (inclusive)
 * @param max - The maximum value (inclusive)
 * @returns A random integer between min and max
 */
export function randInt(min: number, max: number): number {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

/**
 * Returns a random float between min (inclusive) and max (exclusive)
 * @param min - The minimum value (inclusive)
 * @param max - The maximum value (exclusive)
 * @returns A random float between min and max
 */
export function randFloat(min: number, max: number): number {
  return Math.random() * (max - min) + min;
}

/**
 * Shuffles an array in-place using the Fisher-Yates algorithm
 * @param array - The array to shuffle
 * @returns The shuffled array (same reference as input)
 */
export function shuffle<T>(array: T[]): T[] {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

/**
 * Creates a new shuffled copy of the array without modifying the original
 * @param array - The array to shuffle
 * @returns A new shuffled array
 */
export function shuffleCopy<T>(array: T[]): T[] {
  return shuffle([...array]);
}

/**
 * Returns a random element from an array
 * @param array - The array to pick from
 * @returns A random element from the array
 */
export function choice<T>(array: T[]): T {
  if (array.length === 0) {
    throw new Error("Cannot choose from an empty array");
  }
  return array[Math.floor(Math.random() * array.length)];
}

/**
 * Returns multiple random elements from an array
 * @param array - The array to pick from
 * @param count - The number of elements to pick
 * @param allowDuplicates - Whether to allow the same element to be picked multiple times
 * @returns An array of randomly selected elements
 */
export function sample<T>(
  array: T[],
  count: number,
  allowDuplicates = false
): T[] {
  if (array.length === 0) {
    throw new Error("Cannot sample from an empty array");
  }

  if (count < 0) {
    throw new Error("Count cannot be negative");
  }

  if (!allowDuplicates && count > array.length) {
    throw new Error(
      "Cannot sample more elements than available without duplicates"
    );
  }

  if (allowDuplicates) {
    const result: T[] = [];
    for (let i = 0; i < count; i++) {
      result.push(choice(array));
    }
    return result;
  } else {
    return shuffleCopy(array).slice(0, count);
  }
}

/**
 * Returns true or false based on a probability
 * @param probability - The probability of returning true (0-1)
 * @returns A boolean value
 */
export function chance(probability: number): boolean {
  if (probability < 0 || probability > 1) {
    throw new Error("Probability must be between 0 and 1");
  }
  return Math.random() < probability;
}

/**
 * Generates a random UUID v4
 * @returns A random UUID string
 */
export function uuid(): string {
  return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === "x" ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}
