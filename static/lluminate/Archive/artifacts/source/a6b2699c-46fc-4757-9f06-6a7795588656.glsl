precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
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
    vec2 p = uv * 2.0 - 1.0;
    
    // Begin with a base radial distortion
    float radius = length(p);
    float angle = atan(p.y, p.x);
    
    // Dynamic twisting using multi-scale noise and time offset
    float twist = fractalNoise(p * 3.0 + time * 0.5);
    float newAngle = angle + twist * 3.1416;
    
    // Offset in polar coordinates with extra time varying displacement
    vec2 pos = vec2(cos(newAngle), sin(newAngle)) * (radius + 0.2 * sin(time + radius * 10.0));
    
    // Additional warp effect with fractal noise layers
    float noiseLayer1 = fractalNoise(pos * 4.0 + 1.7 * time);
    float noiseLayer2 = fractalNoise(pos * 8.0 - time * 0.8);
    float combinedNoise = mix(noiseLayer1, noiseLayer2, 0.5);
    
    // Use combined noise to modify radial distance, creating organic rings
    float ring = smoothstep(0.2, 0.0, abs(radius - combinedNoise * 0.5));
    
    // Generate an evolving color palette
    vec3 col = palette(combinedNoise + time * 0.1, 
                       vec3(0.5, 0.4, 0.6),
                       vec3(0.5, 0.5, 0.5),
                       vec3(1.0, 0.7, 0.9),
                       vec3(time * 0.05, time * 0.1, time * 0.08));
                       
    // Overlay multiple layers with a soft vignette
    float vignette = smoothstep(0.8, 0.3, radius);
    col *= ring * vignette;
    
    gl_FragColor = vec4(col, 1.0);
}