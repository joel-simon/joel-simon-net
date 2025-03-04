precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main(){
    // Normalize uv and center coordinates.
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply a dynamic rotation influenced by time.
    float angle = time * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    
    // Create polar coordinates for swirling effect.
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Generate a swirling pattern with modulation.
    float swirl = sin(8.0 * r - time * 3.0 + sin(5.0 * a));
    float fractal = fbm(p * 2.5 + time);
    
    // Combine effects: swirling rings modulated by a fractal base.
    float pattern = smoothstep(0.1, 0.3, abs(swirl)) + 0.4 * fractal;
    
    // Introduce secondary effects: a radial vignette with animated offset.
    float vignette = smoothstep(0.8, 0.2, r + 0.3 * sin(time + a * 3.0));
    
    // Color modulation based on pattern, angle, and time.
    vec3 col;
    col.r = sin(pattern + a + time * 0.7);
    col.g = cos(pattern + r - time * 0.6);
    col.b = sin(pattern + cos(time + r + a));
    
    col = 0.5 + 0.5 * col;
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}