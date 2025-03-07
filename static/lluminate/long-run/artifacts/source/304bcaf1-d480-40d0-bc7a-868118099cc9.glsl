precision mediump float;
varying vec2 uv;
uniform float time;

// Basic hash function for randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++){
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Polar transformation functions
vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

vec2 fromPolar(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

// Organic circuit function with swirling arms
float organicCircuit(vec2 p) {
    p = (p - 0.5) * 2.0;
    vec2 polar = toPolar(p);
    float arms = sin(polar.y * 3.0 + time + fbm(p * 3.0));
    float branch = smoothstep(0.1 + 0.3 * arms, 0.12 + 0.3 * arms, polar.x);
    return branch;
}

// Heart shape implicit function
float heartShape(vec2 p) {
    vec2 pos = (p - vec2(0.5, 0.4)) * 2.0;
    float x = pos.x;
    float y = pos.y;
    return pow(x*x + y*y - 1.0, 3.0) - x*x*y*y*y;
}

// Glitch distortion using fbm and time
vec2 glitchWarp(vec2 p) {
    float n = fbm(p * 8.0 + time * 0.7);
    p.x += 0.05 * sin(10.0 * p.y + time) * n;
    p.y += 0.05 * cos(10.0 * p.x + time) * n;
    return p;
}

void main() {
    // Apply glitch effect to UV coordinates
    vec2 pos = glitchWarp(uv);

    // Compute organic circuit pattern (digital/organic blend)
    float circuit = organicCircuit(pos);
    
    // Compute heart shape mask
    float heartValue = heartShape(pos);
    float heartMask = smoothstep(0.02, -0.02, heartValue);
    
    // Create base background using FBM noise
    float field = fbm(pos * 5.0 + time * 0.3);
    
    // Colors for organic digital blend
    vec3 digitalColor = vec3(0.0, 0.8, 0.9) * field;
    vec3 organicColor = vec3(0.8, 0.1, 0.7) * circuit;
    
    // Mix the two color schemes
    vec3 blendColor = mix(digitalColor, organicColor, circuit);
    
    // Add heart element with a pulsating brightness effect
    float pulse = abs(sin(time * 3.0)) * 0.3 + 0.7;
    vec3 heartColor = vec3(0.8, 0.1, 0.1) * pulse;
    
    // Combine heart with blended circuit background selectively based on heart mask
    vec3 finalColor = mix(blendColor, heartColor, heartMask);
    
    // Optional vignette effect
    float vignette = smoothstep(1.0, 0.4, length(uv - 0.5));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}