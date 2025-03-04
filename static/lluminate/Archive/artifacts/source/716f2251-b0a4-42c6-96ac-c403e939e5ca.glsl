precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
  return fract(sin(n)*43758.5453123);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = hash(i.x + i.y * 57.0);
  float b = hash(i.x + 1.0 + i.y * 57.0);
  float c = hash(i.x + (i.y+1.0) * 57.0);
  float d = hash(i.x + 1.0 + (i.y+1.0) * 57.0);
  vec2 u = f*f*(3.0-2.0*f);
  return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 palette( float t, vec3 a, vec3 b, vec3 c, vec3 d ) {
  return a + b * cos(6.28318 * (c * t + d));
}

float fractalSwirl(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for (int i = 0; i < 7; i++) {
    vec2 pos = p * frequency + vec2(sin(time + float(i) * 1.1), cos(time + float(i) * 1.3));
    value += amplitude * sin(10.0 * length(pos) - time * frequency);
    frequency *= 1.7;
    amplitude *= 0.65;
  }
  return value;
}

float warpField(vec2 p) {
  float r = length(p);
  float a = atan(p.y, p.x);
  float warp = sin(8.0 * a + time * 2.7) * cos(12.0 * r - time * 3.3);
  return warp;
}

float dynamicNoise(vec2 p) {
  float n = noise(p * 3.0 + time);
  n += noise(p * 6.0 - time * 0.5)*0.5;
  return n;
}

void main(){
  vec2 p = (uv - 0.5) * 2.0;
  float r = length(p);

  float swirl = fractalSwirl(p + warpField(p));
  float warp = warpField(p * (1.0 + 0.3 * sin(time * 1.2)));
  float n = dynamicNoise(p + vec2(sin(time), cos(time)));

  float combined = swirl + warp + n*0.3;
  
  float ripple = sin((r * 25.0) - time * 4.0);
  float intensity = combined * 0.4 + ripple * 0.6;
  intensity = clamp(intensity, -1.0, 1.0) * 0.5 + 0.5;

  vec3 color = palette(intensity, vec3(0.3,0.2,0.4), vec3(0.4,0.5,0.6), vec3(1.0,0.9,0.7), vec3(0.2,0.3,0.1));
  
  float vignette = smoothstep(0.9, 0.3, r);
  color *= vignette;
  
  gl_FragColor = vec4(color, 1.0);
}