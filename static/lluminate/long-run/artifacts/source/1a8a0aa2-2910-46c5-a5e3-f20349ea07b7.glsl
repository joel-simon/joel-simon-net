precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

vec3 glitchEffect(vec2 p, float t) {
    float n = pseudoNoise(p * 50.0 + t);
    float r = pseudoNoise(p + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(p + vec2(0.0, t * 0.15));
    float b = pseudoNoise(p + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

void main() {
    // Map uv to centered space
    vec2 centered = uv - vec2(0.5);
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    
    // Create a swirling spiral effect blending cosmic and fractal ideas
    float spiral = sin(10.0 * radius - time * 4.0 + angle * 5.0);
    
    // Incorporate digital glitch distortions on the spiral
    float noise = pseudoNoise(centered * 15.0 + time);
    float distortion = sin(time * 2.0 + angle * 4.0) * noise * 0.15;
    float modRadius = radius + distortion;
    float modAngle = angle + 2.0 * noise * sin(time + modRadius * 8.0);
    float combinedSpiral = sin(modAngle * 6.0 + modRadius * 25.0 - time * 3.0);
    float spiralMask = smoothstep(0.35, 0.4, abs(modRadius - 0.5) + combinedSpiral * 0.12);
    
    // Generate a grid pattern reminiscent of urban architecture
    vec2 grid = abs(fract(centered * 10.0) - 0.5);
    float gridLine = smoothstep(0.4, 0.42, min(grid.x, grid.y));
    
    // Blend the cosmic spiral and the structural grid pattern
    float pattern = smoothstep(0.2, 0.3, modRadius + 0.1 * spiral) * (1.0 - gridLine);
    
    // Base color modulation: blend between a deep cosmic blue and a vibrant cyan
    vec3 baseColor = mix(vec3(0.12, 0.3, 0.65), vec3(0.2, 0.8, 1.0), modRadius);
    
    // Apply glitch effect to infuse digital artifacts
    vec3 glitchC = glitchEffect(centered * 2.0, time);
    vec3 mixedColor = mix(baseColor, glitchC, 0.25);
    
    // Enhance via radial glow and vignette effects
    float glow = (spiralMask * (1.0 - smoothstep(0.48, 0.52, sin(12.0 * modRadius - 3.0 * time + 4.0 * modAngle)))) + (1.0 - smoothstep(0.3, 0.5, radius));
    float vignette = smoothstep(0.7, 0.3, radius);
    
    vec3 finalColor = mixedColor * glow * pattern * vignette;
    gl_FragColor = vec4(finalColor, 1.0);
}