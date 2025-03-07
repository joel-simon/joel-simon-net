precision mediump float;
varying vec2 uv;
uniform float time;

// Simple noise function
float noise(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Organic fractal noise based function
float fractalNoise(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Convert to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Compute organic wave based on fractal noise function
    float organic = fractalNoise(pos * 3.0 + time * 0.5);
    
    // Digital glitch component: a sharp jittered grid
    vec2 glitchUV = uv * 10.0;
    float glitch = step(0.92, fract(glitchUV.x + fract(glitchUV.y * 1.3 + time)));
    
    // Map conceptual space 1: organic, flowing fractal growth
    float organicFlow = smoothstep(0.3, 0.32, abs(radius - organic * 0.5));
    
    // Map conceptual space 2: digital structure with emergent glitches and grids
    vec2 gridPos = fract(uv * 8.0 + sin(time) * 0.5);
    float grid = smoothstep(0.48, 0.5, min(gridPos.x, gridPos.y));
    
    // Blend the two spaces via selective mapping
    float emergentMask = mix(organicFlow, grid, glitch);
    
    // Emergent swirling patterns from blending
    float swirl = sin(angle * 5.0 + time * 2.0) * 0.5 + 0.5;
    float emergentDetail = pow(organic * swirl, 1.5);
    
    // Compose color from two palettes: one organic (earth tone) & one digital (vibrant neon)
    vec3 organicColor = mix(vec3(0.2, 0.5, 0.2), vec3(0.6, 0.8, 0.3), organic);
    vec3 digitalColor = mix(vec3(0.1, 0.0, 0.3), vec3(0.8, 0.2, 1.0), emergentDetail);
    
    // Blend colors based on emergent mask and swirling details
    vec3 finalColor = mix(organicColor, digitalColor, emergentMask);
    
    // Add subtle pulsation for dynamic effect
    finalColor += emergentDetail * 0.15 * vec3(sin(time * 3.0), cos(time * 2.5), sin(time * 2.0));
    
    gl_FragColor = vec4(finalColor, 1.0);
}