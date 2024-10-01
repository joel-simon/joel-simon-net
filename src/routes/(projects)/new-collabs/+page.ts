import type { PageLoad } from "./$types";

export const load: PageLoad = async ({ fetch }) => {
  // Fetch the JSONL file from the static folder
  const response = await fetch("/ideas/positive.jsonl");
  const textData = await response.text();
  //   console.log(textData);

  // Parse the JSONL file into an array of objects
  const projects = textData
    .split("\n")
    .filter((line) => {
      try {
        return line.trim().length > 2000;
      } catch (error) {
        console.error("Error filtering line:", error);
        return false;
      }
    })
    .map((line) => {
      try {
        return JSON.parse(line).data;
      } catch (error) {
        console.error("Error parsing JSON:", error);
        return null;
      }
    })
    .filter((project) => project !== null)
    .slice(0, 30);
  // console.log(projects);

  return {
    projects,
  };
};
