precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 glitchColor(vec2 pos, float t) {
    float n = pseudoNoise(pos * 50.0 + t);
    float r = pseudoNoise(pos + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(pos + vec2(0.0, t * 0.15));
    float b = pseudoNoise(pos + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

void main() {
    // Center UV coordinates to range [-0.5, 0.5] then scale to [-1, 1]
    vec2 centered = (uv - 0.5) * 2.0;
    
    // Compute polar coordinates
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    
    // Create swirling spiral pattern from polar coordinates
    float spiral = sin(10.0 * radius - time * 4.0 + angle * 5.0);
    
    // Generate a grid pattern reminiscent of structural order
    vec2 gridUV = fract(centered * 5.0) - 0.5;
    float gridLine = smoothstep(0.45, 0.48, length(gridUV));
    
    // Synthesize interference using sine waves and adds noise
    float interference = sin(10.0 * centered.x) * sin(10.0 * centered.y);
    float noise = pseudoNoise(centered * 5.0 + time * 0.2);
    float blendFactor = smoothstep(-0.2, 0.2, interference + noise * 0.5);
    
    // Base colors: a vivid cosmic hue and a calm, deep tone
    vec3 cosmicColor = mix(vec3(0.2,0.0,0.3), vec3(0.1,0.8,1.0), radius);
    vec3 calmColor = mix(vec3(0.9, 0.95, 1.0), vec3(0.2, 0.3, 0.5), blendFactor);
    
    // Mix using spiral and grid influence
    vec3 baseColor = mix(cosmicColor, calmColor, spiral * 0.5 + 0.5);
    baseColor = mix(baseColor, vec3(0.0), gridLine);
    
    // Inject glitch to transfer digital artifacts over organic pattern
    vec3 glitch = glitchColor(centered * 3.0, time);
    vec3 finalColor = mix(baseColor, glitch, 0.3);
    
    // Apply a vignette for depth
    float vignette = smoothstep(0.8, 0.3, radius);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}