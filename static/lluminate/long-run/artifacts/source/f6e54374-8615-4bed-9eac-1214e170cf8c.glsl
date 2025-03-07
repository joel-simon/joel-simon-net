precision mediump float;
varying vec2 uv;
uniform float time;

// Substitute: Use a modified hash function for a new noise
float newHash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Combine: Fractal noise via multiple octaves
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 1.0;
    for (int i = 0; i < 5; i++) {
        total += newHash(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Adapt: Reversed swirl effect for organic distortion
vec2 reversedSwirl(vec2 p, float strength) {
    p -= 0.5;
    float r = length(p);
    float angle = atan(p.y, p.x) - strength * r;
    p = vec2(cos(angle), sin(angle)) * r;
    return p + 0.5;
}

// Modify: Digital glitch pattern using fbm displacement
vec2 glitch(vec2 p) {
    float glitchStrength = smoothstep(0.0, 0.5, fbm(vec2(p.y * 8.0, time)));
    return p + vec2(glitchStrength * 0.04, 0.0);
}

// Purpose: Create a dynamic organic structure resembling growing organic branches
float organicBranch(vec2 p, float t) {
    p = p * 2.0 - 1.0; // remap uv space
    float r = length(p);
    float angle = atan(p.y, p.x);
    float wave = sin(12.0 * r - angle * 5.0 + t * 3.0);
    float branch = exp(-4.0 * r);
    return smoothstep(0.3, 0.5, abs(wave) * branch);
}

void main(void) {
    vec2 pos = uv;
    
    // Eliminate traditional disturbance by glitched offset, replace with controlled glitch effect.
    pos = glitch(pos);
    
    // Reverse swirl gives a sense of collapsing/dynamic nature.
    vec2 revPos = reversedSwirl(pos, 2.5 * sin(time * 0.7));
    
    // Generate an organic branch-like structure from two blended approaches
    float branchA = organicBranch(uv, time);
    float branchB = organicBranch(revPos, time * 1.1);
    float branches = mix(branchA, branchB, 0.5);
    
    // Layer cosmic noise in background, representing digital cosmos with imperfection
    float cosmic = fbm(uv * 6.0 + time * 0.5);
    
    // Create a digital overlay with glitchy interference lines
    float glitches = smoothstep(0.4, 0.42, abs(sin(uv.y * 60.0 + time * 12.0)));
    
    // Color blending: replacing standard cosmic palette with a combination of deep blues
    // and organic greens enhanced by glitch white noise
    vec3 baseColor = mix(vec3(0.05, 0.1, 0.2), vec3(0.02, 0.05, 0.1), uv.y);
    vec3 branchColor = mix(vec3(0.1, 0.5, 0.2), vec3(0.0, 0.3, 0.1), branches);
    vec3 cosmicColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.2, 0.1, 0.3), cosmic);
    
    vec3 color = baseColor;
    color = mix(color, cosmicColor, 0.5);
    color = mix(color, branchColor, smoothstep(0.15, 0.45, branches));
    color = mix(color, vec3(1.0), glitches * 0.15);
    
    gl_FragColor = vec4(color, 1.0);
}