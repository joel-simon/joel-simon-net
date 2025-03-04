precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Kaleidoscopic function with n sectors
vec2 kaleido(vec2 p, float n) {
    float r = length(p);
    float a = atan(p.y, p.x);
    a = mod(a, 6.2831853 / n);
    a = abs(a - 3.14159265 / n);
    return vec2(r * cos(a), r * sin(a));
}

// Swirl distortion function
vec2 swirl(vec2 p, float strength) {
    float r = length(p);
    float a = atan(p.y, p.x);
    a += strength * exp(-r * 2.0);
    return vec2(r * cos(a), r * sin(a));
}

void main(){
    // Center and scale coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply a time based rotation
    float angle = time * 0.3;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    
    // Apply swirl distortion
    p = swirl(p, 1.5 * sin(time * 0.8));
    
    // Apply kaleidoscopic symmetry with 8 sectors
    p = kaleido(p, 8.0);
    
    // Create layered FBM noise distortions
    float n1 = fbm(p * 2.0 + time * 0.5);
    float n2 = fbm(p * 4.0 - time * 0.7);
    
    // Radial wave effect
    float r = length(p);
    float radial = sin(10.0 * r - time * 2.0);
    
    // Combine effects
    float pattern = mix(n1, n2, 0.5) + radial;
    pattern = smoothstep(0.3, 0.7, pattern);
    
    // Dynamic color palette based on pattern and polar coordinates
    float a = atan(p.y, p.x);
    vec3 col;
    col.r = sin(pattern * 3.0 + a + time);
    col.g = cos(pattern * 2.0 - r - time * 0.8);
    col.b = sin(pattern * 4.0 + r + cos(time));
    
    // Vignette effect
    float vig = smoothstep(1.2, 0.0, r);
    col *= vig;
    
    gl_FragColor = vec4(col * 0.5 + 0.5, 1.0);
}