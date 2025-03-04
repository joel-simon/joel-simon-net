precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
  return sin(p.x) * cos(p.y);
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
  return a + b * cos(6.28318 * (c * t + d));
}

float fractalSwirl(vec2 p) {
  float value = 0.0;
  float amplitude = 0.5;
  float frequency = 1.0;
  for (int i = 0; i < 6; i++) {
    vec2 pos = p * frequency + vec2(sin(time + float(i)), cos(time + float(i)));
    value += amplitude * sin(10.0 * length(pos) - time * frequency);
    frequency *= 1.8;
    amplitude *= 0.6;
  }
  return value;
}

float warpField(vec2 p) {
  float r = length(p);
  float a = atan(p.y, p.x);
  float warp = sin(8.0 * a + time * 2.5) * cos(12.0 * r - time * 3.0);
  return warp;
}

void main(){
  vec2 p = (uv - 0.5) * 2.0;
  float r = length(p);

  float swirl = fractalSwirl(p + warpField(p));
  float warp = warpField(p * (1.0 + 0.5 * sin(time)));

  float combined = swirl + warp;
  
  float edge = smoothstep(1.2, 0.4, r);
  float ripple = sin((r * 30.0) - time * 5.0);
  
  float intensity = combined * 0.5 + ripple * 0.5;
  intensity = clamp(intensity, -1.0, 1.0) * 0.5 + 0.5;

  vec3 color = palette(intensity, vec3(0.5), vec3(0.5), vec3(1.0, 0.8, 0.6), vec3(0.1, 0.2, 0.3));
  color *= edge;
  
  gl_FragColor = vec4(color, 1.0);
}