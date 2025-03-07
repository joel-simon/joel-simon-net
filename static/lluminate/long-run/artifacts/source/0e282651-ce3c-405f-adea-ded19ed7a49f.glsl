precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    // Transform uv coordinates to center-based coordinates, range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Compute polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Domain 1: The precision of mathematical spirals (e.g., Fibonacci and logarithmic spirals)
    // Construct a logarithmic spiral feature by modulating the angle with a logarithmic function 
    float spiral = cos(3.0 * log(r + 1.0) + angle - time * 1.5);
    
    // Domain 2: Digital glitch / pixel interference (unrelated domain: computer error aesthetics)
    // Create a glitch factor using a pseudo-random function that varies with time and angle segments 
    float glitch = step(0.8, pseudoRandom(vec2(angle * 5.0, floor(time))));
    // Mix in a flickering effect by modulating with a sine function based on time and radius
    float flicker = sin(time * 10.0 + r * 20.0);
    
    // Synthesize both domains: spiral and digital glitch, using smooth transitions 
    float mixFactor = smoothstep(0.2, 0.5, r);
    float combined = mix(spiral, flicker, mixFactor);
    combined += glitch * 0.3;
    
    // Color mixing: Map the combined effect into a color gradient that evolves with time
    vec3 colorA = vec3(0.1, 0.4, 0.7);
    vec3 colorB = vec3(0.8, 0.3, 0.2);
    vec3 color = mix(colorA, colorB, combined * 0.5 + 0.5);
    
    // Apply a radial vignette for depth
    float vignette = smoothstep(0.9, 0.2, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}