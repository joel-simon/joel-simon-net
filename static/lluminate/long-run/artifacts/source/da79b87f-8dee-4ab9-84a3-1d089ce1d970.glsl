precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function from coordinates
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Basic 2D noise function using bilinear interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

// Swirl function for twisting distortions
vec2 swirl(vec2 pos, float amt) {
    float len = length(pos);
    float angle = amt * len;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Grid function to create a digital glitch pattern
float glitchGrid(vec2 pos, float freq) {
    vec2 grid = fract(pos * freq);
    float line = smoothstep(0.48, 0.5, abs(grid.x - 0.5)) * smoothstep(0.48, 0.5, abs(grid.y - 0.5));
    return line;
}

// Concept 1: Cosmic Radiance - swirling starburst centered on the screen
float cosmicEffect(vec2 pos) {
    vec2 centered = pos - 0.5;
    float radius = length(centered) * 2.0;
    float angle = atan(centered.y, centered.x);
    float stars = abs(cos(10.0 * angle + time * 1.5));
    return smoothstep(0.7, 0.4, radius) * stars;
}

// Concept 2: Fluid Dynamics - organic wave and ripple interference
float fluidEffect(vec2 pos) {
    vec2 waves = pos * 10.0;
    float ripple = sin(waves.x + time) * cos(waves.y + time);
    float n = noise(pos * 8.0 + time * 0.5);
    return smoothstep(0.3, 0.5, ripple + n * 0.5);
}

void main(void) {
    vec2 pos = uv;
    
    // Map and twist the input coordinates differently for each conceptual space
    vec2 cosmicUV = swirl(pos - 0.5, 2.0 * sin(time * 0.7)) + 0.5;
    vec2 fluidUV = swirl(pos, -1.5 * cos(time * 0.9));
    
    // Compute each conceptual space's effect
    float cosmic = cosmicEffect(cosmicUV);
    float fluid = fluidEffect(fluidUV);
    
    // Map cross space: selectively blend using a noise factor to interpolate between them
    float blendFactor = smoothstep(0.3, 0.7, noise(pos * 5.0 + time));
    float emergent = mix(cosmic, fluid, blendFactor);
    
    // Develop emergent properties: add a digital glitch overlay that doesn't naturally occur in either space
    float glitch = glitchGrid(pos, 30.0) * noise(vec2(time, pos.y*20.0));
    
    // Final color composition: cosmic hues blended with fluid organic tones and a digital glitch highlight
    vec3 cosmicColor = vec3(0.1, 0.15, 0.35);
    vec3 fluidColor = vec3(0.05, 0.6, 0.8);
    vec3 emergentColor = mix(cosmicColor, fluidColor, emergent);
    
    // Overlay glitch: making the emergent color flicker with digital precision
    emergentColor = mix(emergentColor, vec3(0.9, 0.9, 0.9), glitch);
    
    gl_FragColor = vec4(emergentColor, 1.0);
}