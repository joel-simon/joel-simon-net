precision mediump float;
varying vec2 uv;
uniform float time;

// 2D hash function based on sine and dot product
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function using smooth interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian motion for more complex noise
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Rotate 2D vector p by angle a
vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(p.x*c - p.y*s, p.x*s + p.y*c);
}

void main(void) {
    // Normalize coordinates to center at (0,0) and scale
    vec2 p = (uv - 0.5) * 2.0; 

    // Apply rotation over time to create a swirling vortex
    float angle = time * 0.5;
    p = rotate(p, angle);
    
    // Apply radial stretching to emphasize swirl effect
    float radius = length(p);
    float swirl = fbm(p * 3.0 + time);
    
    // Use SCAMPER operations: Substitute water/ocean with fiery cosmic vortex.
    // Combine fractal noise with swirling patterns to simulate a burning starburst.
    float intensity = smoothstep(0.8, 0.2, radius + swirl * 0.3);

    // Create secondary fractal layer that inverts near the core (Reverse operation)
    float core = 1.0 - smoothstep(0.0, 0.5, fbm(p * 6.0 - time));

    // Synthesize colors: switch from dark cosmic purple edges to fiery bright center.
    vec3 edgeColor = vec3(0.1, 0.0, 0.2);
    vec3 coreColor = vec3(1.0, 0.6, 0.1);
    
    // Additional flicker effect with sine modulation
    float flicker = abs(sin(time * 10.0 + radius * 20.0));
    
    // Blend colors from core to edge using intensity and integrate flicker
    vec3 color = mix(edgeColor, coreColor, intensity + core * 0.5);
    color += 0.15 * flicker;
    
    gl_FragColor = vec4(color, 1.0);
}