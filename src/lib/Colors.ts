// export function hsvToRgb(h: number, s: number, v: number): string {
//   let r: number, g: number, b: number;
//   let i = Math.floor(h * 6);
//   let f = h * 6 - i;
//   let p = v * (1 - s);
//   let q = v * (1 - f * s);
//   let t = v * (1 - (1 - f) * s);

//   i = i % 6;

//   if (i === 0) {
//     [r, g, b] = [v, t, p];
//   } else if (i === 1) {
//     [r, g, b] = [q, v, p];
//   } else if (i === 2) {
//     [r, g, b] = [p, v, t];
//   } else if (i === 3) {
//     [r, g, b] = [p, q, v];
//   } else if (i === 4) {
//     [r, g, b] = [t, p, v];
//   } else if (i === 5) {
//     [r, g, b] = [v, p, q];
//   }

//   return `rgb(${r * 255}, ${g * 255}, ${b * 255})`;
// }
export function rgbToHsv(
  r: number,
  g: number,
  b: number
): [number, number, number] {
  const rNorm = r / 255;
  const gNorm = g / 255;
  const bNorm = b / 255;

  const max = Math.max(rNorm, gNorm, bNorm);
  const min = Math.min(rNorm, gNorm, bNorm);
  const delta = max - min;

  let h = 0;
  if (delta !== 0) {
    if (max === rNorm) {
      h = ((gNorm - bNorm) / delta) % 6;
    } else if (max === gNorm) {
      h = (bNorm - rNorm) / delta + 2;
    } else {
      h = (rNorm - gNorm) / delta + 4;
    }
    h *= 60;
    if (h < 0) h += 360;
  }

  const s = max === 0 ? 0 : delta / max;
  const v = max;

  return [h, s, v];
}

export function hsvToRgb(
  h: number,
  s: number,
  v: number
): [number, number, number] {
  const c = v * s;
  const x = c * (1 - Math.abs(((h / 60) % 2) - 1));
  const m = v - c;

  let r = 0,
    g = 0,
    b = 0;
  if (0 <= h && h < 60) {
    r = c;
    g = x;
    b = 0;
  } else if (60 <= h && h < 120) {
    r = x;
    g = c;
    b = 0;
  } else if (120 <= h && h < 180) {
    r = 0;
    g = c;
    b = x;
  } else if (180 <= h && h < 240) {
    r = 0;
    g = x;
    b = c;
  } else if (240 <= h && h < 300) {
    r = x;
    g = 0;
    b = c;
  } else {
    r = c;
    g = 0;
    b = x;
  }

  return [(r + m) * 255, (g + m) * 255, (b + m) * 255];
}

export function interpolateColor(
  color1: [number, number, number],
  color2: [number, number, number],
  factor: number
): [number, number, number] {
  const [h1, s1, v1] = color1;
  const [h2, s2, v2] = color2;

  const h = h1 + (h2 - h1) * factor;
  const s = s1 + (s2 - s1) * factor;
  const v = v1 + (v2 - v1) * factor;

  return [h, s, v];
}
