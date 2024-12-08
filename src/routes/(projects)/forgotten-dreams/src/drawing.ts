type Point = number[];
// Helper function for calculating Catmull-Rom spline points
function getCatmullRomPoints(p0: Point, p1: Point, p2: Point, p3: Point, t: number = 0.5): Point[] {
	const alpha = 0.5; // Centripetal Catmull-Rom specific

	function getT(t: number, p1: Point, p2: Point): number {
		const dx = p2[0] - p1[0];
		const dy = p2[1] - p1[1];
		const d = Math.pow(Math.pow(dx, 2) + Math.pow(dy, 2), alpha * 0.5);
		return d + t;
	}

	const t0 = 0;
	const t1 = getT(t0, p0, p1);
	const t2 = getT(t1, p1, p2);
	const t3 = getT(t2, p2, p3);

	const segments = 10; // Number of points to generate for each segment
	const points: Point[] = [];

	for (let i = 0; i <= segments; i++) {
		const t = t1 + (i / segments) * (t2 - t1);

		const a1 = [
			(p0[0] * (t1 - t)) / (t1 - t0) + (p1[0] * (t - t0)) / (t1 - t0),
			(p0[1] * (t1 - t)) / (t1 - t0) + (p1[1] * (t - t0)) / (t1 - t0)
		];
		const a2 = [
			(p1[0] * (t2 - t)) / (t2 - t1) + (p2[0] * (t - t1)) / (t2 - t1),
			(p1[1] * (t2 - t)) / (t2 - t1) + (p2[1] * (t - t1)) / (t2 - t1)
		];
		const a3 = [
			(p2[0] * (t3 - t)) / (t3 - t2) + (p3[0] * (t - t2)) / (t3 - t2),
			(p2[1] * (t3 - t)) / (t3 - t2) + (p3[1] * (t - t2)) / (t3 - t2)
		];

		const b1 = [
			(a1[0] * (t2 - t)) / (t2 - t0) + (a2[0] * (t - t0)) / (t2 - t0),
			(a1[1] * (t2 - t)) / (t2 - t0) + (a2[1] * (t - t0)) / (t2 - t0)
		];
		const b2 = [
			(a2[0] * (t3 - t)) / (t3 - t1) + (a3[0] * (t - t1)) / (t3 - t1),
			(a2[1] * (t3 - t)) / (t3 - t1) + (a3[1] * (t - t1)) / (t3 - t1)
		];

		const c = [
			(b1[0] * (t2 - t)) / (t2 - t1) + (b2[0] * (t - t1)) / (t2 - t1),
			(b1[1] * (t2 - t)) / (t2 - t1) + (b2[1] * (t - t1)) / (t2 - t1)
		];

		points.push(c as Point);
	}

	return points;
}

export function drawSmoothPolygon(ctx: CanvasRenderingContext2D, points: number[][]) {
	if (points.length < 3) return;

	// Create a closed loop by adding points from the end and beginning
	const allPoints = [...points.slice(-2), ...points, ...points.slice(0, 2)];

	// Start the path
	ctx.beginPath();
	ctx.moveTo(points[0][0], points[0][1]);

	// Generate and draw smooth curve through all points
	for (let i = 0; i < points.length; i++) {
		const curvePoints = getCatmullRomPoints(
			allPoints[i],
			allPoints[i + 1],
			allPoints[i + 2],
			allPoints[i + 3]
		);

		for (const point of curvePoints) {
			ctx.lineTo(point[0], point[1]);
		}
	}

	ctx.closePath();
}
