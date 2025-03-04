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

void main(){
    // Center and scale UV coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Rotate coordinates over time and create spiral effect
    float angle = time * 0.3;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    
    // Polar transformation
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a multi-layered swirling pattern with noise modulation:
    float swirl = sin(12.0 * r - time * 2.0 + sin(4.0 * a)) + cos(8.0 * a + time);
    float fractal = noise(p * 3.0 + time * 0.5);
    
    // Combine the spiral and fractal noise to enhance detail
    float pattern = smoothstep(0.2, 0.4, abs(swirl)) + 0.5 * fractal;
    
    // Modulate colors based on polar coordinates and pattern
    vec3 col;
    col.r = sin(pattern + a + time);
    col.g = cos(pattern + r - time * 0.7);
    col.b = sin(pattern + cos(time + r + a));
    
    col = 0.5 + 0.5 * col;
    gl_FragColor = vec4(col, 1.0);
}