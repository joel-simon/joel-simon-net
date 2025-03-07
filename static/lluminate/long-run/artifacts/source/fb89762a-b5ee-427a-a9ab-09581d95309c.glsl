precision mediump float;
varying vec2 uv;
uniform float time;

// A different assumption: Instead of treating the canvas as a passive display, we assume each fragment is a living cell that evolves,
// where the edges are chaotic and the center is stable, completely inverting the common gradient approach.

// Simple pseudo-random hash function.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(42.345, 76.123))) * 13758.5453);
}

// 2D noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

// Fractal Brownian Motion that layers noise with reversed amplitude accumulation.
float fbm(vec2 p) {
    float sum = 0.0;
    float amp = 0.8;
    for (int i = 0; i < 5; i++) {
        sum += amp * noise(p);
        p *= 2.1;
        amp *= 0.5;
    }
    return sum;
}

// Reverse distortion: Rather than increasing distortions near center, they intensify toward edges.
vec2 edgeDistort(vec2 p) {
    float d = length(p);
    float factor = smoothstep(0.3, 1.0, d);
    float angle = noise(p * 5.0 + time) * 6.2831;
    return vec2(cos(angle), sin(angle)) * factor * 0.15;
}

// Inverted cell illumination: the "cells" (fragments) near edges glow with dynamic, digitized colors,
// while the center remains uniform and stable.
vec3 cellIllumination(vec2 p) {
    float d = length(p);
    float n = fbm(p * 3.0);
    float cellMask = smoothstep(0.1, 0.3, d + n * 0.4);
    
    // Generate a digital color mix from noise.
    vec3 cellColor = vec3(0.1 + 0.7 * sin(time + n * 6.2831),
                         0.2 + 0.8 * cos(time + n * 6.2831),
                         0.3 + 0.5 * sin(time * 1.3 + n * 6.2831));
    
    // The center is stable: a flat, soft color.
    vec3 coreColor = vec3(0.3, 0.3, 0.4);
    
    return mix(coreColor, cellColor, cellMask);
}

void main(void) {
    // Map uv to centered coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply edge-based distortion.
    p += edgeDistort(p);
    
    // Rotate coordinates based on time to create a slow evolving twist.
    float angle = time * 0.3;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    
    // Compute illumination based on "cell" concept.
    vec3 color = cellIllumination(p);
    
    // Overlay a dynamic grid pattern that fades from the center outward.
    vec2 grid = abs(fract(p * 4.0) - 0.5);
    float line = smoothstep(0.45, 0.5, min(grid.x, grid.y));
    color = mix(color, vec3(0.9, 0.95, 1.0), line * smoothstep(0.0, 0.8, length(p)));
    
    gl_FragColor = vec4(color, 1.0);
}