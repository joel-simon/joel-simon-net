precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash function for noise generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function using interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Kaleidoscopic reflection function
vec2 kaleido(vec2 p, float n) {
    float r = length(p);
    float a = atan(p.y, p.x);
    a = mod(a, 2.0 * 3.14159265 / n);
    a = abs(a - 3.14159265 / n);
    return vec2(r * cos(a), r * sin(a));
}

void main(){
    // Recenter and scale uv coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply a time-dependent rotation
    float angle = time * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    
    // Introduce kaleidoscopic symmetry with 6 sectors
    p = kaleido(p, 6.0);
    
    // Separate polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Generate two layers of noise and fractal patterns
    float n1 = noise(p * 3.0 + time * 0.8);
    float n2 = noise(p * 8.0 - time * 1.2);
    
    // Create swirling and radial distortions with sine and cosine waves
    float swirl = sin(6.0 * r - time * 2.0 + sin(4.0 * a)) + cos(10.0 * a + time);
    
    // Combine multiple effects to form the pattern
    float pattern = smoothstep(0.2, 0.5, abs(swirl)) + 0.4 * n1 + 0.2 * n2;
    
    // Dynamic color palette affected by the pattern and polar coordinates
    vec3 col;
    col.r = sin(pattern + a + time * 1.2);
    col.g = cos(pattern + r - time * 1.0);
    col.b = sin(pattern + cos(time + r + a * 2.0));
    
    // Enhance vibrancy and contrast
    col = mix(vec3(0.2, 0.1, 0.3), col, 0.7);
    col = 0.5 + 0.5 * col;
    
    gl_FragColor = vec4(col, 1.0);
}