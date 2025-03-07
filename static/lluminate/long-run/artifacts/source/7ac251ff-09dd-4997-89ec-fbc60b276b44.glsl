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

// Fractal Brownian Motion function
float fbm(vec2 p) {
    float f = 0.0;
    f += 0.5000 * noise(p); p *= 2.02;
    f += 0.2500 * noise(p); p *= 2.03;
    f += 0.1250 * noise(p); p *= 2.01;
    f += 0.0625 * noise(p);
    return f;
}

// Glitch distortion applied to coordinates
vec2 glitchOffset(vec2 p) {
    float n = noise(vec2(p.y * 20.0, time));
    return vec2(n * 0.05, 0.0);
}

// Mountain silhouette with glitch distortion
float mountain(vec2 p) {
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

// Tree branch function, representing growth; creative idea: replace the symbol of a tree (as nature and growth) with a coral structure
float coralBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = sin(t * 0.3) * 0.8;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 6.0 + t * 2.0);
    float branch = exp(-8.0 * r);
    return smoothstep(0.25, 0.35, abs(wave) * branch);
}

void main(void) {
    vec2 p = uv;
    
    // Apply glitch effect with slight offset
    vec2 gp = p + glitchOffset(p * 2.0);
    
    // Create sky background with a gentle gradient
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.1), vec3(0.05, 0.05, 0.15), p.y);
    
    // Generate a digital mountain silhouette
    float m = mountain(gp);
    float mountainMask = step(p.y, m);
    vec3 mountainColor = mix(vec3(0.1, 0.1, 0.15), vec3(0.5, 0.4, 0.3), noise(p * 20.0 + time));
    
    // Generate organic coral branch structure (creative symbol replacement: tree -> coral)
    float branch = coralBranch(p, time);
    vec3 coralColor = mix(vec3(0.8, 0.4, 0.2), vec3(0.9, 0.2, 0.5), branch);
    
    // Organic swirling effect for extra digital distortion
    vec2 centered = (p - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float swirl = sin(angle * 4.0 + time * 2.0) * 0.3;
    float shape = smoothstep(0.5 + swirl, 0.48 + swirl, radius);
    
    // FBM for cosmic distortion overlay with glitch noise
    float organic = fbm(centered * 3.0 + time * 0.5);
    vec3 cosmicColor = mix(vec3(0.1, 0.3, 0.7), vec3(0.9, 0.5, 0.2), organic);
    
    // Combine digital mountain, organic coral, and cosmic swirl elements
    vec3 baseColor = mix(skyColor, mountainColor, mountainMask);
    baseColor = mix(baseColor, coralColor, branch);
    vec3 finalColor = mix(baseColor, cosmicColor, shape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}