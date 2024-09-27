import type { PageLoad } from "./$types";

export const load: PageLoad = async ({ fetch }) => {
  // Fetch the JSONL file from the static folder
  const response = await fetch("/ideas/positive.jsonl");
  const textData = await response.text();
  //   console.log(textData);

  // Parse the JSONL file into an array of objects
  const projects = textData
    .split("\n")
    .filter((line) => line.trim() !== "")
    .map((line) => JSON.parse(line).data);
  // console.log(projects);

  return {
    projects,
  };
};
