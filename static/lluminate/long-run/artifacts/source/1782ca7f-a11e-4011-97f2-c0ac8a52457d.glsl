precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo random hash function based on sine and dot product
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Basic noise function with smooth interpolation
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

// Fractal Brownian Motion (fbm)
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

// Glitch distortion function using fbm noise and time modulation
vec2 glitch(vec2 p) {
    float n = fbm(p * 10.0 + time * 0.5);
    p.x += smoothstep(0.3, 0.7, n) * 0.04 * sin(time * 10.0);
    p.y += smoothstep(0.3, 0.7, n) * 0.04 * cos(time * 10.0);
    return p;
}

// Radial mask function: Creates a circular gradient from center
float radial(vec2 p) {
    vec2 centered = p - 0.5;
    return length(centered) * 2.0;
}

// Heart shape implicit function
float heartShape(vec2 p) {
    // Position adjustment to center the heart and scale it
    vec2 pos = (p - vec2(0.5, 0.4)) * 2.0;
    float x = pos.x;
    float y = pos.y;
    return pow(x*x + y*y - 1.0, 3.0) - x*x*y*y*y;
}

void main(void) {
    // Apply initial glitch distortion to uv coordinates
    vec2 pos = glitch(uv);
    
    // Compute the heart shape function value
    float d = heartShape(pos);
    // Smooth boundaries for the heart shape
    float heartEdge = smoothstep(0.02, -0.02, d);
    
    // Create a pulsating effect using sine wave
    float pulse = abs(sin(time * 3.0)) * 0.3 + 0.7;

    // Create a textural noise background using fbm on distorted coordinates
    float textureNoise = fbm(pos * 5.0 + time);
    
    // Dynamic color modulation for the heart using warm red and digital glitch white streaks
    vec3 heartColor = vec3(0.8, 0.1, 0.1) * pulse;
    vec3 glitchColor = vec3(1.0) * smoothstep(0.4, 0.6, textureNoise);
    vec3 colorMix = mix(heartColor, glitchColor, 0.3);
    
    // Introduce radial modulation for added depth
    float rad = radial(uv);
    colorMix *= smoothstep(1.0, 0.2, rad);
    
    // Blending with a subtle dark cosmic background modulated by noise
    vec3 bgColor = mix(vec3(0.02, 0.03, 0.05), vec3(0.0, 0.0, 0.02), fbm(uv * 3.0 + time*0.2));
    
    // Combine heart shape with the background based on heartEdge mask
    vec3 finalColor = mix(bgColor, colorMix, heartEdge);
    
    gl_FragColor = vec4(finalColor, 1.0);
}