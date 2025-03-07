precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float glitchNoise(vec2 p) {
    float n = noise(p * 10.0 + time);
    n = smoothstep(0.4, 0.6, n);
    return n;
}

float organicSpiral(vec2 p) {
    // Convert Cartesian to polar coordinates.
    float r = length(p);
    float a = atan(p.y, p.x);
    // Spiral distortion: twist the space.
    a += 2.0 * sin(time + r * 5.0);
    // Reconstruct coordinates.
    vec2 uv_spiral = vec2(r * cos(a), r * sin(a));
    // Return a pattern based on distance to a modulated sine wave.
    float pattern = abs(sin(uv_spiral.x * 10.0 + time) * cos(uv_spiral.y * 10.0 + time));
    return pattern;
}

void main() {
    // Step 1: draw_random_card
    // Directive: "Honor thy error as a hidden intention"
    // Step 2: interpret_directive:
    //   Introduce deliberate "errors" or glitches as an integral aesthetic.
    // Step 3: apply_insight:
    //   Blend organic swirling patterns with glitch artifacts.
    
    // Normalize uv to [-1,1] coordinates.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a subtle organic distortion to the coordinates.
    pos += 0.15 * vec2(sin(3.0 * pos.y + time), cos(3.0 * pos.x + time));
    
    // Generate an organic spiral pattern.
    float spiral = organicSpiral(pos);
    
    // Create a glitch effect based on noise.
    float glitch = glitchNoise(pos + vec2(time * 0.5));
    
    // Combine the patterns in an unconventional way, honoring error.
    float mixPattern = mix(spiral, glitch, 0.5 + 0.5 * sin(time));
    
    // Create a background gradient with instability.
    vec3 bgColor = vec3(0.05, 0.0, 0.1) + 0.2 * vec3(0.5 + 0.5 * sin(time + pos.x),
                                                     0.5 + 0.5 * cos(time + pos.y),
                                                     0.5 + 0.5 * sin(time - pos.x));
    
    // Color for the organic, glitchy pattern.
    vec3 patternColor = vec3(0.2, 0.6, 0.3) * mixPattern;
    
    // Add an extra layer of "hidden error" using random noise.
    float hiddenError = noise(pos * 15.0 + time*2.0);
    patternColor += 0.1 * vec3(hiddenError, hiddenError * 0.8, hiddenError * 1.2);
    
    // Final color is a blend of the unstable background and our pattern,
    // honoring the accidental beauty of glitches.
    vec3 color = mix(bgColor, patternColor, smoothstep(0.3, 0.7, mixPattern));
    
    gl_FragColor = vec4(color, 1.0);
}