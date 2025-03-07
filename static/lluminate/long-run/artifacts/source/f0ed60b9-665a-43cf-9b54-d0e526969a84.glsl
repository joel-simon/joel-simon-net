precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 glitchColor(vec2 uv, float t) {
    // Mimic digital glitches with horizontal color splits and static noise.
    float n = pseudoNoise(uv * 50.0 + t);
    vec3 col;
    // Offset for color channels
    float r = pseudoNoise(uv + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(uv + vec2(0.0, t * 0.15));
    float b = pseudoNoise(uv + vec2(-t * 0.1, t * 0.05));
    col = vec3(r, g, b);
    // Introduce sporadic bright glitches
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0, 1.0, 1.0), glitch);
}

void main() {
    // Remap uv to centered coordinates
    vec2 centered = uv - 0.5;
    
    // Domain fusion: Cosmic nebula meets urban glitch.
    // Create a spiral pattern reminiscent of a galaxy and infuse it with urban digital static.
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    
    // Create a swirling spiral using time and angle
    float spiral = sin(10.0 * radius - time * 4.0 + angle * 5.0);
    
    // Generate a grid pattern to symbolize urban architecture
    vec2 grid = abs(fract(centered * 10.0) - 0.5);
    float gridLine = smoothstep(0.4, 0.42, min(grid.x, grid.y));
    
    // Combine the spiral and grid with creative modulation:
    float pattern = smoothstep(0.2, 0.3, radius + 0.1 * spiral) * (1.0 - gridLine);
    
    // Use glitch effects to add unexpected digital artifacts
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.2, 0.8, 1.0), radius);
    vec3 glitch = glitchColor(centered * 2.0, time);
    
    vec3 color = mix(baseColor, glitch, 0.25);
    
    // Darken edges for vignette effect
    float vignette = smoothstep(0.7, 0.3, radius);
    color *= vignette * pattern;
    
    gl_FragColor = vec4(color, 1.0);
}