precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random noise
float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
             mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  for (int i = 0; i < 5; i++) {
    value += amplitude * noise(p);
    p *= 2.0;
    amplitude *= 0.5;
  }
  return value;
}

void main(void) {
  // Remap uv to range [-1, 1]
  vec2 pos = uv * 2.0 - 1.0;
  
  // Concept 1: Cellular/Fractal texture using fbm noise
  float cellFactor = fbm(pos * 3.0 + time * 0.3);
  
  // Concept 2: A swirling vector field from polar coordinates
  float radius = length(pos);
  float angle = atan(pos.y, pos.x);
  float swirl = sin(angle * 4.0 + time) * 0.5;
  vec2 swirlPos = vec2(cos(angle + swirl), sin(angle + swirl)) * radius;
  
  // Map cross-space: correlate fractal texture with swirl effect
  float field = fbm(swirlPos * 4.0 - time * 0.5);
  
  // Blend selectively: mix the two conceptual spaces non-linearly
  float blendMix = mix(cellFactor, field, smoothstep(0.2, 0.8, cellFactor));
  
  // Develop emergent structure: create banding and emergent contours
  float bands = smoothstep(0.3, 0.31, abs(sin(10.0 * blendMix + time)));
  
  // Color mapping: use two contrasting color spaces
  vec3 colorSpace1 = vec3(0.1, 0.8, 0.6);
  vec3 colorSpace2 = vec3(0.8, 0.2, 0.4);
  
  // Dynamic blend based on emergent noise and swirl modulation
  vec3 emergentColor = mix(colorSpace1, colorSpace2, blendMix);
  
  // Add emergent band contours and digital glitchy artifacts from noise
  float glitch = noise(uv * 20.0 + time) * 0.15;
  emergentColor += bands * 0.3 + glitch;
  
  // Final color composition with smooth radial fade
  float fade = smoothstep(1.0, 0.0, radius);
  vec3 finalColor = mix(vec3(0.05,0.05,0.1), emergentColor, fade);
  
  gl_FragColor = vec4(finalColor, 1.0);
}