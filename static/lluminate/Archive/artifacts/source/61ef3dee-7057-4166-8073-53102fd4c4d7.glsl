precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(){
    // Center uv coordinates to [-1,1]
    vec2 p = uv * 2.0 - 1.0;

    // Apply a dynamic kaleidoscopic reflection using modulo on polar angle
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float segments = 6.0 + 4.0 * sin(time * 0.3);
    angle = mod(angle, 6.28318 / segments) - (3.14159 / segments);

    // Reconstruct coordinates
    p = vec2(cos(angle), sin(angle)) * radius;

    // Add time-based swirling distortion
    float swirl = 0.5 * sin(time + radius * 6.28318);
    float s = sin(swirl);
    float c = cos(swirl);
    p = vec2(p.x * c - p.y * s,
             p.x * s + p.y * c);

    // Create fractal-like layered noise effect via iterative distortion
    float intensity = 0.0;
    vec2 pos = p;
    for (int i = 0; i < 6; i++){
        float n = hash(pos + time);
        intensity += (1.0/float(i+1)) * sin(3.0 * pos.x + time + n * 6.28318);
        pos = abs(pos * 1.8) - 0.5;
    }

    // Combine radial gradient and fractal intensity for mask
    float mask = smoothstep(1.2, 0.0, radius + 0.3 * intensity);

    // Dynamic evolving color palette
    vec3 baseCol = palette(0.5 + intensity * 0.3 + time * 0.05,
                           vec3(0.5, 0.4, 0.3),
                           vec3(0.5),
                           vec3(1.0, 0.9, 0.7),
                           vec3(0.2, 0.3, 0.4));

    // Enhance contrast with an extra modulation based on angle and noise
    float extra = smoothstep(-0.5, 0.5, sin(5.0 * angle + time) + 0.5 * sin(7.0 * radius));
    vec3 finalColor = baseCol * mix(0.6, 1.2, extra) * mask;

    // Apply vignette effect
    finalColor *= smoothstep(1.2, 0.0, radius);

    gl_FragColor = vec4(finalColor, 1.0);
}