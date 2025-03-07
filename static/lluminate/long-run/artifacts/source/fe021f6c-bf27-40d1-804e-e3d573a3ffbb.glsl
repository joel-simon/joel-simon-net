precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453);
}

// 2D noise function
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

// Reversed polar transformation with modulated time swirl
vec2 reversePolar(vec2 pos, float t) {
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    theta += sin(r * 10.0 - t * 3.0) * 0.5;
    return vec2(r * cos(theta), r * sin(theta));
}

void main(void) {
    // Map uv to centered space in [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply reversed polar distortion
    vec2 distorted = reversePolar(pos, time);
    
    // Create a blend of two radial patterns: one for a pulsating core, another for swirling arms
    float core = smoothstep(0.5, 0.48, length(distorted));
    float arms = abs(sin(12.0 * atan(distorted.y, distorted.x) + time*2.5));
    
    // Integrate noise to break uniformity and add texture
    float n = noise(distorted * 3.0 + time);
    float pattern = mix(core, arms, 0.5 + 0.5 * n);
    
    // Color palette: mix deep cosmic blue with radiant orange, modulated by pattern and noise
    vec3 deepBlue = vec3(0.05, 0.1, 0.3);
    vec3 radiantOrange = vec3(1.0, 0.7, 0.3);
    vec3 color = mix(deepBlue, radiantOrange, pattern);
    
    // Further modulate brightness by noise for dynamic shimmer effect
    color += 0.15 * vec3(n);
    
    gl_FragColor = vec4(color, 1.0);
}