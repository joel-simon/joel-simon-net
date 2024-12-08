interface DownloadCanvasOptions {
  filename: string;
  includeDate?: boolean;
  extension?: string;
}
export function downloadCanvas(
  canvas: HTMLCanvasElement,
  { filename, includeDate = true, extension = "png" }: DownloadCanvasOptions
) {
  const link = document.createElement("a");
  const image = canvas.toDataURL(`image/${extension}`);
  link.download = `${filename}${
    includeDate ? `-${Date.now()}` : ""
  }.${extension}`;
  link.href = image;
  link.click();
}
