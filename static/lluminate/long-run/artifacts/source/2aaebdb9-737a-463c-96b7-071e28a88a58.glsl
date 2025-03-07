precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453);
}

float radialGlow(vec2 p, float radius, float blur) {
    return smoothstep(radius, radius - blur, length(p));
}

void main() {
    // Merge two conceptual spaces: a swirling organic vortex and a structured grid.
    // Transform UV to center space [-1, 1]
    vec2 p = uv * 2.0 - 1.0;
    
    // First space: organic vortex using polar coordinates with swirling dynamics.
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float swirl = sin(angle * 4.0 + time + radius * 10.0);
    
    // Second space: structured grid.
    vec2 gridUV = fract(p * 5.0 + 0.5) - 0.5;
    float grid = smoothstep(0.45, 0.5, max(abs(gridUV.x), abs(gridUV.y)));
    
    // Map crossspace: generate interplay. Use pseudo noise on both spaces.
    float noise = pseudoNoise(p * 3.0 + time * 0.5);
    
    // Blend selectively: mix swirling vortex and grid.
    float blend = mix(swirl, grid, 0.5 + 0.5 * sin(time * 0.7));
    blend += noise * 0.1;
    
    // Develop emergent: create emergent glow and color dynamics.
    float glow = radialGlow(p, 0.5, 0.1) * 1.2;
    
    // Create an emergent color scheme by blending two distinct regimes.
    vec3 organicColor = vec3(0.8 + 0.2 * sin(time + angle), 0.4 + 0.3 * cos(time - radius), 0.5 + 0.5 * sin(radius - time));
    vec3 gridColor = vec3(0.2, 0.3, 0.5);
    
    vec3 color = mix(gridColor, organicColor, smoothstep(0.2, 0.8, blend));
    color += glow * vec3(0.3, 0.6, 0.9);
    
    gl_FragColor = vec4(color, 1.0);
}