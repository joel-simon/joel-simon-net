precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fractalNoise(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(void) {
    // Normalize UV and center around (0,0)
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply a swirling transformation
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float swirl = sin(radius * 10.0 - time * 2.0 + fractalNoise(p * 3.0) * 5.0);
    float newAngle = angle + swirl * 0.5;
    vec2 coord = vec2(cos(newAngle), sin(newAngle)) * radius;
    
    // Create multi-layer fractal noise pattern for added complexity
    float n = fractalNoise(coord * 4.0 + time * 0.5);
    float n2 = fractalNoise(coord * 8.0 - time);
    
    // Combine radial pattern with noise layers
    float pattern = smoothstep(0.3, 0.0, abs(radius - n * 0.3)) + smoothstep(0.5, 0.2, abs(radius - n2 * 0.2));
    
    // Dynamic color palette shifting over time
    vec3 color = palette(n + n2, vec3(0.5), vec3(0.5), vec3(1.0, 0.3, 0.6), vec3(time * 0.1, time * 0.2, time * 0.15));
    
    // Apply a vignette effect
    float vignette = smoothstep(0.8, 0.3, radius);
    color *= vignette * pattern;
    
    gl_FragColor = vec4(color, 1.0);
}