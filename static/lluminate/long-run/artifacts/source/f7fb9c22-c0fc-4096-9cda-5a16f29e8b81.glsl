precision mediump float;
varying vec2 uv;
uniform float time;

float cosmicSpiral(vec2 p, float scale, float twist) {
  vec2 pos = p - 0.5;
  float r = length(pos) * scale;
  float angle = atan(pos.y, pos.x) + twist * log(r + 1.0);
  float spiral = sin(angle * 6.0 + time * 2.0);
  return smoothstep(0.02, 0.0, abs(spiral) - (0.5 - r));
}

float glitchStripes(vec2 p, float speed) {
  float stripes = step(0.5, fract(p.y * 20.0 + time * speed));
  // Introduce a noisy glitch factor that distorts the stripes
  float glitch = sin((p.x + p.y) * 50.0 + time * 10.0);
  return mix(stripes, 1.0 - stripes, smoothstep(-0.3, 0.3, glitch));
}

void main() {
  // Blend two conceptual spaces: cosmic spiral and digital glitch.
  vec2 p = uv;
  
  // Generate an emergent cosmic structure with swirling spiral arms.
  float spiral = cosmicSpiral(p, 3.0, 1.5);
  
  // Generate glitch stripes overlaying the cosmic pattern.
  float glitch = glitchStripes(p, 2.0);
  
  // Blend the two results; the glitch selectively disrupts the spiral, creating emergent features.
  float mask = mix(spiral, glitch, 0.5 + 0.5 * sin(time + p.x * 10.0));
  
  // Create a dynamic background that shifts between dark cosmos and neon glitch highlights.
  vec3 cosmicColor = mix(vec3(0.05, 0.0, 0.1), vec3(0.3, 0.0, 0.5), spiral);
  vec3 glitchColor = mix(vec3(0.0, 0.5, 0.7), vec3(0.8, 0.2, 0.2), glitch);
  
  // Merge colors based on the emergent mask.
  vec3 finalColor = mix(cosmicColor, glitchColor, mask);
    
  gl_FragColor = vec4(finalColor, 1.0);
}