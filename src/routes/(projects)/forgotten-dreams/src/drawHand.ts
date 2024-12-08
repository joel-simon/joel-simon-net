import type { NormalizedLandmarkList } from "@mediapipe/hands";
import handsModule from "@mediapipe/hands";
const palmIndices = [0, 1, 2, 5, 9, 13, 17];
// Add HAND_CONNECTIONS constant
const HAND_CONNECTIONS: [number, number][] = [
  [0, 1],
  [1, 2],
  [2, 3],
  [3, 4], // thumb
  [0, 5],
  [5, 6],
  [6, 7],
  [7, 8], // index finger
  [0, 9],
  [9, 10],
  [10, 11],
  [11, 12], // middle finger
  [0, 13],
  [13, 14],
  [14, 15],
  [15, 16], // ring finger
  [0, 17],
  [17, 18],
  [18, 19],
  [19, 20], // pinky
];

type Connection = [number, number];

export function drawConnectors(
  ctx: CanvasRenderingContext2D,
  landmarks: { x: number; y: number; z?: number }[],
  connections: Connection[],
  options: {
    color: string;
    lineWidth?: number;
  }
) {
  const { color, lineWidth = 1 } = options;
  const canvas = ctx.canvas;

  ctx.save();
  ctx.strokeStyle = color;
  ctx.lineWidth = lineWidth;
  ctx.lineCap = "round";

  connections.forEach(([startIdx, endIdx]) => {
    const start = landmarks[startIdx];
    const end = landmarks[endIdx];

    if (!start || !end) return;

    ctx.beginPath();
    ctx.moveTo(start.x * canvas.width, start.y * canvas.height);
    ctx.lineTo(end.x * canvas.width, end.y * canvas.height);
    ctx.stroke();
  });

  ctx.restore();
}

export function drawHand(
  handCtx: CanvasRenderingContext2D,
  landmarks: NormalizedLandmarkList,
  color: string = "white"
) {
  const handCanvas = handCtx.canvas;

  // Calculate hand width using distance between wrist (0) and base of index finger (5)
  const wrist = landmarks[0];
  const indexBase = landmarks[5];
  const handWidth = Math.sqrt(
    Math.pow((wrist.x - indexBase.x) * handCanvas.width, 2) +
      Math.pow((wrist.y - indexBase.y) * handCanvas.height, 2)
  );

  // Scale line widths relative to hand width
  const fingerWidth = handWidth * 0.2; // Fingers about 15% of palm width
  const landmarkSize = handWidth * 0.04; // Landmarks about 5% of palm width

  // @ts-ignore
  const { drawLandmarks } = window;
  drawConnectors(handCtx, landmarks, HAND_CONNECTIONS, {
    color,
    lineWidth: fingerWidth,
  });
  drawLandmarks(handCtx, landmarks, {
    color,
    lineWidth: landmarkSize,
    radius: landmarkSize * 2,
  });

  // Draw palm polygon
  handCtx.beginPath();
  palmIndices.forEach((index, i) => {
    const landmark = landmarks[index];
    if (i === 0) {
      handCtx.moveTo(
        landmark.x * handCanvas.width,
        landmark.y * handCanvas.height
      );
    } else {
      handCtx.lineTo(
        landmark.x * handCanvas.width,
        landmark.y * handCanvas.height
      );
    }
  });
  handCtx.closePath();
  handCtx.fillStyle = color;
  handCtx.fill();
}
