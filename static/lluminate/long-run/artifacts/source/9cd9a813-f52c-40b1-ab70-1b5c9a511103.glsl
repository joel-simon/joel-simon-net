precision mediump float;
varying vec2 uv;
uniform float time;

// Simple noise function based on sine
float noise(vec2 p) {
  return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Smooth noise
float smoothNoise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  float a = noise(i);
  float b = noise(i + vec2(1.0, 0.0));
  float c = noise(i + vec2(0.0, 1.0));
  float d = noise(i + vec2(1.0, 1.0));
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
  // Anchor concept: organic swirling core
  // Medium-distance association: fractal bio-organic growth with subtle digital glitches
  
  // Transform uv to centered coordinates and add a subtle wave motion
  vec2 pos = uv * 2.0 - 1.0;
  pos += 0.05 * vec2(sin(time + pos.y * 3.0), cos(time + pos.x * 3.0));
  
  // Convert to polar coordinates
  float r = length(pos);
  float theta = atan(pos.y, pos.x);
  
  // Introduce a fractal iteration effect for organic growth
  float fractal = 0.0;
  float scale = 1.0;
  for (int i = 0; i < 4; i++) {
    vec2 p = vec2(r * cos(theta), r * sin(theta)) * scale;
    fractal += smoothNoise(p + time);
    scale *= 0.5;
  }
  
  // Create a medium association with a hint of digital glitch using noise
  float glitch = smoothNoise(pos * 10.0 + time * 2.0);
  
  // Combine swirling pattern with fractal organic texture and glitch modulation
  float pattern = sin(6.0 * theta + fractal * 2.0 + time) + 0.5 * sin(12.0 * r - time * 1.2);
  pattern += glitch * 0.3;
  
  // Build a vibrant color from the pattern; slightly non-linear mixing for organic feel
  vec3 color;
  color.r = mix(0.2, 1.0, 0.5 + 0.5 * sin(pattern + time));
  color.g = mix(0.1, 0.9, 0.5 + 0.5 * cos(pattern - time * 0.8));
  color.b = mix(0.3, 0.8, 0.5 + 0.5 * sin(pattern * 1.3 + time * 0.6));
  
  // Vignette that evolves organically with added glitchy noise at the edges
  float vignette = smoothstep(0.8, 0.4, r + glitch * 0.2);
  color *= vignette;
  
  gl_FragColor = vec4(color, 1.0);
}