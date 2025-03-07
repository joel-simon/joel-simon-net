precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float cell(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));
    vec2 smoothF = smoothstep(0.0, 1.0, f);
    return mix(mix(a, b, smoothF.x), mix(c, d, smoothF.x), smoothF.y);
}

float fractal(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

void main() {
    vec2 p = (uv - 0.5) * 2.0;
    
    // Introduce a dynamic rotation and slight scaling pulsation
    float angle = time * 0.4;
    float scale = 1.0 + 0.1 * sin(time * 1.7);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p * scale;
    
    // Polar coordinates for organic radial distortion
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create an organic grid pattern that radiates outward in fragments
    float grid = abs(sin(8.0 * a + time)) * smoothstep(1.0, 0.2, r);
    
    // Blend in fractal noise for a crystal-like texture effect
    float fractalNoise = fractal(3.0 * p + vec2(time * 0.3));
    
    // Combine cell-based and fractal noise with dynamic interference stripes
    float cells = cell(4.0 * p + vec2(time));
    float interference = sin(20.0 * r - time * 3.0) * 0.5 + 0.5;
    
    // Organic growth meets crystalline interference
    float pattern = mix(grid, fractalNoise, 0.6) + 0.3 * cells + 0.2 * interference;
    pattern = smoothstep(0.3, 0.7, pattern);
    
    // Define color scheme: cool crystal blues with hints of organic warmth
    vec3 color1 = vec3(0.1, 0.3, 0.5);
    vec3 color2 = vec3(0.8, 0.6, 0.4);
    vec3 color = mix(color1, color2, pattern);
    
    // Soft vignette effect at the edges
    float vignette = smoothstep(1.2, 0.5, r);
    gl_FragColor = vec4(color * vignette, 1.0);
}