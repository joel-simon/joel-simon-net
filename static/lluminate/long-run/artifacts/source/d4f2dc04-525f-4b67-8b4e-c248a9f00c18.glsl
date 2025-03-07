precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
  return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
  vec2 i = floor(st);
  vec2 f = fract(st);
  float a = rand(i);
  float b = rand(i + vec2(1.0, 0.0));
  float c = rand(i + vec2(0.0, 1.0));
  float d = rand(i + vec2(1.0, 1.0));
  vec2 u = f * f * (3.0 - 2.0 * f);
  return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
  // Map uv from [0,1] to [-1,1]
  vec2 pos = uv * 2.0 - 1.0;
  
  // Directive: "Honor thy error as a hidden intention."
  // Interpreting the directive: embrace mistakes as part of beauty.
  // We'll use random distortions and shifting color errors to add unexpected glitches.
  
  // Create a dynamic distortion based on radial distance and noise error
  float r = length(pos);
  float angle = atan(pos.y, pos.x);
  
  // Introduce an "error term" with noisy radial deviations
  float error = noise(pos * 5.0 + time) * 0.3;
  
  // Distort the angle and radius with error to break symmetry unpredictably
  float distortedAngle = angle + error;
  float distortedRadius = r + error * 0.5;
  
  // Create a swirling pattern from distorted polar coordinates
  float swirl = sin(10.0 * distortedRadius - time * 2.0 + distortedAngle * 3.0);
  
  // Use creative layering: Base gradient mixed with an unexpected glitch field
  vec3 baseColor = mix(vec3(0.05, 0.05, 0.1), vec3(0.2, 0.1, 0.3), distortedRadius);
  
  // Overlay color "errors" by splitting channels with subtle offsets
  float glitchStrength = noise(uv * 50.0 + time);
  vec3 redChannel   = baseColor.r * vec3(1.0, 0.3, 0.3) * (0.8 + glitchStrength * 0.2);
  vec3 greenChannel = baseColor.g * vec3(0.3, 1.0, 0.3) * (0.8 + glitchStrength * 0.2);
  vec3 blueChannel  = baseColor.b * vec3(0.3, 0.3, 1.0) * (0.8 + glitchStrength * 0.2);
  
  // Shift channels slightly using sinusoidal functions
  vec2 redOffset = vec2(sin(time * 1.3), cos(time * 1.1)) * 0.005;
  vec2 greenOffset = vec2(cos(time * 1.7), sin(time * 1.2)) * 0.005;
  vec2 blueOffset = vec2(sin(time * 1.5), cos(time * 1.4)) * 0.005;
  
  float redNoise = noise((uv + redOffset) * 20.0 + time);
  float greenNoise = noise((uv + greenOffset) * 20.0 + time);
  float blueNoise = noise((uv + blueOffset) * 20.0 + time);
  
  // Combine the channels with added swirling energy
  vec3 finalColor = vec3(
    redChannel.r + redNoise * swirl * 0.2,
    greenChannel.g + greenNoise * swirl * 0.2,
    blueChannel.b + blueNoise * swirl * 0.2
  );
  
  // Apply a radial fade-out to enhance focus on center errors
  float vignette = smoothstep(1.2, 0.5, distortedRadius);
  finalColor *= vignette;
  
  gl_FragColor = vec4(finalColor, 1.0);
}