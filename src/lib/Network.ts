export async function loadScript(url: string): Promise<void> {
  return await new Promise((resolve, reject) => {
    // Inject script into DOM
    const script = document.createElement("script");
    script.async = true;

    script.addEventListener("load", () => resolve());
    script.addEventListener("error", (e) => reject(e));

    script.src = url;
    document.body.appendChild(script);
  });
}

export async function fetchJson<T>(
  url: string,
  options?: RequestInit
): Promise<T> {
  try {
    const response = await fetch(url, options);

    if (!response.ok) {
      throw new Error(
        `Failed to fetch: ${response.status} ${response.statusText}`
      );
    }

    return (await response.json()) as T;
  } catch (error) {
    console.error(`Error fetching JSON from ${url}:`, error);
    throw error;
  }
}
