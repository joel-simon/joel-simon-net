precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
  return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
  // list_assumptions: In many shaders, the coordinate origin is considered at the lower-left or center.
  // select_assumption: The idea that the origin is at a fixed location.
  // reverse_assumption: Assume the origin moves and is randomized with time.
  // explore_consequences: Use a moving origin to warp our scene in an unexpected manner.
  
  // Compute a moving origin based on time and noise
  vec2 movingOrigin = vec2(0.5 + 0.3 * sin(time * 1.3), 0.5 + 0.3 * cos(time * 1.7));
  
  // Use the difference between uv and the moving origin,
  // but reverse the distance effect: closer points get a larger offset.
  vec2 diff = uv - movingOrigin;
  float dist = length(diff);
  float invDist = 1.0 - clamp(dist, 0.0, 1.0);
  
  // Rotate coordinates in an unexpected non-linear way
  float angle = atan(diff.y, diff.x);
  float modAngle = angle + invDist * 6.2831 * sin(time + pseudoNoise(uv * 10.0));
  vec2 warped = vec2(cos(modAngle), sin(modAngle)) * invDist;
  
  // Create a glitchy grid pattern using the moving origin and warped coordinates
  vec2 grid = fract((uv + warped + time * 0.1) * 10.0);
  float gridPattern = smoothstep(0.4, 0.5, abs(grid.x - 0.5)) * smoothstep(0.4, 0.5, abs(grid.y - 0.5));
  
  // Generate a clash of colors using unexpected blend of neon and pastel themes.
  vec3 colorA = vec3(0.05, 0.95, 0.75);
  vec3 colorB = vec3(0.95, 0.3, 0.25);
  float mixValue = smoothstep(0.3, 0.7, invDist) * (0.5 + 0.5 * sin(time * 3.0));
  vec3 baseColor = mix(colorA, colorB, mixValue);
  
  // Overlay a random glitch effect based on noise
  float glitch = pseudoNoise(uv * 15.0 + time * 2.0);
  vec3 glitchColor = vec3(glitch * 0.8, glitch * 0.4, -glitch * 0.2);
  
  // Final color composition with grid pattern acting as a mask for glitch artifacts
  vec3 finalColor = mix(baseColor, baseColor + glitchColor, gridPattern * 0.5);
  
  // Modulate brightness with inverted distance map to emphasize borders near the moving origin.
  float brightness = smoothstep(0.0, 1.0, invDist + glitch * 0.2);
  
  gl_FragColor = vec4(finalColor * brightness, 1.0);
}