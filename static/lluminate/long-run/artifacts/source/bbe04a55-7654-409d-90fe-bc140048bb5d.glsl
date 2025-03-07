precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 n) {
  return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
  // draw_random_card: "Honor thy error as a hidden intention."
  // interpret_directive: Embrace intentional noise and glitches as part of the design.
  // apply_insight: Introduce controlled randomness and distortions in the pattern.

  // Center uv and add slight distortion
  vec2 p = uv - 0.5;
  
  // Introduce a subtle grid-based glitch overlay
  vec2 grid = fract(p * 10.0) - 0.5;
  float glitch = step(0.45, length(grid)) * 0.3; // slight darkening on grid edges

  // Apply a non-linear twist distortion that changes with time
  float angle = sin(time * 0.5 + length(p)*3.14) * 1.5;
  float c = cos(angle);
  float s = sin(angle);
  mat2 twist = mat2(c, -s, s, c);
  p = twist * p;

  // Convert to polar coordinates after distortion
  float r = length(p);
  float a = atan(p.y, p.x);

  // Create an organic, glitchy wave pattern based on polar coordinates
  float wave = sin(6.0 * a + time * 2.0) + cos(4.0 * a - time);
  float radialGlow = smoothstep(0.3, 0.0, r + 0.2 * wave);

  // Introduce randomness to mimic an "error" intentionally colored over the designed pattern
  float noise = rand(vec2(a, r + time));
  float errorMask = smoothstep(0.45, 0.5, noise);

  // Mix two contrasting colors using dynamic oscillations and add glitch overlays
  vec3 color1 = vec3(0.1, 0.4, 0.7);
  vec3 color2 = vec3(0.9, 0.3, 0.2);
  float mixFactor = smoothstep(0.0, 1.0, r + 0.25 * wave + glitch);
  vec3 baseColor = mix(color1, color2, mixFactor);

  // Blend with an unexpected burst of brightness from the noise glitch
  vec3 glitchColor = vec3(1.0, 1.0, 0.3) * errorMask;

  // Final color combines the organic distortion and intended "error"
  vec3 finalColor = baseColor * radialGlow + glitchColor;

  gl_FragColor = vec4(finalColor, 1.0);
}