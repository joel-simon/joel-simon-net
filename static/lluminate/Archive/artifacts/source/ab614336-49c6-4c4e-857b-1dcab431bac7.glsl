precision mediump float;
varying vec2 uv;
uniform float time;

float swirlPattern(vec2 p) {
  // Convert to polar coordinates with a twist that evolves over time
  float r = length(p);
  float a = atan(p.y, p.x);
  // Create a high-frequency spiral modulation
  float spiral = sin(8.0 * a + time*3.0) * cos(12.0 * r - time*2.0);
  return spiral;
}

float twistField(vec2 p) {
  // Add a swirling twist effect with radial decay
  float r = length(p);
  float a = atan(p.y, p.x);
  float twist = sin(a * 10.0 + time*2.0 + r * 15.0);
  return twist * exp(-r*3.0);
}

void main(){
  // Center uv around (0,0)
  vec2 p = uv - 0.5;
  
  // Scale space to enhance dynamics
  p *= 2.0;
  
  // Base radial fade
  float r = length(p);
  float radialFade = smoothstep(1.2, 0.0, r);
  
  // Calculate the swirling patterns
  float sw = swirlPattern(p);
  float tf = twistField(p);
  
  // Combine effects in a non-linear fashion
  float combined = mix(sw, tf, 0.5) + sin(r * 20.0 - time * 4.0);
  
  // Use fractal-like layering by adding scaled versions of combined pattern
  float layer1 = combined;
  float layer2 = 0.5 * sin(2.0 * (combined + time)) + 0.5;
  float layer3 = 0.25 * cos(4.0 * (combined - time*1.5)) + 0.5;
  float finalShape = (layer1 + layer2 + layer3) / 3.0;
  
  // Generate color channels with phase shifts
  vec3 col;
  col.r = sin(finalShape * 3.1415 + time) * 0.5 + 0.5;
  col.g = sin(finalShape * 3.1415 + time * 1.2) * 0.5 + 0.5;
  col.b = sin(finalShape * 3.1415 + time * 0.8) * 0.5 + 0.5;
  
  // Apply radial fade to soften edges and focus the center effect
  col *= radialFade;
  
  gl_FragColor = vec4(col, 1.0);
}