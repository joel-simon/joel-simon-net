precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function based on UV coordinates
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function with bilinear interpolation
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

// Fractal noise by layering multiple octaves
float fractalNoise(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Rotate a 2D vector by angle 'a'
vec2 rotate2D(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

void main(){
    // Center and scale coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Time varying rotation and zoom
    float angle = time * 0.7;
    p = rotate2D(p, angle);
    p *= 1.0 + 0.3 * sin(time * 0.5);
    
    // Polar coordinates for swirling effect
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a dynamic spiral distortion modulated by fractal noise
    float spiral = sin(8.0 * a + time + fractalNoise(p * 3.0) * 6.2831);
    
    // Iterated distortion: warp the coordinate space repeatedly
    vec2 q = p;
    for (int i = 0; i < 3; i++){
        q += 0.5 * vec2(sin(q.y * 3.0 + time * 0.5), cos(q.x * 3.0 - time * 0.5));
        q = rotate2D(q, 0.3);
    }
    
    // Combine effects – fractal warp and spiral modulation
    float layering = fractalNoise(q * 1.5 + time * 0.4);
    float pattern = smoothstep(0.2, 0.5, abs(spiral)) + 0.6 * layering;
    
    // Dynamic, rich color modulation based on coordinates and noise pattern
    vec3 color;
    color.r = 0.5 + 0.5 * sin(pattern + a + time);
    color.g = 0.5 + 0.5 * cos(pattern + r - time * 0.8);
    color.b = 0.5 + 0.5 * sin(pattern + cos(time * 0.3 + r + a));
    
    // Apply vignette effect based on radial distance
    float vignette = smoothstep(1.0, 0.3, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}