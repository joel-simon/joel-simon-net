precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash noise function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// Smooth noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i), hash(i+vec2(1.0,0.0)), u.x),
               mix(hash(i+vec2(0.0,1.0)), hash(i+vec2(1.0,1.0)), u.x), u.y);
}

// Fractal Brownian Motion for organic patterns
float fbm(vec2 p) {
    float total = 0.0, amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Digital glitch: shifting uv coordinates based on noise and time
vec2 glitch(vec2 p, float intensity) {
    float shiftX = noise(vec2(p.y * 10.0, time)) - 0.5;
    float shiftY = noise(vec2(p.x * 10.0, time * 1.1)) - 0.5;
    return p + vec2(shiftX, shiftY) * intensity;
}

// Emergence: blend two conceptual spaces based on a smooth step function
vec3 emergentScene(vec2 st) {
    // Organic space: using fbm to generate a fluid natural background
    float organic = fbm(st * 3.0 + time * 0.3);
    vec3 organicColor = mix(vec3(0.1, 0.4, 0.1), vec3(0.4, 0.8, 0.4), organic);
    
    // Digital space: harsh glitchy effects using noise and deliberate color shifts
    vec2 distorted = glitch(st, 0.15);
    float digital = noise(distorted * 20.0 + time * 2.0);
    vec3 digitalColor = mix(vec3(0.0, 0.0, 0.0), vec3(0.8, 0.2, 0.6), digital);
    
    // Map crossspace: Define blend factor based on horizontal position and time modulation
    float blend = smoothstep(-0.3, 0.3, st.x + 0.2*sin(time));
    
    // Mix the two conceptual spaces to form an emergent unique scene
    return mix(organicColor, digitalColor, blend);
}

void main() {
    // Normalize coordinates: center the geometry
    vec2 st = uv * 2.0 - 1.0;
    
    // Enhance circular vignette effect
    float d = length(st);
    float vignette = smoothstep(1.0, 0.4, d);
    
    // Create the emergent structure by blending two spaces
    vec3 color = emergentScene(st);
    
    // Add subtle additional glitch stripes for digital texture overlay
    float stripes = step(0.8, fract(uv.y * 30.0 + time * 3.0));
    color = mix(color, vec3(0.0), stripes * 0.2);
    
    // Apply vignette to focus the composition
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}