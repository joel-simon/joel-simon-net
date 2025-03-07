precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

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

// Creative concept: Replace the brittle symbol of error-filled pixels with the robust vitality of a tree.
// Subject: Tree (P) representing resilience.
// Trait: Resilience.
// Symbol (S): Glitchy pixels representing digital decay.
// Context: Instead of a failing display, a tree's network (veins) reinforce life through dynamic branching.
float treeVein(vec2 p) {
    // Shift coordinate system: center and adjust vertical growth base
    p = (p - vec2(0.5, 0.2)) * vec2(1.0, 1.5);
    
    // Compute radial distance and angle
    float r = length(p);
    float angle = atan(p.y, p.x);
    
    // The tree's strength grows with distance upward, simulating rising branches.
    float growth = smoothstep(0.0, 0.5, p.y);
    
    // Introduce dynamic branching: incorporate time, noise, and sinusoidal oscillation.
    float branch = abs(sin(angle * 5.0 + time + fbm(p * 8.0)*3.0));
    
    // Reduce branch intensity toward the edges for natural tapering.
    float taper = smoothstep(0.5, 0.2, r);
    
    return growth * branch * taper;
}

void main() {
    vec2 p = uv;
    
    // Background: a blend of digital azure to warm earthy tones, representing the merging of digital glitches and natural life.
    vec3 digitalColor = vec3(0.1, 0.3, 0.5);
    vec3 organicColor = vec3(0.1, 0.5, 0.2);
    vec3 bgColor = mix(digitalColor, organicColor, p.y);
    
    // Overlay a subtle glitch effect: shifting UV coordinates with periodic noise distortion.
    vec2 glitchUV = p;
    glitchUV.x += 0.02 * sin(time * 3.0 + p.y * 20.0);
    glitchUV.y += 0.02 * cos(time * 4.0 + p.x * 25.0);
    float glitch = fbm(glitchUV * 12.0 + time);
    
    // Compute the organic tree-like vein structure.
    float treeStructure = treeVein(p);
    
    // Merge the glitchy background with the organic structure.
    vec3 treeColor = mix(bgColor, vec3(0.0, 0.4, 0.1), treeStructure);
    
    // Add subtle digital distortion flashes.
    float flash = smoothstep(0.4, 0.42, glitch);
    vec3 flashColor = vec3(0.8, 0.8, 1.0) * flash;
    
    vec3 finalColor = treeColor + flashColor;
    
    gl_FragColor = vec4(finalColor, 1.0);
}