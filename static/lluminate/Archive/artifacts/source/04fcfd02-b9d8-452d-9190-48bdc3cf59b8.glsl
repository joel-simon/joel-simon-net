precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

vec2 kaleido(vec2 p, float segments) {
    float tau = 6.2831853;
    float angle = atan(p.y, p.x);
    float r = length(p);
    angle = mod(angle, tau / segments);
    angle = abs(angle - tau / (2.0 * segments));
    return vec2(r * cos(angle), r * sin(angle));
}

void main(){
    // Normalize and center uv coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply a dynamic swirl to the coordinates
    float a = atan(p.y, p.x);
    float r = length(p);
    float swirlStrength = 0.5 + 0.5 * sin(time * 1.5);
    float swirl = r + swirlStrength * sin(5.0 * a + time);
    p = normalize(p) * swirl;
    
    // Apply kaleidoscopic reflection
    p = kaleido(p, 8.0);
    
    // Generate fractal-like details using iterative noise accumulation
    float f = 0.0;
    float amplitude = 1.0;
    vec2 q = p * 2.0;
    for (int i = 0; i < 5; i++) {
        f += noise(q) * amplitude;
        q *= 2.0;
        amplitude *= 0.5;
    }
    
    // Use polar coordinates and fractal noise to modulate color channels
    vec3 col;
    col.r = sin(f + a + time);
    col.g = cos(f * 2.0 - time * 0.8);
    col.b = sin(f * 3.0 + cos(time) + r);
    
    col = 0.5 + 0.5 * col;
    
    gl_FragColor = vec4(col, 1.0);
}