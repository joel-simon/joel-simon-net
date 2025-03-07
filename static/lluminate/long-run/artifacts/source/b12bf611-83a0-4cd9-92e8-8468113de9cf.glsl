precision mediump float;
varying vec2 uv;
uniform float time;

// Reversed assumption: Instead of dynamic organic shapes, assume digital precision with fractal patterns.
// Use a pattern that disrupts expected smooth continuity.

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float digitalShape(vec2 pos) {
    // Rather than smooth organic curves, we create sharp glitchy boundaries
    // Reverse the idea of continuous transition by introducing step-like digital quantization.
    pos = pos * 10.0;
    vec2 grid = fract(pos);
    float lineX = step(0.1, abs(grid.x - 0.5));
    float lineY = step(0.1, abs(grid.y - 0.5));
    return lineX * lineY;
}

float fractalNoise(vec2 p) {
    float sum = 0.0;
    float amp = 1.0;
    for (int i = 0; i < 5; i++) {
        sum += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return sum;
}

void main(void) {
    // Reverse the usual mapping: use uv directly without centering.
    vec2 pos = uv;

    // "Digital glitch" effect: jump discontinuities by fractal quantization
    float glitch = step(0.85, fract(sin(time + pos.x * 25.0) * 43758.5453));
    
    // Dynamic fractal noise gives an unexpected structure to background.
    float fNoise = fractalNoise(pos * 3.0 + time * 0.5);
    // Invert noise to reverse the natural fade => emphasize contrast
    fNoise = 1.0 - fNoise;
    
    // Create a digital grid pattern that disrupts continuous form.
    float grid = digitalShape(uv);
    
    // Mix the two patterns by challenging the assumption of smooth blending.
    float mixFactor = step(0.5, fNoise) * glitch;
    float combined = mix(fNoise, grid, mixFactor);
    
    // Use a palette that swaps expected warm organic colors with a stark digital blue.
    vec3 colorOrganic = vec3(0.1, 0.1, 0.8) * combined;
    vec3 colorDigital = vec3(0.9, 0.1, 0.5) * (1.0 - combined);
    
    // Further challenge natural gradients by overlaying a reverse radial band.
    float radial = length(uv - vec2(0.5));
    radial = smoothstep(0.4, 0.0, radial); // reversed: higher in center
    
    vec3 finalColor = mix(colorDigital, colorOrganic, radial);
    
    gl_FragColor = vec4(finalColor, 1.0);
}