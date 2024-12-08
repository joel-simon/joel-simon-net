import drawingUtils from '@mediapipe/drawing_utils';
const { drawConnectors, drawLandmarks } = drawingUtils;

import type { NormalizedLandmarkList } from '@mediapipe/hands';
import handsModule from '@mediapipe/hands';
const palmIndices = [0, 1, 2, 5, 9, 13, 17];

export function drawHand(
	handCtx: CanvasRenderingContext2D,
	landmarks: NormalizedLandmarkList,
	color: string = 'white'
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

	drawConnectors(handCtx, landmarks, handsModule.HAND_CONNECTIONS, {
		color,
		lineWidth: fingerWidth
	});
	drawLandmarks(handCtx, landmarks, {
		color,
		lineWidth: landmarkSize,
		radius: landmarkSize * 2
	});

	// Draw palm polygon
	handCtx.beginPath();
	palmIndices.forEach((index, i) => {
		const landmark = landmarks[index];
		if (i === 0) {
			handCtx.moveTo(landmark.x * handCanvas.width, landmark.y * handCanvas.height);
		} else {
			handCtx.lineTo(landmark.x * handCanvas.width, landmark.y * handCanvas.height);
		}
	});
	handCtx.closePath();
	handCtx.fillStyle = color;
	handCtx.fill();
}
