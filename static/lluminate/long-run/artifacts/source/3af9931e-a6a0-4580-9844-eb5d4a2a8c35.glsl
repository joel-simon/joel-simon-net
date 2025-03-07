precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Swirling cosmic background
vec3 cosmicBackground(vec2 st) {
    st *= 2.0;
    float r = length(st);
    float a = atan(st.y, st.x);
    float swirl = sin(8.0 * r - time * 1.2 + a * 3.0);
    float starField = step(0.98, fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123));
    vec3 baseColor = mix(vec3(0.02, 0.03, 0.1), vec3(0.1, 0.05, 0.2), 0.5 + 0.5 * swirl);
    return baseColor + vec3(starField);
}

// Digital glitch pattern using reversed noise and sinusoidal grid.
vec3 digitalGlitch(vec2 st) {
    // Reverse uv coordinates for a novel twist.
    vec2 ruv = 1.0 - st;
    // Sinusoidal grid distortion.
    float grid = abs(sin(ruv.x * 50.0 + time)) * abs(sin(ruv.y * 50.0 - time));
    // Invert noise pattern for glitch.
    float n = 1.0 - noise(ruv * 10.0 + time);
    // Combine glitch aspects.
    float glitch = smoothstep(0.7, 1.0, grid * n);
    vec3 glitchColor = mix(vec3(0.2, 0.8, 0.6), vec3(0.9, 0.3, 0.4), glitch);
    return glitchColor;
}

// Organic fractal growth using iterative noise.
vec3 organicGrowth(vec2 st) {
    float amplitude = 0.5;
    float frequency = 1.0;
    float accum = 0.0;
    for (int i = 0; i < 6; i++) {
        accum += amplitude * noise(st * frequency + time * 0.3);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    vec3 organic = vec3(0.1 + 0.7 * sin(accum + st.xyx * 3.1415));
    return organic;
}

void main() {
    // Normalize uv to [-1,1] coordinate space.
    vec2 st = uv * 2.0 - 1.0;
    
    // Cosmic background with swirling galaxy effect.
    vec3 cosmic = cosmicBackground(st);
    
    // Apply organic fractal growth patterns to simulate nature.
    vec3 organic = organicGrowth(st * 1.5);
    
    // Digital glitch pattern overlay.
    vec3 glitch = digitalGlitch(uv);
    
    // Combine using SCAMPER-inspired transformations:
    // Substitute organic texture to replace parts of cosmic backdrop.
    // Combine glitch pattern with organic growth.
    // Reverse uv in glitch adds twist.
    vec3 combined = mix(cosmic, organic, 0.4);
    combined = mix(combined, glitch, 0.3 + 0.3 * sin(time * 0.8));
    
    gl_FragColor = vec4(combined, 1.0);
}