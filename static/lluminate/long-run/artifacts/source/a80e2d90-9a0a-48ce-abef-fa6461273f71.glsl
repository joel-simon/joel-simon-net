precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random number generator based on coordinates
float rand(vec2 n) {
  return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = rand(i);
  float b = rand(i + vec2(1.0, 0.0));
  float c = rand(i + vec2(0.0, 1.0));
  float d = rand(i + vec2(1.0, 1.0));
  vec2 u = f*f*(3.0-2.0*f);
  return mix(a, b, u.x) +
         (c - a)* u.y * (1.0 - u.x) +
         (d - b) * u.x * u.y;
}

// Generate a fractal structure using multiple octaves of noise
float fractal(vec2 p) {
  float total = 0.0;
  float amplitude = 1.0;
  for (int i = 0; i < 5; i++) {
    total += noise(p) * amplitude;
    p *= 2.0;
    amplitude *= 0.5;
  }
  return total;
}

void main() {
  // Map uv coordinates into a centered space merging two conceptual spaces:
  // a highly structured grid and an organic fractal field.
  vec2 p = (uv - 0.5) * 2.0;
  
  // Conceptual space 1: Structured grid pattern.
  vec2 grid = fract(p * 8.0) - 0.5;
  float gridStrength = smoothstep(0.48, 0.5, length(grid));
  
  // Conceptual space 2: Organic fractal noise field.
  float fr = fractal(p * 3.0 + time * 0.5);
  
  // Map cross-space: blend grid structure and fractal noise.
  float blend = mix(fr, gridStrength, 0.5);
  
  // Introduce dynamic transformation with time.
  float angle = time + length(p) * 3.1416;
  float c = cos(angle);
  float s = sin(angle);
  vec2 rotated = vec2(p.x * c - p.y * s, p.x * s + p.y * c);
  
  // Additional organic ripple effect using radial sine waves.
  float ripple = sin(10.0 * length(rotated) - time * 3.0);
  float emergent = blend + ripple * 0.2;
  
  // Map emergent pattern to a color mix; merging two different color schemes.
  vec3 structuredColor = vec3(0.2, 0.6, 0.8); // cool tone for the grid structure
  vec3 organicColor = vec3(0.9, 0.5, 0.3);    // warm tone for fractal organic field
  vec3 mixedColor = mix(structuredColor, organicColor, emergent);
  
  // Adding a gentle vignette to focus the design.
  float vignette = smoothstep(1.0, 0.3, length(uv - 0.5));
  vec3 finalColor = mixedColor * vignette;
  
  gl_FragColor = vec4(finalColor, 1.0);
}