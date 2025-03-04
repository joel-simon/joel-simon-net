precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
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

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
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

void main(void) {
    // Normalize and center uv coordinates
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply a time evolving rotation and zoom
    float angle = time * 0.4;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    p *= 1.0 + 0.3 * sin(time * 0.5);
    
    // Create polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a dynamic radial wave with noise modulations
    float radialWave = sin(12.0 * r - time * 3.0 + 4.0 * a);
    
    // Add fractal noise based on rotated coordinate and scaled noise
    float fNoise = fractalNoise(p * 2.5 + time * 0.3);
    
    // Combine patterns in an interesting non-linear fashion
    float pattern = mix(radialWave, fNoise, 0.6);
    pattern = smoothstep(0.2, 0.8, pattern);
    
    // Generate a shifting color palette
    vec3 col = palette(pattern + 0.3 * sin(time + r * 10.0), 
                       vec3(0.2, 0.1, 0.3),
                       vec3(0.3, 0.4, 0.5),
                       vec3(1.0, 0.8, 0.5),
                       vec3(0.1, 0.2, 0.3));

    // Apply an additional swirling distortion based on noise and angle
    float swirl = sin(8.0 * a + fractalNoise(p * 3.0 - time)) * 0.15;
    col *= 1.0 + swirl;
    
    // Vignette effect using smooth radial falloff
    col *= smoothstep(1.2, 0.4, r);
    
    gl_FragColor = vec4(col, 1.0);
}