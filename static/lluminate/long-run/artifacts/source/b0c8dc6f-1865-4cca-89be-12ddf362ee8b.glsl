precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 n) {
  return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
  // Define the subject P = "ocean" with trait T = "fluidity",
  // and symbol S = "waterfall" (commonly representing cascading motion).
  // In this context, the inherent fluidity of the ocean replaces the waterfall,
  // imbuing the scene with organic, undulating motion essential to its nature.
  
  // Center UV coordinates
  vec2 p = uv - 0.5;
  
  // Introduce a subtle distortion to mimic fluid motion
  float wave1 = sin((p.x + time) * 10.0) * 0.03;
  float wave2 = cos((p.y + time * 0.5) * 8.0) * 0.03;
  p += vec2(wave1, wave2);
  
  // Rotate coordinates to enhance the sense of flow
  float angle = time * 0.2;
  float c = cos(angle);
  float s = sin(angle);
  p = mat2(c, -s, s, c) * p;
  
  // Convert to polar coordinates for swirling effect
  float r = length(p);
  float a = atan(p.y, p.x);
  
  // Create layered wave patterns to emulate the ocean's surface
  float oceanWave = sin(6.0 * a + time * 2.5) + cos(4.0 * a - time * 1.8);
  float rippleDetail = smoothstep(0.35, 0.0, r + 0.15 * oceanWave);
  
  // Add subtle randomness to simulate natural turbulence
  float noise = random(vec2(a, r + time));
  float turbulence = smoothstep(0.48, 0.5, noise);
  
  // Define a cool oceanic palette: deep blue blending into turquoise highlights
  vec3 deepOcean = vec3(0.0, 0.1, 0.3);
  vec3 shallowOcean = vec3(0.0, 0.5, 0.7);
  float mixFactor = smoothstep(0.0, 0.5, r + 0.2 * oceanWave);
  vec3 baseColor = mix(deepOcean, shallowOcean, mixFactor);
  
  // Enhance the scene with bursts of light that mimic sun glints on water
  vec3 glint = vec3(0.8, 0.9, 1.0) * turbulence;
  
  // Final composition blends the ocean's fluidity with dynamic light glints
  vec3 finalColor = baseColor * rippleDetail + glint;
  
  gl_FragColor = vec4(finalColor, 1.0);
}