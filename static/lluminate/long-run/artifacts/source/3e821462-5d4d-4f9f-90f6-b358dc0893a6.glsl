precision mediump float;
varying vec2 uv;
uniform float time;

// "Honor thy error as a hidden intention" directive inspires intentional imperfections.

// Pseudo-random noise function
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Error-inspired jitter: creates unexpected offsets
vec2 jitter(vec2 p, float t) {
    float n = noise(p + t);
    return p + vec2(sin(n * 100.0), cos(n * 100.0)) * 0.005;
}

// Rotates a 2D vector by an angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Generates a "glitch" pattern: a burst of raw, offset lines.
float glitchBurst(vec2 p, float t) {
    float lines = step(0.98, fract(p.y * 50.0 + t * 10.0));
    float intensity = smoothstep(0.2, 0.4, abs(sin(p.x * 30.0 + t)));
    return lines * intensity;
}

// Creates an organic swirling distortion as if errors bleed into the scene.
float errorSwirl(vec2 p, float t) {
    vec2 centered = p - 0.5;
    float angle = length(centered) * 10.0 + t * 2.0;
    float swirl = sin(atan(centered.y, centered.x) * 3.0 + angle);
    return smoothstep(0.4, 0.42, abs(swirl));
}

// Color blending based on chaotic interactions between directed error and randomness.
vec3 chaoticColor(vec2 p, float t) {
    float base = noise(p * 10.0 + vec2(t * 0.1));
    float swirl = errorSwirl(p, t);
    float burst = glitchBurst(p, t);
    
    vec3 colA = vec3(0.1, 0.3, 0.7);
    vec3 colB = vec3(0.8, 0.2, 0.5);
    vec3 mixed = mix(colA, colB, base);
    
    mixed += vec3(swirl, burst, swirl * burst) * 0.5;
    return mixed;
}

void main() {
    vec2 p = uv;
    
    // Apply jitter to simulate "honoring errors"
    p = jitter(p, time);
    
    // Rotate coordinates in a subtle, chaotic variation
    vec2 centered = p - 0.5;
    centered = rotate(centered, sin(time) * 0.5);
    p = centered + 0.5;
    
    // Overlay a grid to contrast digital precision with organic error
    vec2 gridUV = fract(p * 15.0);
    float grid = step(0.95, length(gridUV - 0.5));
    
    // Synthesize meaningful chaos using swirling error and burst patterns
    vec3 colorResult = chaoticColor(p, time);
    float blend = errorSwirl(p, time) + glitchBurst(p, time);
    
    vec3 finalColor = mix(colorResult, vec3(0.0), blend * 0.7);
    finalColor += grid * 0.1;
    
    gl_FragColor = vec4(finalColor, 1.0);
}