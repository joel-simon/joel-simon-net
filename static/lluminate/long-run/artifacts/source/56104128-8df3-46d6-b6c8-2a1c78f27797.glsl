precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
             mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
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

vec2 reverseDisplacement(vec2 p, float seed) {
  // Reverse assumption: Instead of adding growth and distortion, aggressively retract.
  float t = time * 0.75 + seed;
  float displacement = (noise(p * 10.0 + t) - 0.5) * 0.25;
  return p - vec2(displacement, displacement);
}

float invertedRadial(vec2 p) {
  // Invert typical radial gradient: outer becomes bright, center dark.
  float r = length(p);
  return smoothstep(0.5, 0.0, r);
}

void main() {
  // Map uv from [0,1] to [-1,1] and exaggerate to promote non-central effects
  vec2 pos = uv * 2.0 - 1.0;
  pos *= 1.2;
  
  // Apply reverse displacement: contracting rather than expanding.
  vec2 dp = reverseDisplacement(pos, 2.34);
  
  // Generate an inverted fractal noise pattern
  float fractal = fbm(dp * 2.0);
  // Reverse expectation: use inverted radial gradient where center is dim.
  float radial = invertedRadial(pos);
  
  // Blend two contrasting color palettes: a digital cold tone vs an organic deep tone.
  vec3 digital = vec3(0.1, 0.4, 0.7);
  vec3 organic = vec3(0.8, 0.5, 0.2);
  
  // Use the fractal pattern to decide a blend, and modulate with radial inversion.
  float blendFactor = smoothstep(0.3, 0.7, fractal * radial);
  vec3 color = mix(digital, organic, blendFactor);
  
  // Introduce a time-based glitch that subtracts structure along horizontal bands.
  float glitch = step(0.95, fract(uv.y * 20.0 - time * 0.5));
  color = mix(color, vec3(0.0), glitch * 0.5);
  
  gl_FragColor = vec4(color, 1.0);
}