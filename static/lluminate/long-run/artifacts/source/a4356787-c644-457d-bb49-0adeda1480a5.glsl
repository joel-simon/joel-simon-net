precision mediump float;
varying vec2 uv;
uniform float time;

// --------------------------------------------------------------
// draw_random_card: "Honor thy error as a hidden intention."
// interpret_directive: Embrace mistakes and transform them into a feature.
// apply_insight: Create deliberate distortions using noise and non-linear transforms.
// --------------------------------------------------------------

// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion (FBM)
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Distortion effect that emulates "glitchy errors"
vec2 errorDistort(vec2 p) {
    float n = noise(p * 10.0 + time);
    // Intentionally "mistaken" scaling using a non-linear perturbation.
    float factor = 0.03 * sin(15.0 * n + time * 3.0);
    return p + vec2(factor, -factor);
}

// Random swirl function with error-induced rotation
vec2 randomSwirl(vec2 p, float strength) {
    float len = length(p);
    // Using noise to modulate the swirling angle for an unpredictable twist
    float angle = strength * len + fbm(p * 2.0) * 3.1415;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
  
    // Apply error-inspired distortion first
    pos = errorDistort(pos);
  
    // Apply a dynamic, randomized swirl
    pos = randomSwirl(pos, 2.5 + sin(time * 1.5));
  
    // Create a radial pattern with intentional "mistakes"
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(8.0 * angle + time + fbm(pos * 4.0) * 6.28);
    
    // Define an organic, glitch-inspired shape
    float shape = smoothstep(0.4, 0.38, r + 0.25 * spiral);
  
    // Layer noise on top of the color for texture
    float texturedFBM = fbm(pos * 5.0 + time * 0.5);
    
    // Color creation: mix an ancient palette with modern glitches.
    vec3 baseColor = mix(vec3(0.05, 0.15, 0.45), vec3(0.9, 0.4, 0.2), texturedFBM);
    vec3 glitchHue = vec3(0.8, 0.85, 0.9) * abs(sin(time + angle));
    vec3 color = mix(baseColor, glitchHue, shape);
  
    // Add subtle radial vignetting using fbm as intentional error accent
    float vignette = smoothstep(1.2, 0.55, r + 0.3 * fbm(uv * 10.0));
    color *= vignette;
  
    gl_FragColor = vec4(color, 1.0);
}