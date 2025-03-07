precision mediump float;
varying vec2 uv;
uniform float time;

// Random function based on uv.
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function with bilinear interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Swirl function to rotate coordinates based on distance and time.
vec2 swirl(vec2 p, float intensity) {
    float angle = intensity * length(p) + time;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

// Cryptic directive: "Honor thy error as a hidden intention"
// We intentionally introduce a discontinuity in the spiral equation.
float brokenSpiral(vec2 p) {
    float r = length(p);
    // Introduce error near a specific radius
    float errorZone = smoothstep(0.3, 0.32, abs(r - 0.5));
    float spiral = sin(10.0 * (r + atan(p.y, p.x)) + time);
    // Use error as hidden intention: invert it
    return mix(spiral, -spiral, errorZone);
}

void main() {
    // Center UV coordinates around zero and scale to [-1,1]
    vec2 p = (uv - 0.5) * 2.0;
    
    // Distort coordinates with a swirling effect
    vec2 sp = swirl(p, 2.0);
    
    // Create a broken spiral pattern with hidden errors
    float pattern = brokenSpiral(sp);
    
    // Overlay some dynamic noise glitches
    float n = noise(p * 8.0 + time);
    float glitch = step(0.97, random(p * time)) * 0.3;
    
    // Dissolve the pattern with discontinuities
    float mask = smoothstep(0.1, 0.0, abs(pattern));
    
    // Create two color themes: one for the spiraling core and one for the chaotic glitches.
    vec3 coreColor = vec3(0.1, 0.6, 0.9) * (0.5 + 0.5 * sin(time + length(sp) * 10.0));
    vec3 glitchColor = vec3(0.9, 0.3, 0.4) * n;
    
    // Blend the two color schemes. The core pattern dominates, but glitches punctuate the scene.
    vec3 color = mix(glitchColor + glitch, coreColor, mask);
    
    gl_FragColor = vec4(color, 1.0);
}