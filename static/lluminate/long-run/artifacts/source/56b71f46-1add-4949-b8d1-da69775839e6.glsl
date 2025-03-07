precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 n) {
  return fract(sin(dot(n, vec2(41.0, 289.0))) * 12345.6789);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = rand(i);
  float b = rand(i + vec2(1.0, 0.0));
  float c = rand(i + vec2(0.0, 1.0));
  float d = rand(i + vec2(1.0, 1.0));
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
  // Reverse the assumption that precision and clarity is ideal:
  // Introducing intentional chaos and blurred boundaries.
  
  // Start with shifting uv so that origin is at the center.
  vec2 p = uv - 0.5;
  
  // Convert coordinates to polar space.
  float angle = atan(p.y, p.x);
  float radius = length(p);
  
  // Create swirling spiral bands by combining polar angle with time.
  float spiral = sin(8.0 * angle + time * 1.5) * 0.5 + 0.5;
  
  // Instead of clean, distinct bands, we intentionally blur the boundaries:
  float rings = smoothstep(0.2, 0.25, abs(sin(10.0 * radius - time)));
  
  // Introduce an overlay of organic noise that modulates the spiral.
  float n = noise(p * 12.0 + time);
  
  // Reverse color gradient: dark center expanding to bright outer glow with unexpected gaps.
  vec3 dark = vec3(0.05, 0.05, 0.1);
  vec3 bright = vec3(0.9, 0.7, 0.3);
  float mixVal = smoothstep(0.1, 0.5, radius + n * 0.3);
  vec3 colorMix = mix(dark, bright, mixVal);
  
  // Blend the spiral pattern and rings with a chaotic interpolation.
  float pattern = mix(spiral, rings, 0.5 + 0.5 * sin(time + radius * 10.0));
  
  // Modulate the final color with the inverted pattern for a broken visual order.
  vec3 finalColor = mix(colorMix, vec3(0.8, 0.2, 0.5), pattern * n);
  
  gl_FragColor = vec4(finalColor, 1.0);
}