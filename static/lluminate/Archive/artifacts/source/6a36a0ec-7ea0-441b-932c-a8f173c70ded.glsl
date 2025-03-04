precision mediump float;
varying vec2 uv;
uniform float time;

float pattern(vec2 p, float scale) {
  p *= scale;
  float angle = atan(p.y, p.x);
  float radius = length(p);
  float sn = sin(angle * 6.0 + time*2.0) * cos(radius * 10.0 - time*3.0);
  return sn;
}

void main(){
  vec2 p = uv - 0.5;
  float r = length(p);
  float angle = atan(p.y, p.x);
  
  // Create twisting layers via sinusoidal modulation
  float spiral = sin(r * 20.0 - time * 5.0 + angle * 4.0);
  float star = smoothstep(0.15, 0.0, abs(sin(angle * 10.0 - time*3.0) * cos(r * 30.0)));
  
  // Combine with an evolving pattern function
  float evolving = pattern(p, 3.0);
  
  // Mix various effects
  float mixVal = mix(spiral, evolving, 0.5) + star;
  
  // Derive color channels with different phases
  vec3 col;
  col.r = sin(mixVal + time) * 0.5 + 0.5;
  col.g = cos(mixVal + time*1.2) * 0.5 + 0.5;
  col.b = sin(mixVal + time*0.8) * 0.5 + 0.5;
  
  // Apply a radial fade for softness near the edges
  float fade = smoothstep(0.5, 0.3, r);
  col *= fade;
  
  gl_FragColor = vec4(col,1.0);
}