precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Digital glitch effect: random horizontal displacements
vec2 glitch(vec2 pos, float t) {
    float offset = noise(vec2(pos.y * 10.0, t)) * 0.05;
    return vec2(pos.x + offset, pos.y);
}

// Cosmic orbital fractal swirl combining two unrelated domains: deep cosmic orbits meet digital glitches
vec3 cosmicSwirl(vec2 pos, float t) {
    // Center the coordinates
    vec2 centered = pos - 0.5;
    
    // Polar coordinates for the cosmic swirl
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    
    // Create multiple orbit rings
    float orbit = sin(10.0 * r - t * 2.0 + angle * 4.0);
    orbit = smoothstep(0.01, 0.02, abs(orbit));
    
    // Create a digital interference pattern using glitch noise along orbits
    float inter = noise(centered * 5.0 + t);
    inter = smoothstep(0.3, 0.7, inter);
    
    // Use a mix of cosmic purple and digital cyan
    vec3 cosmicColor = vec3(0.3, 0.0, 0.4);
    vec3 digitalColor = vec3(0.0, 0.8, 0.9);
    
    // Combine cosmic orbits with random digital interference
    vec3 color = mix(cosmicColor, digitalColor, orbit);
    color += inter * 0.3;
    
    // Add a subtle glow at center
    color += vec3(0.2, 0.1, 0.3) * exp(-20.0 * r * r);
    
    return color;
}

void main() {
    vec2 pos = uv;
    
    // First domain: apply a subtle pan and zoom simulating orbit drift
    pos = (pos - 0.5) * (1.0 + 0.2 * sin(time)) + 0.5;
    
    // Second domain: apply glitch artifacts to simulate digital interference
    pos = glitch(pos, time);
    
    vec3 col = cosmicSwirl(pos, time);
    
    gl_FragColor = vec4(col, 1.0);
}