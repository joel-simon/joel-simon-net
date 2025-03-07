precision mediump float;
varying vec2 uv;
uniform float time;

// Random cryptic directive: "Honor thy error as a hidden intention."

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

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Distortion function that introduces controlled glitches
vec2 glitch(vec2 p) {
    float n = fbm(vec2(p.y * 8.0, time));
    p.x += 0.08 * sin(50.0 * p.y + time * 5.0) * smoothstep(0.48, 0.52, abs(fract(time * 0.5) - p.y)) * n;
    return p;
}

// Organic swirl to twist the coordinates in a vortex pattern
vec2 swirl(vec2 p) {
    p -= 0.5;
    float angle = fbm(p * 3.0 + time) * 3.1415;
    float s = sin(angle);
    float c = cos(angle);
    p = vec2(c * p.x - s * p.y, s * p.x + c * p.y);
    p += 0.5;
    return p;
}

// Organic branch-like structure function
float organicBranch(vec2 p, float t) {
    p = p * 2.0 - 1.0;
    float r = length(p);
    float angle = atan(p.y, p.x);
    float wave = sin(12.0 * r - angle * 5.0 + t * 3.0);
    float branch = exp(-4.0 * r);
    return smoothstep(0.3, 0.5, abs(wave) * branch);
}

void main() {
    vec2 pos = uv;
    
    // Apply a digital glitch distortion
    pos = glitch(pos);
    
    // Apply an organic swirl to the coordinates    
    vec2 swirlPos = swirl(pos);
    
    // Generate an organic branch structure from the swirled coordinates
    float branches = mix(organicBranch(uv, time), organicBranch(swirlPos, time * 1.1), 0.5);
    
    // Create a cosmic digital noise field in the background
    float digitalField = fbm(uv * 5.0 - time * 0.3);
    
    // Color components: warm organic color and cool digital tone
    vec3 organicColor = vec3(1.0, 0.5, 0.2) * branches;
    vec3 digitalColor = vec3(0.2, 0.6, 0.9) * digitalField;
    
    // Blend the two aesthetics into one unified scene
    vec3 color = mix(digitalColor, organicColor, branches);
    
    // Apply a vignette effect to focus the composition
    float vignette = smoothstep(0.8, 0.4, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}