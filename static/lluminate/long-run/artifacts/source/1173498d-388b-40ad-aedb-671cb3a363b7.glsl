precision mediump float;
varying vec2 uv;
uniform float time;

// Basic hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0, amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Brain-like implicit function pattern.
float brainPattern(vec2 p) {
    // Create a symmetrical pattern from sinusoidal waves.
    float angle = atan(p.y, p.x);
    float radial = length(p);
    float waves = sin(10.0 * radial - time*2.0 + cos(angle*3.0)*2.0);
    // Use fbm for organic wrinkles.
    float wrinkles = fbm(p * 3.0 + time);
    return smoothstep(0.4, 0.42, waves + wrinkles * 0.3);
}

// Glitch offset function
vec2 glitch(vec2 p, float t) {
    float shift = fract(sin(dot(p, vec2(12.9898,78.233)) + t) * 43758.5453);
    return p + vec2(shift * 0.05, 0.0);
}

// Cosmic swirl background using polar distortion.
vec3 cosmicBackground(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    float swirl = sin(5.0 * r - time + a);
    vec3 colA = vec3(0.05, 0.1, 0.2);
    vec3 colB = vec3(0.2, 0.1, 0.3);
    return mix(colA, colB, swirl * 0.5 + 0.5);
}

// Brain symbol rendered as organic growth pattern within glitch environment.
// Creative Strategy: Replace the phoenix (symbol for rebirth) with a brain, emphasizing intellectual resilience.
vec3 brainSymbol(vec2 p) {
    // Normalize coordinate space from center.
    vec2 cp = p * 2.0 - 1.0;
    // Distort coordinate for glitchy brain folds.
    cp = glitch(cp, time);
    // Create brain-like structure using the implicit function.
    float brain = brainPattern(cp);
    // Color modulation for brain structure.
    vec3 brainCol = vec3(0.8,0.7,0.6) * (1.0 - brain);
    return brainCol;
}

void main() {
    // Normalize UV to center.
    vec2 st = uv * 2.0 - 1.0;
    
    // Create a swirling cosmic background.
    vec3 bg = cosmicBackground(st);
    
    // Generate layered organic textures with fbm.
    float organic = fbm(st * 2.5 + time);
    vec3 organicLayer = mix(vec3(0.1,0.2,0.3), vec3(0.3,0.2,0.4), organic);
    
    // Mix glitch artifacts using noise.
    vec2 glitchUV = glitch(uv, time * 1.5);
    float glitchEffect = smoothstep(0.3, 0.35, noise(glitchUV * 10.0 + time));
    
    // Generate the brain symbol pattern representing intellectual resilience.
    vec3 brainArt = brainSymbol(uv);
    
    // Combine the layers.
    vec3 combined = mix(bg, organicLayer, 0.5);
    combined = mix(combined, brainArt, glitchEffect);
    
    gl_FragColor = vec4(combined, 1.0);
}