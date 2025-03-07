precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float fbm(vec2 p) {
    float f = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        f += amplitude * pseudoNoise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return f;
}

void main() {
    // Center the coordinate system
    vec2 centered = uv - 0.5;
    
    // Compute polar coordinates
    float angle = atan(centered.y, centered.x);
    float radius = length(centered) * 1.5;
    
    // Introduce fractal noise for an organic pattern twist
    float noise = fbm(centered * 3.0 + time * 0.5);
    
    // Create a swirling, pulsating wave that reverses typical modulations
    float wave = sin(12.0 * radius - time * 5.0 + angle * 4.0 + noise * 6.2831);
    
    // Define intensity based on the wave; reverse the typical buildup
    float intensity = smoothstep(0.0, 0.1, abs(wave));
    
    // Craft a digital grid pattern that seems to fade in reverse over time
    vec2 grid = abs(fract(uv * 20.0 - time * 0.3) - 0.5);
    float gridPattern = smoothstep(0.3, 0.32, min(grid.x, grid.y));
    
    // Combine two color schemes by mixing organic and digital cues
    vec3 colorA = vec3(0.2 + noise * 0.8, 0.1, 0.3 + noise * 0.7);
    vec3 colorB = vec3(1.0 - noise, 0.6, 0.2);
    vec3 finalColor = mix(colorA, colorB, intensity);
    
    // Reverse blend: subtract grid pattern influence rather than overlay
    finalColor = finalColor - gridPattern * 0.3;
    
    // Apply a vignette effect for depth and mood
    float vignette = smoothstep(0.8, 0.4, radius);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}