precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;
const int ITERATIONS = 10;

float hash(float n) {
  return fract(sin(n) * 43758.5453);
}

float noise(vec2 x) {
  vec2 p = floor(x);
  vec2 f = fract(x);
  f = f * f * (3.0 - 2.0 * f);
  float n = p.x + p.y * 57.0;
  return mix(mix(hash(n + 0.0), hash(n + 1.0), f.x),
             mix(hash(n + 57.0), hash(n + 58.0), f.x), f.y);
}

vec2 rotate(vec2 p, float a) {
  float s = sin(a);
  float c = cos(a);
  return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

float kaleidoSpiral(vec2 p) {
  float accum = 0.0;
  float scale = 1.0;
  for (int i = 0; i < ITERATIONS; i++) {
    // Apply mirrored kaleidoscopic fold
    p = abs(p);
    // Rotate based on angle modulated by time and noise
    float angle = atan(p.y, p.x) + time + noise(p * 3.0) * PI;
    float radius = length(p);
    p = rotate(p, angle * 0.5);
    // Distort scale nonlinearly
    accum += sin(radius * 10.0 - time * 2.0) / scale;
    p *= 1.5;
    scale *= 1.3;
  }
  return accum;
}

void main(){
  // Transform uv to centered coordinates and add zoom-like effect.
  vec2 pos = (uv - 0.5) * 2.0;
  
  // Introduce a pulsating perspective distortion.
  float pulse = sin(time * 0.8) * 0.3 + 1.0;
  pos *= pulse;
  
  // Create a radial kaleidoscopic twist.
  float angle = atan(pos.y, pos.x);
  float radius = length(pos);
  // Modulate angle with a multiple-fold mirror effect
  float sectors = 6.0;
  angle = mod(angle, (2.0 * PI / sectors)) - (PI / sectors);
  pos = vec2(cos(angle), sin(angle)) * radius;
  
  // Apply an intricate fractal spiral distortion.
  float spiral = kaleidoSpiral(pos);
  spiral = sin(spiral * PI);
  
  // Dynamic color palette based on spiral and UV coordinates.
  vec3 colA = vec3(0.2, 0.5, 0.9);
  vec3 colB = vec3(0.9, 0.4, 0.2);
  vec3 colC = vec3(0.1, 0.8, 0.6);
  
  float mixFactor = smoothstep(-1.0, 1.0, spiral);
  vec3 color = mix(colA, colB, mixFactor);
  color = mix(color, colC, smoothstep(0.1, 0.7, radius + 0.3 * sin(time)));
  
  // Apply a dynamic vignette that pulses with time.
  float vig = smoothstep(0.8 + 0.15*sin(time*1.5), 0.0, radius);
  color *= vig;
  
  gl_FragColor = vec4(color, 1.0);
}