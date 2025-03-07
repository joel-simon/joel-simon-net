precision mediump float;
varying vec2 uv;
uniform float time;

// Hash and noise functions
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Rotational transformation based on noise for glitch effect
vec2 reverseWarp(vec2 p, float t) {
    float n = noise(p * 5.0 - t);
    float angle = n * 6.2831;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, s, -s, c);
    return rot * p * (0.8 + 0.2 * n);
}

// Simulate tree branch patterns using polar coordinates and noise
float treeBranch(vec2 pos) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float branch = smoothstep(0.02, 0.0, abs(sin(4.0 * angle + time) * 0.5 + 0.5 - r));
    branch *= smoothstep(0.0, 0.3, noise(pos * 5.0 + time));
    return branch;
}

// Quantization function for digital aesthetic glitch
float quantize(float val, float levels) {
    return floor(val * levels) / levels;
}

void main() {
    // Center uv coordinates and apply a slight zoom effect
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply reverse warping to introduce glitch style distortions
    vec2 warped = reverseWarp(pos, time * 0.5);
    
    // Create fractal texture background (digital grid feel) using fbm
    float f = fbm(warped * 3.0 + time * 0.2);
    f = quantize(f, 8.0);
    
    // Generate a digital grid overlay
    vec2 grid = abs(fract(pos * 10.0 - time * 0.3) - 0.5);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y));
    
    // Construct base color from two palettes and mix with grid inversion
    vec3 colorA = vec3(f * 0.6 + 0.2, f * 0.3 + 0.1, 1.0 - f);
    vec3 colorB = vec3(1.0 - f, f * 0.4, f * 0.8);
    vec3 baseColor = mix(colorA, colorB, step(0.5, line));
    
    // Create tree branch structure using warped coordinates
    float branch = treeBranch(warped * 1.5);
    
    // Add glitch offsets using random noise for extra digital effects
    float glitch = step(0.99, hash(uv * time)) * 0.12;
    
    // Define branch color with organic warm hues and modulation from fbm
    vec3 branchColor = vec3(0.3 + 0.4 * sin(f + time), 0.2 + 0.3 * cos(f - time), 0.1 + 0.2 * sin(f * 2.0 + time));
    
    // Combine background with branch structures and glitch effects
    vec3 finalColor = mix(baseColor, branchColor, branch);
    finalColor += glitch;
    
    // Overlay pulsating digital reversion effect
    float pulse = sin(time * 3.0) * 0.5 + 0.5;
    finalColor = mix(finalColor, vec3(1.0) - finalColor, pulse * 0.2);
    
    gl_FragColor = vec4(finalColor, 1.0);
}