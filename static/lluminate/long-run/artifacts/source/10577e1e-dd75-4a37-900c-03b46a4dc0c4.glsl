precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
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

// Swirling transformation function
vec2 swirl(vec2 pos, float amt) {
    float len = length(pos);
    float angle = amt * len;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

// Glitch offset function
vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply glitch offset to disturb the pattern
    pos += glitchOffset(pos);
    
    // Create a swirling coordinate transformation
    pos = swirl(pos, 3.0 + sin(time) * 2.0);
    
    // Compute distance and angle for radial effects
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Generate an organic burst effect with sine modulation based on angle and time
    float burst = abs(sin(10.0 * angle + time * 2.0));
    float ripple = smoothstep(0.45, 0.5, radius) * burst;
    
    // Generate FBM-based texture for background and depth
    float textureFBM = fbm(pos * 3.0 + time * 0.5);
    
    // Create an organic shape modulated by a wavy perturbation along polar coordinates
    float shape = length(pos / vec2(0.7 + 0.1 * sin(time), 0.5 + 0.1 * cos(time))) - 1.0;
    float shapeAlpha = smoothstep(0.02, -0.02, shape);
    
    // Color gradient mixing: base cosmic colors modulated by glitch and organic elements
    vec3 cosmicColor = mix(vec3(0.1, 0.3, 0.7), vec3(1.0, 0.5, 0.2), textureFBM);
    vec3 glitchColor = mix(cosmicColor, vec3(0.8, 0.8, 0.8), noise(pos * 10.0 + time));
    vec3 organicColor = mix(glitchColor, vec3(1.0, 0.9, 0.4), ripple);
    
    // Blend with the dynamic organic shape to produce focal reactive dynamics
    vec3 finalColor = mix(cosmicColor, organicColor, shapeAlpha);
    
    gl_FragColor = vec4(finalColor, 1.0);
}