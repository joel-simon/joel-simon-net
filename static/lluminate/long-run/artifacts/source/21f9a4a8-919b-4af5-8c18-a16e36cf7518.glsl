precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Improved noise function with smoothing
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Fractal Brownian Motion for organic detail
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Digital glitch grid function
float glitch(vec2 p, float t) {
    vec2 gridPos = fract(p * 20.0 - vec2(t * 2.0));
    float glitchLine = smoothstep(0.48, 0.5, abs(gridPos.x - 0.5));
    return glitchLine;
}

// Combine two conceptual spaces:
// Organic fractal wave interference with digital glitch fragmentation
void main() {
    vec2 st = uv * 2.0 - 1.0; // center coordinates
    
    // Organic space: smooth fractal pattern evolving over time
    float organic = fbm(st * 3.0 + time * 0.3);
    
    // Digital space: grid-based glitch overlay that distorts the organic wave
    float digital = glitch(st, time);
    
    // Map between two spaces:
    // The digital glitch modulates the fractal amplitude creating emergent patterns.
    float blend = mix(organic, 1.0 - organic, digital);
    
    // Apply a radial falloff to simulate an emergent sci-fi structure
    float radius = length(st);
    float emergent = blend * smoothstep(1.2, 0.3, radius);
    
    // Color palette shifts dynamically:
    vec3 colOrganic = vec3(0.2 + organic * 0.8, 0.1 + organic * 0.5, 0.6 + organic * 0.4);
    vec3 colDigital = vec3(digital, 0.3 * digital, 1.0 - digital);
    vec3 color = mix(colOrganic, colDigital, digital);
    
    // Final emergent effect: add a subtle time-based pulsation
    float pulse = 0.5 + 0.5 * sin(time * 2.0);
    color *= pulse;
    
    gl_FragColor = vec4(color, 1.0);
}