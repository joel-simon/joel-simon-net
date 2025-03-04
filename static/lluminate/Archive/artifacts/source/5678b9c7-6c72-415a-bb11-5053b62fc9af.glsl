precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main() {
    // Re-center uv to [-1,1]
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply a kaleidoscopic mirror effect
    float k = 6.0;
    float angle = atan(p.y, p.x);
    float radius = length(p);
    angle = mod(angle * k, 3.14159 * 2.0) - 3.14159;
    p = vec2(cos(angle), sin(angle)) * radius;
    
    // Dynamic swirling transformation
    float swirl = sin(time * 0.8) * 0.5 + 0.5;
    float twist = swirl * radius;
    float sinT = sin(twist);
    float cosT = cos(twist);
    p = vec2(p.x * cosT - p.y * sinT, p.x * sinT + p.y * cosT);
    
    // Fractal iteration and mirror reflection in abs space
    float intensity = 0.0;
    vec2 pos = p;
    for (int i = 0; i < 8; i++){
        pos = abs(pos) / dot(pos, pos + 0.5) - 1.0;
        float n = sin(dot(pos, vec2(3.14,2.71)) + time);
        intensity += (0.5 / float(i+1)) * n;
    }
    
    // Calculate final factor based on radius and fractal intensity
    float mixFactor = smoothstep(0.0, 1.0, radius + intensity * 0.6);
    
    // Dynamic color palette evolving in time and space
    vec3 color = palette(mixFactor + time * 0.15,
                         vec3(0.5, 0.4, 0.7),
                         vec3(0.5, 0.6, 0.3),
                         vec3(1.0, 0.9, 0.5),
                         vec3(atan(p.y, p.x) / 6.28318, 0.3, 0.7));
    
    // Add vignette using smoothstep for soft edges
    color *= smoothstep(1.0, 0.2, radius);
    
    gl_FragColor = vec4(color, 1.0);
}