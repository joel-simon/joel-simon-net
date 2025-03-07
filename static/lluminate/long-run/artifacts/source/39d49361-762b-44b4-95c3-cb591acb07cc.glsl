precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 deliberateGlitch(vec2 p, float t) {
    // "Honor thy error as a hidden intention"
    // Introduce deliberate misalignment in color channels.
    float shift = sin(t * 3.1415) * 0.01;
    float r = pseudoNoise(p + vec2(shift, 0.0));
    float g = pseudoNoise(p + vec2(0.0, shift));
    float b = pseudoNoise(p + vec2(-shift, shift));
    return vec3(r, g, b);
}

void main() {
    // Remap uv to centered coordinates
    vec2 centered = uv - 0.5;
    
    // Apply non-linear distortion: "Use an old idea" but with twist
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    
    // Create an unexpected radial wave pattern, as if mistakes ripple outwards
    float wave = sin(12.0 * radius - time * 3.0 + 5.0 * angle);
    
    // Blend color schemes: a calm base disrupted by stray, misaligned digital artifacts.
    vec3 baseColor = mix(vec3(0.2, 0.05, 0.3), vec3(0.1, 0.6, 0.8), radius + 0.2 * wave);
    
    // Introduce a mistake: scattered glitched triangles built from noise offset
    float noiseVal = pseudoNoise(centered * 10.0 + time);
    float glitchMask = smoothstep(0.92, 0.98, noiseVal);
    
    vec3 glitchArt = deliberateGlitch(centered * 5.0, time);
    
    // Mix the base color with the glitch art using paradoxical overlay that respects error
    vec3 finalColor = mix(baseColor, glitchArt, glitchMask * 0.75);
    
    // Apply soft vignette to focus center, offset with a twist of error
    float vignette = smoothstep(0.7, 0.3, radius + 0.1 * sin(time + radius * 10.0));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}