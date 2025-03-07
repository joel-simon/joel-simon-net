precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Glitch error function: offsets coordinates to simulate an "error" as hidden intention.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = pseudoRandom(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

// Striped pattern with random glitches.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float noise = smoothstep(0.3, 0.7, pseudoRandom(pos * t));
    return mix(stripes, noise, 0.3);
}

// Circular distorted background with glitchy borders.
float distortedCircle(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    // Introduce glitch effect by modulating the radius threshold with noise.
    float glitch = smoothstep(0.0, 1.0, pseudoRandom(vec2(angle, t)));
    float circle = smoothstep(0.4 + glitch * 0.1, 0.41 + glitch * 0.1, radius);
    return circle;
}

// Glitch-inspired color modulation based on error as hidden intention.
vec3 colorModulation(vec2 pos, float t) {
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    float stripes = stripedGlitch(pos, t);
    float circle = distortedCircle(pos, t);
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    // Mix colors based on the unexpected error textures
    vec3 color = mix(colorA, colorB, stripes);
    color = mix(color, vec3(0.0), circle);
    // Further perturb color channels based on pseudo random noise
    color.r += (pseudoRandom(pos + t) - 0.5) * 0.1;
    color.g += (pseudoRandom(pos - t) - 0.5) * 0.1;
    color.b += (pseudoRandom(pos * 1.5) - 0.5) * 0.1;
    return color;
}

void main() {
    // "Honor thy error as a hidden intention" inspires intentional glitches.
    vec2 pos = uv;
    // Apply a slight random rotation error for lateral thinking
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle), cos(angle));
    pos = rot * pos;
    
    // Synthesize multiple error-like patterns into a unified visual statement.
    float pattern = stripedGlitch(pos, time) + distortedCircle(pos, time);
    vec3 color = colorModulation(pos, time);
    
    // Final composition: modulate brightness with pattern intensity.
    color *= mix(0.8, 1.2, pattern);
    
    gl_FragColor = vec4(color, 1.0);
}