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
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 polarWarp(vec2 p, float factor) {
    float r = length(p);
    float a = atan(p.y,p.x);
    a += sin(r * 6.283 + time * 1.2) * factor;
    return vec2(r * cos(a), r * sin(a));
}

float fractalNoise(vec2 p) {
    float sum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        sum += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return sum;
}

void main(){
    vec2 p = (uv - 0.5) * 2.0;
    // Rotate and warp coordinates for unexpected patterns
    p = rotate(p, sin(time)*0.5);
    p = polarWarp(p, 0.8 + cos(time*0.7)*0.3);
    
    // Generate fractal noise on warped coordinates with time-based perturbations
    float f = fractalNoise(p + vec2(sin(time), cos(time)) * 0.5);
    
    // Introduce a secondary twist based on radius and noise
    float r = length(p);
    float twist = sin(10.0 * r - time * 2.0 + f * 6.283) * 0.5 + 0.5;
    
    // Mix dynamic color values with non-linear effects
    vec3 col;
    col.r = sin(f * 6.283 + time + twist) * 0.5 + 0.5;
    col.g = sin(f * 6.283 + time * 0.8 + twist * 1.2) * 0.5 + 0.5;
    col.b = sin(f * 6.283 + time * 1.2 + twist * 0.8) * 0.5 + 0.5;
    
    // Vignette using a smooth radial falloff
    float vignette = smoothstep(1.0, 0.0, r);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}