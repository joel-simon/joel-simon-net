precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

mat2 rot(float a){
    float s = sin(a), c = cos(a);
    return mat2(c, -s, s, c);
}

void main(){
    // Shift uv to center and scale
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply a dynamic rotation based on time
    p = rot(time * 0.5) * p;
    
    // Introduce a kaleidoscopic twist by mirroring in sectors
    float sectors = 6.0;
    float angle = atan(p.y, p.x);
    float radius = length(p);
    angle = mod(angle, 3.14159265*2.0/sectors);
    p = vec2(cos(angle), sin(angle)) * radius;
    
    // Create an iterative fractal distortion effect
    vec2 q = p;
    float accum = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 8; i++) {
        q = abs(q) / dot(q, q + 0.5) - 1.0;
        accum += abs(noise(q * scale) - 0.5) / scale;
        scale *= 1.5;
    }
    
    // Use noise for additional organic texture
    float n = noise(p * 3.0 + time);
    
    // Combine multiple layers of effects
    float intensity = smoothstep(0.2, 1.0, accum * 0.4 + n * 0.6);
    
    // Color modulation using polar coordinates and time-based oscillations
    vec3 color;
    color.r = sin(radius * 3.0 + time) * 0.5 + 0.5;
    color.g = cos(angle * 4.0 - time * 1.2) * 0.5 + 0.5;
    color.b = sin(intensity * 6.28 + time * 0.8);
    
    // Apply a vignette for focus
    float vignette = smoothstep(1.2, 0.4, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}