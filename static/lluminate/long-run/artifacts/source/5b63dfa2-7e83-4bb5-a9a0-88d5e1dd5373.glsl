precision mediump float;
varying vec2 uv;
uniform float time;

// 2D hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Smooth noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Swirl distortion for organic flow
vec2 swirl(vec2 p, float strength) {
    float angle = strength * length(p);
    float s = sin(angle);
    float c = cos(angle);
    mat2 m = mat2(c, -s, s, c);
    return m * p;
}

// Reverse warp for digital glitch style
vec2 reverseWarp(vec2 p, float t) {
    float n = noise(p * 5.0 - t);
    float angle = n * 6.2831;
    mat2 rot = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
    return rot * p * (0.8 + 0.2 * n);
}

// Heart shape signed distance function (symbol for love/resilience)
float heartShape(vec2 p) {
    p.y -= 0.25;
    float a = atan(p.x, p.y);
    float r = length(p);
    // Use sinusoidal modulation for a digital glitch effect
    float heart = pow(r, 2.0) - 0.5 * sin(time + a * 4.0);
    return heart;
}

// Quantize function for digital grid effect
float quantize(float val, float levels) {
    return floor(val * levels) / levels;
}

void main() {
    // Normalize coordinates to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply swirl for organic distortions
    float swirlStrength = sin(time * 0.5) * 1.0;
    vec2 distorted = swirl(pos, swirlStrength);
    
    // Create background using fractal noise
    float bg = fbm(distorted * 2.5 + time * 0.3);
    
    // Use reverse warp for digital glitch fragmentation overlay
    vec2 glitchPos = reverseWarp(pos, time * 0.5);
    float glitchNoise = fbm(glitchPos * 3.0 + time * 0.2);
    glitchNoise = quantize(glitchNoise, 8.0);
    
    // Create a heart mask to represent resilience (symbol replacement)
    float h = heartShape(distorted * 1.2);
    float heartMask = smoothstep(0.03, 0.0, abs(h));
    
    // Combine layers: organic background, digital glitch grid, and heart symbol
    vec3 colorBackground = vec3(0.05, 0.02, 0.1) + vec3(bg * 0.3);
    vec3 glitchColor = vec3(glitchNoise * 0.6 + 0.2, glitchNoise * 0.3 + 0.1, 1.0 - glitchNoise);
    
    // Pulsating effect for the heart symbol
    float pulse = 0.5 + 0.5 * sin(time * 2.0);
    vec3 heartColor = vec3(1.0, 0.2, 0.4) * pulse;
    
    // Mix glitch and background conditionally based on a grid overlay
    vec2 grid = abs(fract((pos + 1.0) * 5.0 - time * 0.3) - 0.5);
    float gridLine = smoothstep(0.48, 0.5, min(grid.x, grid.y));
    vec3 baseLayer = mix(colorBackground, glitchColor, step(0.5, gridLine));
    
    // Overlay the heart shape with the digital glitch treatment
    vec3 finalColor = mix(baseLayer, heartColor, heartMask);
    
    // Final vignette effect for focus
    float vignette = smoothstep(1.2, 0.3, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}