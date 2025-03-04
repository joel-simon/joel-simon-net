precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec3 colorPalette(float t) {
    vec3 a = vec3(0.5, 0.4, 0.3);
    vec3 b = vec3(0.5, 0.6, 0.7);
    vec3 c = vec3(1.0, 1.0, 1.0);
    vec3 d = vec3(0.00, 0.33, 0.67);
    return a + b * cos(6.28318 * (c * t + d));
}

float fractal(vec2 p) {
    float amplitude = 0.5;
    float frequency = 1.0;
    float sum = 0.0;
    for (int i = 0; i < 5; i++) {
        sum += amplitude * noise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return sum;
}

void main(){
    // Normalize and center UV coordinates
    vec2 p = uv * 2.0 - 1.0;
    
    // Rotate coordinates dynamically
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    p = vec2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Distort coordinates using a swirling polar transformation
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += sin(r * 10.0 - time * 2.0) * 0.8;
    p = r * vec2(cos(theta), sin(theta));
    
    // Create a shifting grid distortion effect
    vec2 grid = p * 3.0;
    grid += vec2(cos(time), sin(time));
    float gridPattern = smoothstep(0.48, 0.5, abs(fract(grid.x) - 0.5)) *
                        smoothstep(0.48, 0.5, abs(fract(grid.y) - 0.5));
    
    // Layered fractal noise modulation
    float f = fractal(p * 2.5 + time);
    
    // Mix grid pattern and fractal noise to create complex texture
    float mixVal = mix(f, gridPattern, 0.5);
    
    // Evolving palette modulated by dynamic mix and distance from center
    vec3 col = colorPalette(mixVal + time * 0.2 + r * 0.5);
    
    // Add a vignette effect that darkens the edges
    col *= smoothstep(1.2, 0.3, r);
    
    gl_FragColor = vec4(col, 1.0);
}