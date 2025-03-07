precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Basic noise function (interpolated)
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Digital grid glitch effect by pixelating uv coordinates
vec2 glitchGrid(vec2 pos, float scale) {
    pos *= scale;
    pos = floor(pos) / scale;
    return pos;
}

// Rotational transformation without organic curves
vec2 digitalSwirl(vec2 pos, float amt) {
    float angle = amt * 3.1415 * 2.0;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

void main() {
    // Shift uv coordinates to center and magnify digital grid
    vec2 pos = uv;
    vec2 centered = pos - 0.5;
    
    // Create a digital pixel grid pattern by quantizing the uv coordinates
    vec2 gridPos = glitchGrid(pos, 20.0);
    
    // Apply a time-evolving digital swirl to the centered coordinates
    vec2 swirlPos = digitalSwirl(centered, sin(time * 0.5));
    
    // Generate fractal noise for a digital static effect
    float fractalNoise = fbm(pos * 5.0 + time);
    float staticNoise = noise(pos * 50.0 - time);
    
    // Create a hard edge grid overlay using step functions
    vec2 grid = fract(fract(pos * 20.0));
    float gridMask = step(0.02, grid.x) * step(0.02, grid.y);
    
    // Color gradients representing digital data streams contrasted with pixels
    vec3 colorDigital = vec3(0.0, 0.7, 1.0) * fractalNoise;
    vec3 colorStatic = vec3(0.8, 0.2, 0.9) * staticNoise;
    
    // Combine digital swirl effect with grid overlay
    float swirlFactor = smoothstep(0.3, 0.5, length(swirlPos));
    vec3 colorMix = mix(colorDigital, colorStatic, swirlFactor);
    colorMix += gridMask * 0.3;
    
    // Introduce a digital glitch: offset color channels based on noise
    float glitch = noise(pos * 30.0 + time);
    vec3 glitchOffset = vec3(glitch * 0.1, -glitch * 0.1, glitch * 0.05);
    
    gl_FragColor = vec4(colorMix + glitchOffset, 1.0);
}