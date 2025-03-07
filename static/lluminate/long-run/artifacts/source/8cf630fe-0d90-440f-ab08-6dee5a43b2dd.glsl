precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 glitchColor(vec2 p, float t) {
    float n = pseudoNoise(p * 50.0 + t);
    float r = pseudoNoise(p + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(p + vec2(0.0, t * 0.15));
    float b = pseudoNoise(p + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233)))*43758.5453);
}

void main(){
    // Centering and domain shifting for organic distortion
    vec2 centered = uv - 0.5;
    vec2 perturbedUV = centered + 0.1 * sin(10.0 * centered.yx + time);
    
    // Cosmic spiral creation with glitch overlay
    float angle = atan(perturbedUV.y, perturbedUV.x);
    float radius = length(perturbedUV);
    float spiral = sin(10.0 * radius - time * 4.0 + angle * 5.0);
    
    // Urban digital grid pattern
    vec2 grid = abs(fract(perturbedUV * 10.0) - 0.5);
    float gridLine = smoothstep(0.4, 0.42, min(grid.x, grid.y));
    
    // Combine spiral organic pattern with grid and add noise-based glitch elements
    float pattern = smoothstep(0.2, 0.3, radius + 0.1 * spiral) * (1.0 - gridLine);
    
    // Base background blended between cosmic and digital color range
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.2, 0.8, 1.0), radius);
    
    // Glitch overlay from previous noise functions
    vec3 glitch = glitchColor(perturbedUV * 2.0, time);
    
    // Additional non-uniform color mixing using noise perturbation
    float r = noise(perturbedUV * 15.0 + vec2(1.0, 2.0) * time);
    float g = noise(perturbedUV * 15.0 + vec2(3.0, 4.0) * time);
    float b = noise(perturbedUV * 15.0 + vec2(5.0, 6.0) * time);
    vec3 mixedColor = smoothstep(0.3, 0.7, vec3(r, g, b));
    
    // Synthesize colors together: cosmic base, digital glitch, and non-uniform noise mix
    vec3 color = mix(baseColor, glitch, 0.25) + mixedColor * 0.15;
    
    // Vignette effect for sculpting the final scene
    float vignette = smoothstep(0.7, 0.3, radius);
    color *= vignette * pattern;
    
    gl_FragColor = vec4(color, 1.0);
}