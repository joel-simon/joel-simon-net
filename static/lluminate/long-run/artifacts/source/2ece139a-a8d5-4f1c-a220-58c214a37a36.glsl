precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Glitch offset to simulate error and random displacement
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = pseudoRandom(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch pattern: combines sine waves with random glitches
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float noise = smoothstep(0.3, 0.7, pseudoRandom(pos * t));
    return mix(stripes, noise, 0.3);
}

// Distorted circular pattern: creates a starburst effect with glitch borders
float distortedCircle(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float glitch = smoothstep(0.0, 1.0, pseudoRandom(vec2(angle * 3.0, t)));
    float circle = smoothstep(0.4 + glitch * 0.1, 0.41 + glitch * 0.1, radius);
    return circle;
}

// Swirling wave effect based on polar coordinates and sine manipulation
float swirlingWave(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float wave = sin(radius * 20.0 - t * 5.0 + angle * 5.0);
    return smoothstep(0.0, 0.1, abs(wave));
}

// Color modulation that blends cosmic and glitch aesthetics together
vec3 colorModulation(vec2 pos, float t) {
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    float glitchPattern = stripedGlitch(pos, t);
    float circlePattern = distortedCircle(pos, t);
    float wavePattern = swirlingWave(pos, t);
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    vec3 colorC = vec3(0.4, 0.4, 0.9);
    
    vec3 mix1 = mix(colorA, colorB, glitchPattern);
    vec3 mix2 = mix(mix1, colorC, wavePattern);
    vec3 finalColor = mix(mix2, vec3(0.0), circlePattern);
    
    // Additional noise perturbation for organic error
    finalColor.r += (pseudoRandom(pos + t) - 0.5) * 0.1;
    finalColor.g += (pseudoRandom(pos - t) - 0.5) * 0.1;
    finalColor.b += (pseudoRandom(pos * 1.5) - 0.5) * 0.1;
    
    return finalColor;
}

void main() {
    vec2 pos = uv;
    
    // Apply a slight rotation to infuse dynamic movement
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle), cos(angle));
    pos = rot * pos;
    
    float glitch = stripedGlitch(pos, time);
    float circle = distortedCircle(pos, time);
    float wave = swirlingWave(pos, time);
    
    // Combine patterns: cosmic starburst, glitch art, and swirling waves
    float pattern = glitch + circle + wave;
    vec3 color = colorModulation(pos, time);
    
    // Modulate brightness based on the composite pattern intensity
    color *= mix(0.8, 1.2, pattern);
    
    gl_FragColor = vec4(color, 1.0);
}