precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
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

// Fractal Brownian Motion (fbm) function
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

// Glitch offset function to add error-like shifts
vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

// Mirror distortion effect to reverse coordinate assumptions
vec2 mirror(vec2 p) {
    return abs(p - 0.5) + 0.5;
}

void main(void) {
    // Begin with the raw uv coordinates and apply mirroring
    vec2 mUV = mirror(uv);
    
    // Offset the coordinate space for swirling effects and glitch alterations
    vec2 pos = (mUV - 0.5) * 2.0;
    pos += glitchOffset(pos);
    
    // Convert to polar coordinates for swirling and starburst effects
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create dynamic swirl by modulating angle with noise-driven warps
    float warp = fbm(mUV * 3.0 + time);
    angle += warp * 6.2831;
    
    // Combine ripple effect modulated by sine functions and fbm noise
    float burst = abs(sin(10.0 * angle + time * 3.0));
    float ripple = smoothstep(0.5, 0.48, radius) * burst;
    
    // Overlay glitch error bands across the scene
    float glitchBand = smoothstep(0.02, 0.03, abs(sin(pos.y * 50.0 + time * 10.0)));
    
    // Synthesize color palettes using fbm noise and glitch artifacts
    vec3 baseColor = mix(vec3(0.1, 0.3, 0.7), vec3(1.0, 0.5, 0.2), noise(pos * 4.0 + time * 0.7));
    vec3 glitchColor = mix(baseColor, vec3(0.8, 0.8, 0.8), glitchBand);
    vec3 finalColor = mix(glitchColor, vec3(1.0, 0.9, 0.4), ripple);
    
    // Introduce additional color modulation based on fbm patterns
    vec3 colorA = vec3(0.2 + 0.8 * fbm(mUV * 8.0 + time));
    vec3 colorB = vec3(0.8 * fbm(mUV * 15.0 - time));
    float mixFactor = step(0.4, fbm(mUV * 5.0));
    finalColor = mix(finalColor, mix(colorA, colorB, mixFactor), 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}