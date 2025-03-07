precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random function
float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Function to simulate a glitch effect
float glitch(in vec2 st, float intensity) {
    float t = time * 0.5;
    float shift = step(0.95, random(vec2(t, st.y))) * intensity;
    return shift;
}

void main(void) {
    // Transform uv into centered coordinates
    vec2 pos = uv - 0.5;
    pos *= 2.0;
    
    // Convert to polar coordinates for swirling effect
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a swirling distortion
    float swirl = sin(angle * 3.0 + time) * 0.3;
    float layeredNoise = noise(pos * 2.0 + time * 0.5);
    r += swirl * layeredNoise;
    
    // Medium association: Organic flicker merged with digital glitch
    float glitchEffect = glitch(uv, 0.5);
    float radialPattern = smoothstep(0.45 + glitchEffect, 0.4 + glitchEffect, r);
    
    // Create color gradients: blending warm digital hues with cool organic tones
    vec3 warmColor = vec3(0.9, 0.6, 0.2);
    vec3 coolColor = vec3(0.2, 0.4, 0.8);
    float colorMix = noise(pos * 5.0 - time);
    vec3 baseColor = mix(warmColor, coolColor, colorMix);
    
    // Overlay a digital artifact: pixel-like blocks that fade with distance
    vec2 grid = fract(uv * 20.0 - time);
    float pixelBlock = step(0.8, grid.x) * step(0.8, grid.y);
    baseColor += vec3(pixelBlock * 0.2);
    
    // Final composition with radial fade
    vec3 finalColor = mix(baseColor, vec3(0.0), smoothstep(0.7, 1.0, r));
    
    gl_FragColor = vec4(finalColor, 1.0);
}