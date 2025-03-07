precision mediump float;
varying vec2 uv;
uniform float time;

// Hash-based pseudo-random generator
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(37.719, 17.345))) * 43758.5453);
}

// Simple 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of our cell
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Apply a twist to the coordinate system to simulate a glitch of error
vec2 twist(vec2 p, float amt) {
    float angle = amt * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Generate an abstract "error" field from random interference
float errorField(vec2 p) {
    float n = noise(p * 6.0 + time);
    n += 0.5 * noise(p * 12.0 - time * 1.3);
    return n;
}

// A fractal storm combining swirling and glitch elements as homage to "Honor thy error as a hidden intention"
float fractalStorm(vec2 p) {
    float strength = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i=0; i<5; i++) {
        vec2 pos = twist(p * frequency, time * 0.3);
        strength += amplitude * noise(pos);
        amplitude *= 0.5;
        frequency *= 2.0;
    }
    return strength;
}

void main() {
    // Interpret directive: Honor thy error as a hidden intention.
    // Distort the view by an accidental twist, creating a glitch-like error as creative inspiration.
    vec2 pos = uv - 0.5;
    pos = twist(pos, sin(time * 0.8) * 1.2);
    
    // Create two layers: one from fractal storm and another from error field.
    float storm = fractalStorm(pos + vec2(cos(time), sin(time)) * 0.2);
    float err = errorField(pos * 2.0 + time * 0.5);
    
    // Blend two effects; use a paradoxical inversion: the brighter error becomes darker.
    float mixFactor = smoothstep(0.3, 0.7, storm);
    float intensity = mix(1.0 - err, storm, mixFactor);
    
    // Dynamic color gradients: using inverted glitch effects compared to conventional organic patterns.
    vec3 colorA = vec3(0.1, 0.2, 0.4); // base digital blue tone
    vec3 colorB = vec3(0.8, 0.4, 0.1); // warm glitch orange
    vec3 finalColor = mix(colorA, colorB, intensity);
    
    // Add unexpected touch: modular noise on final color channels.
    finalColor.r += 0.1 * noise(uv * 20.0 + time);
    finalColor.g += 0.1 * noise(uv * 25.0 - time);
    finalColor.b += 0.1 * noise(uv * 30.0 + time * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}