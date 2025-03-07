precision mediump float;
varying vec2 uv;
uniform float time;

// Basic hash function for randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal brownian motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Polar transformation function
vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

vec2 fromPolar(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

// Synthesize organic circuit: merging nature (coral-like growth) with digital fractal distortions.
float organicCircuit(vec2 p) {
    // center and scale
    p = (p - 0.5) * 2.0;
    
    // Transform to polar coordinates
    vec2 polar = toPolar(p);
    // Create swirling arms influenced by time and noise (like digital signals interfering)
    float arms = sin(polar.y * 3.0 + time + fbm(p * 3.0));
    
    // Threshold on radius modulated by arms to create branching structure
    float branch = smoothstep(0.1 + 0.3 * arms, 0.12 + 0.3 * arms, polar.x);
    return branch;
}

// Apply digital glitch by warping coordinates with noise and time
vec2 glitchWarp(vec2 p) {
    float n = fbm(p * 8.0 + time * 0.7);
    p.x += 0.05 * sin(10.0 * p.y + time) * n;
    p.y += 0.05 * cos(10.0 * p.x + time) * n;
    return p;
}

void main() {
    // Apply glitch to uv coordinates
    vec2 pos = glitchWarp(uv);
    
    // Generate organic circuit pattern
    float circuit = organicCircuit(pos);
    
    // Background digital field with fractal noise
    float field = fbm(pos * 5.0 + time * 0.3);
    
    // Color synthesis: mix digital cyan with organic magenta
    vec3 digitalColor = vec3(0.0, 0.8, 0.9) * field;
    vec3 organicColor = vec3(0.8, 0.1, 0.7) * circuit;
    
    // Combine using mix to emphasize intertwined themes
    vec3 color = mix(digitalColor, organicColor, circuit);
    
    // Optionally add vignette effect
    float vignette = smoothstep(1.0, 0.4, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}