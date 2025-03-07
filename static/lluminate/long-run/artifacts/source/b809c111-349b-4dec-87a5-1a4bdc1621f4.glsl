precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(17.3, 43.7))) * 43758.5453);
}

vec3 glitchColor(vec2 coord, float t) {
    // Apply horizontal wave distortions and non-uniform color splits
    float n = pseudoNoise(coord * 40.0 + t);
    float r = pseudoNoise(coord + vec2(t * 0.15, 0.0));
    float g = pseudoNoise(coord + vec2(0.0, t * 0.2));
    float b = pseudoNoise(coord + vec2(-t * 0.15, t * 0.1));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.97, n);
    return mix(col, vec3(1.0), glitch);
}

void main() {
    // Center the uv coordinates
    vec2 pos = uv - 0.5;
    
    // Create a swirling vortex by adapting polar coordinates with a twist factor
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Reverse the typical spiral by modifying radius with time and angle
    float swirl = sin(8.0 * radius + time * 3.0 - angle * 3.0);
    
    // Substitute classical grid with a subtle wavy net based on sine function to replicate urban structure
    vec2 wave = sin(pos * 20.0 + time);
    float net = smoothstep(0.0, 0.05, abs(wave.x)) * smoothstep(0.0, 0.05, abs(wave.y));
    
    // Combine swirl and net patterns with a modification: mix nonlinearly based on radius
    float combined = mix(swirl, 1.0 - net, smoothstep(0.3, 0.6, radius));
    
    // Base color: adapt cosmic purple mixed with neon highlights that evolve with radius 
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.3), vec3(0.3, 0.9, 1.0), radius);
    
    // Superimpose glitch effects using reversed coordinates to add unexpected random artifacts
    vec3 glitch = glitchColor(pos * 3.0, time);
    
    // Integrate the patterns and glitch, applying SCAMPER operations:
    // Substitute grid with wavy net, combine swirl with glitch and adapt color scheme.
    vec3 color = mix(baseColor, glitch, 0.3) * (0.5 + 0.5 * combined);
    
    // Apply a fading vignette using the distance from center, reversing the usual vignette effect
    float vignette = smoothstep(0.6, 0.2, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}