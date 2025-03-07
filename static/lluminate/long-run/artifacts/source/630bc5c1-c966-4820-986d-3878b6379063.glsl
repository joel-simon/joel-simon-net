precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random numbers
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// Noise function based on hash
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
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

// Mirror distortion effect
vec2 mirror(vec2 p) {
    return abs(p - 0.5) + 0.5;
}

// Core creative reversal: Instead of assuming linear mappings, we warp the entire coordinate space
void main() {
    // Reverse common assumption of smooth centered gradients by mirroring coordinates
    vec2 mUV = mirror(uv);
    
    // Apply a swirling black hole effect by warping based on radial distance
    vec2 center = vec2(0.5);
    vec2 diff = mUV - center;
    float dist = length(diff);
    
    // Reverse the conventional radial fade: Instead, accelerate intensity closer to the edge
    float warp = pow(dist, 2.0);
    
    // Add dynamic noise-driven distortion
    vec2 distort = vec2(fbm(mUV * 3.0 + time), fbm(mUV * 3.0 - time));
    
    // Apply swirling rotation based on time and noise
    float angle = atan(diff.y, diff.x) + warp * 6.2831 + fbm(mUV * 5.0 + time) * 3.1415;
    float radius = dist + 0.2 * fbm(mUV * 10.0 - time);
    
    vec2 warpedUV = center + vec2(cos(angle), sin(angle)) * radius;
    
    // Mix the original mirrored UV and the warped UV for an unexpected fusion
    vec2 finalUV = mix(mUV, warpedUV, 0.6);
    
    // Generate two contrasting color schemes
    vec3 colorA = vec3(0.2 + 0.8 * fbm(finalUV * 8.0 + time));
    vec3 colorB = vec3(0.8 * fbm(finalUV * 15.0 - time));
    
    // Instead of smooth interpolation with radial distance, use step to challenge expectation
    float mixFactor = step(0.4, fbm(finalUV * 5.0));
    vec3 finalColor = mix(colorA, colorB, mixFactor);
    
    // Apply unexpected vignette: brightening the edges instead of darkening
    float vignette = smoothstep(0.0, 0.6, 1.0 - dist);
    finalColor = mix(finalColor, finalColor * 1.5, vignette);
    
    gl_FragColor = vec4(finalColor, 1.0);
}