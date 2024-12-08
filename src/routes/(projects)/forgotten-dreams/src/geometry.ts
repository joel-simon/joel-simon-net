/**
 * Smooths a polygon by adding intermediate points between vertices
 * @param polygon Array of points [x,y] representing the polygon vertices
 * @param iterations Number of smoothing iterations (default: 1)
 * @param tension Controls how tight the smoothing is (0-1, default: 0.5)
 * @returns Smoothed polygon as array of points
 */
export function smoothPolygon(
	polygon: number[][],
	iterations: number = 1,
	tension: number = 0.5
): number[][] {
	if (polygon.length < 3) return polygon;

	let result = [...polygon];

	for (let iter = 0; iter < iterations; iter++) {
		const smoothed: number[][] = [];
		const len = result.length;

		// Process each edge to create two new points
		for (let i = 0; i < len; i++) {
			const curr = result[i];
			const next = result[(i + 1) % len];

			// Create two new points that divide the edge according to tension
			const p1x = curr[0] * (1 - tension) + next[0] * tension;
			const p1y = curr[1] * (1 - tension) + next[1] * tension;
			const p2x = curr[0] * tension + next[0] * (1 - tension);
			const p2y = curr[1] * tension + next[1] * (1 - tension);

			smoothed.push([p1x, p1y], [p2x, p2y]);
		}

		result = smoothed;
	}

	return result;
}
