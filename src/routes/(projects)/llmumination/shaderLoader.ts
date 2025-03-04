import JSZip from "jszip";

export interface ShaderData {
  name: string;
  code: string;
}

export interface GridPosition {
  i: number;
  j: number;
}

export interface GridPositions {
  rows: number;
  cols: number;
  grid_positions: { [key: string]: GridPosition };
}

export interface PopulationEntry {
  generation: number;
  genome_ids: string[];
  [key: string]: any; // For any other properties in the population data
}

export interface ShaderLoadResult {
  shaderMap: Map<string, string>;
  populationData: PopulationEntry[];
  gridPositions: GridPositions;
  //   initialGenomes: string[];
  error: string | null;
}

/**
 * Loads shader data from a zip file
 * @param zipUrl URL to the zip file containing shader data
 * @returns Promise with shader data, population data, and grid positions
 */
export async function loadShadersFromZip(
  zipUrl: string
): Promise<ShaderLoadResult> {
  const result: ShaderLoadResult = {
    shaderMap: new Map(),
    populationData: [],
    gridPositions: { rows: 0, cols: 0, grid_positions: {} },
    // initialGenomes: [],
    error: null,
  };

  try {
    const response = await fetch(zipUrl);
    if (!response.ok) {
      throw new Error(`Failed to fetch zip file: ${response.statusText}`);
    }

    const zipData = await response.arrayBuffer();
    const zip = await JSZip.loadAsync(zipData);

    // Load population data
    const populationFile = zip.files["population_data.jsonl"];
    const gridPositionsFile = zip.files["grid_positions.json"];

    if (!populationFile) {
      throw new Error("Population data file not found in zip");
    }
    if (!gridPositionsFile) {
      throw new Error("Grid positions file not found in zip");
    }

    // Load grid positions
    const gridPositionsContent = await gridPositionsFile.async("string");
    result.gridPositions = JSON.parse(gridPositionsContent);

    // Load population data
    const populationContent = await populationFile.async("string");
    result.populationData = populationContent
      .split("\n")
      .filter((line) => line.trim())
      .map((line) => JSON.parse(line));

    // Load all shader files into a map
    const shaderFiles = Object.keys(zip.files).filter(
      (filename) => filename.endsWith(".glsl") && !zip.files[filename].dir
    );

    // Create a map of all shaders
    await Promise.all(
      shaderFiles.map(async (filename) => {
        const content = await zip.files[filename].async("string");
        const id = filename.split("/").pop()?.replace(".glsl", "") || filename;
        result.shaderMap.set(id, content);
      })
    );

    // Set initial genomes from the first population entry
    // if (result.populationData.length > 0) {
    //   result.initialGenomes = result.populationData[0].genome_ids;
    // }

    return result;
  } catch (err) {
    console.error("Error loading shaders:", err);
    result.error =
      err instanceof Error ? err.message : "Unknown error loading shaders";
    return result;
  }
}
