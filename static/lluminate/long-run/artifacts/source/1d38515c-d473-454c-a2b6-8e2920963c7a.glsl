precision mediump float;
varying vec2 uv;
uniform float time;

// Random number generation
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 2D noise based on random numbers and smoothstep interpolation
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Glitch distortion: offset based on fbm noise and time
vec2 glitchOffset(vec2 pos) {
    float n = fbm(pos * 8.0 + time * 0.5);
    pos.x += smoothstep(0.3, 0.7, n) * 0.05 * sin(time * 10.0);
    pos.y += smoothstep(0.3, 0.7, n) * 0.05 * cos(time * 10.0);
    return pos;
}

// Tree branch style organic growth pattern using polar coordinates
float treeBranch(vec2 p, float t) {
    // Convert to polar coordinates
    float r = length(p);
    float angle = atan(p.y, p.x);
    // Oscillatory branch effect: branches emanate with decay from the center
    float branch = sin(5.0 * angle + t) * exp(-3.0 * r);
    return branch;
}

// Main shader combining organic growth, digital glitch and pulsation
void main() {
    // Apply glitch distortion to uv coordinates
    vec2 pos = glitchOffset(uv);
    
    // Center our coordinate system for polar and branch effects
    vec2 centered = (pos - 0.5) * 2.0;
    
    // Compute organic tree branch effect using polar style oscillation
    float branchEffect = treeBranch(centered, time);
    
    // Use fbm noise to add texture and fractal complexity
    float fractalTexture = fbm(centered * 3.0 + time);
    
    // Combine organic growth and fractal noise into a base pattern
    float pattern = smoothstep(0.2, 0.25, abs(branchEffect)) + fractalTexture * 0.3;
    
    // Create an evolving gradient background based on polar angle and time
    float angle = atan(centered.y, centered.x);
    vec3 colorGradient = mix(vec3(0.1, 0.2, 0.4), vec3(0.8, 0.4, 0.2), (sin(angle + time) + 1.0) * 0.5);
    
    // Add a pulsating effect driven by time and radial distance
    float radial = length(centered);
    float pulse = smoothstep(0.3, 0.32, radial + 0.1 * sin(time * 3.0));
    
    // Merge all effects: digital glitch, natural growth and dynamic background
    vec3 color = mix(colorGradient, vec3(1.0, 0.9, 0.6), pattern) * pulse;
    
    gl_FragColor = vec4(color, 1.0);
}