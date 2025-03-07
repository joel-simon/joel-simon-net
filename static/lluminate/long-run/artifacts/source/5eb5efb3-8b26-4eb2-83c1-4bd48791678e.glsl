precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// A noise function based on pseudoRandom
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Rotate point by given angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x*c - p.y*s, p.x*s + p.y*c);
}

// Starburst effect with glitch overlay
float starburst(vec2 pos, float t) {
    // convert to polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Base burst: use sinusoidal variations to create star rays. Reverse wave phase.
    float rays = abs(sin(8.0 * angle - t));
    float burst = smoothstep(0.4, 0.38, radius + rays * 0.15);
    
    // Apply glitch distortion based on noise
    float glitch = noise(pos * 10.0 + t);
    burst += glitch * 0.2;
    
    return clamp(burst, 0.0, 1.0);
}

// Cosmic swirl: combine radial glitch star with soft organic swirl
float cosmicSwirl(vec2 pos, float t) {
    // Inverse radial modulation for swirling effect (Reverse: use 1.0 - radius)
    float radius = length(pos);
    float swirl = smoothstep(0.5, 0.45, 1.0 - radius + 0.2 * sin(5.0 * pos.x + t));
    
    // Add starburst overlay
    float burst = starburst(pos, t);
    
    return mix(swirl, burst, 0.6);
}

void main() {
    // Center UV coordinates
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply a rotation to the entire scene for dynamic effect
    pos = rotate(pos, time * 0.3);
    
    // Apply a combination of cosmic and glitch operations
    float effect = cosmicSwirl(pos, time);
    
    // Color synthesis: Substitute standard cosmic colors with reversed gradients 
    // and magnify glitch artifacts.
    vec3 cosmicColor = mix(vec3(0.05, 0.02, 0.15), vec3(0.45, 0.2, 0.9), effect);
    vec3 glitchColor = mix(vec3(0.9, 0.3, 0.1), vec3(0.2, 0.7, 0.5), noise(pos * 15.0 + time));
    
    // Combine the colors using a SCAMPER inspired mix, eliminating sharp differences.
    vec3 finalColor = mix(cosmicColor, glitchColor, smoothstep(0.3, 0.7, effect));
    
    gl_FragColor = vec4(finalColor, 1.0);
}