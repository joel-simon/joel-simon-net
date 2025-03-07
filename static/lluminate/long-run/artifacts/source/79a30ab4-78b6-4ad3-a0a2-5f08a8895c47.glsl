precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// 2D Noise function
float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    // Smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Organic blob: simulating the fluid, pulsating shape
float organicBlob(vec2 p, float t) {
    // Distort coordinates with noise for organic variance
    float n = noise(p * 3.0 + t * 0.5);
    float d = length(p - vec2(0.5)) + 0.2 * n;
    return smoothstep(0.28, 0.30, d);
}

// Digital glitch effect: simulating circuit traces or pixel displacement
vec2 glitch(vec2 p, float t) {
    // Create a grid of glitches using noise
    float grid = floor(p.x * 20.0) + floor(p.y * 20.0);
    float glitchVal = mod(grid + floor(t*10.0), 2.0);
    // Displace coordinates when glitch is active
    if (glitchVal < 1.0) {
        p.x += 0.03 * sin(50.0 * p.y + t * 10.0);
        p.y += 0.03 * cos(50.0 * p.x + t * 10.0);
    }
    return p;
}

void main() {
    // Combine two unrelated concepts: organic pulsation and digital glitch circuit
    vec2 pos = uv;
    
    // Apply digital glitch distortion to the coordinates
    pos = glitch(pos, time);
    
    // Apply a zooming effect that modulates like an organic growth cycle
    float zoom = 1.0 + 0.2 * sin(time * 1.2);
    pos = (pos - 0.5) * zoom + 0.5;
    
    // Primary organic element: fluid, pulsating blob
    float blob = organicBlob(pos, time);
    
    // Background digital aesthetic: circuit-like grid overlay with noise
    float grid = smoothstep(0.45, 0.5, abs(sin((pos.x + pos.y + time) * 20.0)));
    float circuit = mix(0.0, grid, 0.5 + 0.5 * sin(time*3.0));
    
    // Synthesize organic and digital components
    vec3 organicColor = vec3(0.1, 0.6, 0.3) * blob;
    vec3 digitalColor = vec3(0.2, 0.3, 0.8) * circuit;
    
    // Blend colors based on blob mask and add slight glow effect
    vec3 color = mix(digitalColor, organicColor, blob);
    color += 0.1 * blob * vec3(0.8, 0.9, 1.0);
    
    gl_FragColor = vec4(color, 1.0);
}