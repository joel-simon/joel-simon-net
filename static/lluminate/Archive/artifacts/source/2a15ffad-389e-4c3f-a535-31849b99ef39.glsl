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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec2 swirl(vec2 p, float strength) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    angle += strength / (r + 0.1);
    return vec2(r * cos(angle), r * sin(angle));
}

void main() {
    vec2 p = (uv - 0.5) * 3.0;
    
    // Dynamic rotational speed and swirl intensity
    float swirlAmount = sin(time * 0.7) * 2.5;
    p = swirl(p, swirlAmount);
    
    // Add layered time-evolving rotations
    p = rotate(p, time * 0.3);
    
    // Fractal-like iterative noise mixing
    float sum = 0.0;
    float amp = 0.5;
    vec2 pos = p;
    for (int i = 0; i < 5; i++) {
        float n = noise(pos + time * 0.2);
        sum += amp * n;
        pos *= 2.0;
        amp *= 0.5;
    }
    
    // Radial gradient based on distance from center with dynamic modulation
    float dist = length(p);
    float radial = smoothstep(2.0, 0.0, dist + 0.3 * sin(time + sum * 6.0));
    
    // Create vibrant colors with dynamic phase shifts
    vec3 col;
    float base = sum * 6.2831 + time;
    col.r = 0.5 + 0.5 * sin(base + 0.0);
    col.g = 0.5 + 0.5 * sin(base + 2.094);
    col.b = 0.5 + 0.5 * sin(base + 4.188);
    
    // Introduce a secondary pattern overlay using noise
    float overlay = noise(p * 4.0 - time * 1.5);
    col *= mix(0.6, 1.2, overlay);
    
    // Combine with the radial falloff and add a vignette
    col *= radial;
    
    gl_FragColor = vec4(col, 1.0);
}