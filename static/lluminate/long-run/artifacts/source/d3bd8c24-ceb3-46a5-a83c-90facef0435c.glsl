precision mediump float;
varying vec2 uv;
uniform float time;

// Basic 2D hash for randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function based on hash
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

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Create a vortex effect by rotating coordinates based on radius and time
vec2 vortex(vec2 p) {
    vec2 centered = p - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x) + time * 0.5 + fbm(centered * 5.0) * 2.0;
    vec2 rotated = vec2(cos(angle), sin(angle)) * r;
    return rotated + 0.5;
}

// Generate layered organic-digital bloom shape
float digitalBloom(vec2 p) {
    // Apply vortex distortion
    p = vortex(p);
    // Create radial falloff pattern
    float center = smoothstep(0.45, 0.4, length(p - 0.5));
    // Add digital interference lines
    float lines = sin((p.y + time) * 20.0) * 0.5 + 0.5;
    // Combine with fractal noise modulation for organic texture
    float fb = fbm(p * 8.0 + time);
    return mix(center, lines, fb);
}

void main() {
    // Warp the uv coordinates for additional digital glitch
    vec2 pos = uv;
    pos.x += 0.02 * sin(pos.y * 50.0 + time * 3.0);
    pos.y += 0.02 * cos(pos.x * 50.0 + time * 3.0);
    
    // Compute the bloom pattern
    float bloom = digitalBloom(pos);
    
    // Create color gradients: substitute a new palette (vivid orange and deep blue)
    vec3 colorA = vec3(0.0, 0.15, 0.4);
    vec3 colorB = vec3(1.0, 0.5, 0.1);
    
    // Mix color based on the bloom shape
    vec3 color = mix(colorA, colorB, bloom);
    
    // Add a subtle vignette effect to focus the center
    float vignette = smoothstep(0.8, 0.45, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}