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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fractalNoise(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
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
    // Normalize and center coordinates
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply a kaleidoscopic effect using polar coordinates
    float angle = atan(p.y, p.x);
    float radius = length(p);
    
    // Create a kaleidoscopic symmetry by modulating angle in sectors
    float sectors = 8.0;
    angle = mod(angle, 6.28318 / sectors) * sectors;
    
    // Dynamic, swirling organic distortion based on radius and fractal noise
    float swirl = sin(radius * 12.0 - time * 2.5 + fractalNoise(p * 3.5) * 8.0);
    angle += swirl * 0.25;
    
    // Convert polar back to Cartesian coordinates with distortion
    vec2 coord = vec2(cos(angle), sin(angle)) * radius;
    
    // Layer multiple noise patterns for complexity
    float n1 = fractalNoise(coord * 5.0 + time * 0.7);
    float n2 = fractalNoise(coord * 10.0 - time * 1.3);
    float blend = mix(n1, n2, 0.5 + 0.5 * sin(time + radius * 3.0));
    
    // Radial gradient for depth effect
    float radial = smoothstep(0.8, 0.2, radius);
    
    // Create a dynamic color palette shifting over time
    vec3 color = palette(blend, vec3(0.5, 0.4, 0.3),
                             vec3(0.5, 0.6, 0.7),
                             vec3(1.0, 0.8, 0.6),
                             vec3(time * 0.1, time * 0.15, time * 0.05));
    
    // Mix with additional color layer based on radial fade
    color = mix(color, vec3(0.2, 0.1, 0.3), 1.0 - radial);
    
    // Final vignette effect to draw focus toward the center
    float vignette = smoothstep(0.9, 0.3, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}