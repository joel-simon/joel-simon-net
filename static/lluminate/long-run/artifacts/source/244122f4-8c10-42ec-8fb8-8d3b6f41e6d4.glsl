precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// Basic noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Origami fold: creates crisp fold lines by reflecting parts of the coordinate space
vec2 origamiFold(vec2 p, float foldCount) {
    p *= foldCount;
    vec2 gv = fract(p) - 0.5;
    vec2 id = floor(p);
    // Create a crisp fold boundary by mirroring the coordinate
    if(gv.x > 0.25) gv.x = 0.5 - gv.x;
    if(gv.y > 0.25) gv.y = 0.5 - gv.y;
    return gv;
}

// Dynamic explosion: simulate a fluid burst through radial noise and sine waves
float explosion(vec2 p) {
    vec2 cp = p - 0.5;
    float r = length(cp);
    float angle = atan(cp.y, cp.x);
    float wave = sin(10.0 * r - time*3.0 + fbm(p*8.0)*6.28);
    float ring = smoothstep(0.15, 0.18, abs(sin(angle*3.0 + time) + wave*0.25));
    return 1.0 - smoothstep(0.0, 0.5, r) + ring;
}

void main() {
    // Use uv to create base coordinate
    vec2 p = uv;
    
    // Apply origami fold pattern: Combining regular grid fold dynamics
    vec2 folded = origamiFold(p, 8.0);
    float crease = smoothstep(0.22, 0.25, length(folded));
    
    // Generate explosion effect from a drifting center
    vec2 explosionCenter = vec2(0.5 + 0.1*sin(time*0.7), 0.5 + 0.1*cos(time*0.9));
    float expEffect = explosion(p - explosionCenter);
    
    // Blend the crisp folding with the fluid dynamic explosion
    float blendFactor = mix(expEffect, crease, 0.5);
    
    // Color mapping: origami (paper) in off-white and explosion in fiery oranges and reds
    vec3 paperColor = vec3(0.95, 0.93, 0.85);
    vec3 fireColor = vec3(1.0, 0.4, 0.0) * expEffect + vec3(0.6, 0.1, 0.0) * crease;
    
    // Combine both themes distinctly using mix
    vec3 color = mix(paperColor, fireColor, blendFactor);
    
    // Final vignette to add depth
    float vignette = smoothstep(0.8, 0.3, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}