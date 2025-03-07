precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Bioluminescent kernel: creates organic, glowing cloud effects
float bioluminescent(vec2 p, float t) {
    float d = length(p);
    float glow = exp(-10.0 * d * d);
    float pulse = sin(t*3.0 - d*20.0);
    return glow * pulse;
}

// Digital grid distortion: introduces rigid, digital artifacts
float gridDistortion(vec2 p, float t) {
    vec2 grid = abs(fract(p * 12.0 - 0.5) - 0.5);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y));
    // Shift grid lines over time for glitch effect
    line *= step(0.7, pseudoNoise(p + t));
    return line;
}

// Synthesizes organic glow with digital noise
vec3 synthesizeScene(vec2 p, float t) {
    // Domain 1: Bioluminescent forest vibe (organic glowing clouds)
    float bio = bioluminescent(p, t);
    // Domain 2: Rigid urban digital grid (structured disturbance)
    float grid = gridDistortion(p, t);
    
    // Synthesize: Blend the bioluminescence and grid distortion unconventionally
    float synth = mix(bio, grid, 0.35);
    
    // Color mapping: Organic greens and blues for nature with neon reddish glitches
    vec3 organicColor = vec3(0.0, 0.6, 0.4) * bio;
    vec3 digitalColor = vec3(0.8, 0.2, 0.1) * grid;
    return mix(organicColor, digitalColor, 0.5 + 0.5 * sin(t*1.7));
}

void main() {
    // Normalize and center coordinate space
    vec2 centered = (uv - 0.5) * 2.0;
    
    // Apply a swirling distortion for an alien perspective
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    float swirl = sin(radius * 10.0 - time*3.0 + angle * 4.0);
    vec2 distorted = centered + vec2(cos(angle), sin(angle)) * swirl * 0.1;
    
    // Include an additional layer of digital noise artifact
    float noise = pseudoNoise(distorted * 15.0 + time);
    vec3 scene = synthesizeScene(distorted, time);
    
    // Composite with additional noise modulation for extra interruption
    vec3 color = scene + vec3(noise * 0.15);
    
    // Create a vignette effect
    float vignette = smoothstep(1.0, 0.4, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}