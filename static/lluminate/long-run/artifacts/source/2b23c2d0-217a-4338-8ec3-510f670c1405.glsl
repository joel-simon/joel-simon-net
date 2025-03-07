precision mediump float;
varying vec2 uv;
uniform float time;

// Random function based on uv coordinates
float getRandom(vec2 st) {
    return fract(sin(dot(st, vec2(127.1, 311.7))) * 43758.5453123);
}

// Simple 2D noise based on smoothing random values
float getNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = getRandom(i);
    float b = getRandom(i + vec2(1.0, 0.0));
    float c = getRandom(i + vec2(0.0, 1.0));
    float d = getRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Convert cartesian to polar coordinates
vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

// Convert polar to cartesian
vec2 toCartesian(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

// Swirl distortion function: creates an organic twisting effect
vec2 swirl(vec2 p, float strength) {
    vec2 polar = toPolar(p);
    polar.y += strength / (polar.x + 0.5);
    return toCartesian(polar);
}

void main() {
    // Center UV coordinates to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a swirling distortion whose strength oscillates over time
    float swirlStrength = sin(time * 0.8) * 0.5;
    vec2 distortedPos = swirl(pos, swirlStrength);
    
    // Generate fractal noise layers for an evolving organic texture
    float f = 0.0;
    float amp = 1.0;
    vec2 nPos = distortedPos * 2.0;
    for (int i = 0; i < 6; i++) {
        f += amp * getNoise(nPos + vec2(time * 0.3));
        nPos *= 1.7;
        amp *= 0.5;
    }
    
    // Introduce glitch-like stripes using high-frequency noise and modulus offset
    float stripes = smoothstep(0.45, 0.55, abs(fract(distortedPos.x * 10.0 + time * 2.0) - 0.5));
    float glitch = step(0.98, getRandom(uv * time)) * 0.3;
    
    // Dynamic coloring: Base color modulated with time, noise, and swirl distortion
    vec3 baseColor = vec3(0.1, 0.05, 0.2);
    vec3 colorOffset = vec3(0.5 * sin(time + f), 0.5 * cos(time + f * 1.2), 0.5 * sin(time * 1.5 + f * 0.8));
    
    vec3 finalColor = baseColor + colorOffset;
    
    // Layer the glitch and stripes over the organic texture
    finalColor += stripes * vec3(0.2, 0.1, 0.3);
    finalColor += glitch;
    
    // Apply a vignette effect based on distance from center
    float vignette = smoothstep(1.0, 0.2, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}