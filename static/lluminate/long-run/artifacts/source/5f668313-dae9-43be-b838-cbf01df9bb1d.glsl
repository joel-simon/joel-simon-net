precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(
    mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
    mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
    u.y
  );
}

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

// Reverse assumption: Instead of expanding organic growth, we contract and invert motion.
vec2 contract(vec2 p, float factor) {
  return p * (1.0 - factor);
}

// Invert the radial gradient: normally center is bright; here, center is dark.
float invertedRadial(vec2 p) {
  float r = length(p);
  return smoothstep(0.4, 0.0, r);
}

void main() {
  // remap uv from [0,1] to [-1,1] with a slight exaggeration.
  vec2 pos = uv * 2.0 - 1.0;
  pos *= 1.1;
  
  // Apply a time evolving contraction to simulate retraction.
  float contraction = 0.3 * sin(time * 2.0);
  vec2 contractedPos = contract(pos, contraction);
  
  // Use fractal noise to create an underlying texture that is inverted.
  float n = fbm(contractedPos * 3.0 - time * 0.5);
  n = 1.0 - n;
  
  // Create an inverted radial mask for contrast.
  float radialMask = invertedRadial(pos);
  
  // Generate glitch artifacts by slicing horizontal bands.
  float glitch = step(0.98, fract((uv.y + time * 0.7) * 25.0));
  
  // Digital cool color vs warm organic color blending reversed
  vec3 digitalColor = vec3(0.2, 0.5, 0.8);
  vec3 organicColor = vec3(0.9, 0.6, 0.3);
  
  float mixFactor = smoothstep(0.2, 0.7, n * radialMask);
  vec3 color = mix(digitalColor, organicColor, mixFactor);
  
  // Apply glitch effect by darkening horizontal glitch bands.
  color = mix(color, vec3(0.0), glitch * 0.4);
  
  // Introduce a subtle vertical band distortion reversing typical lateral glitch direction.
  float band = smoothstep(0.4, 0.0, abs(fract((uv.x - time * 0.3) * 15.0) - 0.5));
  color *= 1.0 - band * 0.15;
  
  gl_FragColor = vec4(color, 1.0);
}