precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
}

// 2D noise function with error-ish behavior
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Draws an "error" band pattern by offsetting coordinates unexpectedly
float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

// Applies a glitch offset based on a random phase
vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y*20.0), time));
    return vec2(offset*0.05, 0.0);
}

void main(void) {
    // Start with a base distorted UV coordinate space
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Random card: "Honor thy error as a hidden intention"
    // Interpret directive: Embrace the unexpected errors.
    // Apply insight: add random glitch offsets that disturb the smooth patterns.
    pos += glitchOffset(pos);
    
    // Create a swirling pattern by converting to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Use sinusoidal modulation to form chaotic, star-like bursts with error elements
    float burst = abs(sin(10.0*angle + time*3.0));
    float ripple = smoothstep(0.5, 0.48, radius) * burst;
    
    // Incorporating error bands across the image for glitch aesthetics
    float bands = errorBand(pos);
    
    // Combine noise and cosmic swirl; the noise here is treated as an "error" in the pattern
    float cosmicError = noise(pos * 4.0 + time*0.7);
    
    // Color gradients: vibrant yet unexpectedly clashing colors
    vec3 cosmicColor = mix(vec3(0.1, 0.3, 0.7), vec3(1.0, 0.5, 0.2), cosmicError);
    vec3 glitchColor = mix(cosmicColor, vec3(0.8, 0.8, 0.8), bands);
    
    // Final color composition using both swirl and glitch elements
    vec3 finalColor = mix(glitchColor, vec3(1.0, 0.9, 0.4), ripple);
    
    gl_FragColor = vec4(finalColor, 1.0);
}