precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Map UV coordinate to centered space
    vec2 centered = uv - 0.5;
    
    // Primary domain: Cosmic grid and spiral swirl
    float dist = length(centered);
    float angle = atan(centered.y, centered.x);
    
    // Secondary domain: Introduce glitch and error from digital noise and organic flow
    float noise = pseudoNoise(centered * 15.0 + time);
    float distortion = sin(time * 2.0 + angle * 4.0) * noise * 0.15;
    float modR = dist + distortion;
    
    // Transfer and synthesize transformation: twist the angle with noise-based glitching effects
    float modAngle = angle + 2.0 * noise * sin(time + modR * 8.0);
    
    // Cosmic starburst: Create radial wave dynamics with a sine-based spiral pattern
    float spiral = sin(modAngle * 6.0 + modR * 25.0 - time * 3.0);
    float spiralMask = smoothstep(0.35, 0.4, abs(modR - 0.5) + spiral * 0.12);
    
    // Digital glitch: Add horizontal digital error inspired band using wave equation
    float wave = sin(12.0 * modR - 3.0 * time + 4.0 * modAngle);
    float band = smoothstep(0.48, 0.52, wave);
    
    // Synthesize color by mixing a cosmic palette with digital glitch hue blending
    vec3 cosmicColor = mix(vec3(0.12, 0.3, 0.65), vec3(0.85, 0.45, 0.25), smoothstep(0.2, 0.7, modR));
    vec3 glitchColor = vec3(0.7, 0.1, 0.8) * step(0.97, pseudoNoise(vec2(time, modAngle * 3.0)));
    vec3 finalColor = mix(cosmicColor, glitchColor, 0.5);
    
    // Final composition: Blend spiral, band, and radial glare
    float glow = (spiralMask * band) + (1.0 - smoothstep(0.3, 0.5, dist));
    gl_FragColor = vec4(finalColor * glow, 1.0);
}