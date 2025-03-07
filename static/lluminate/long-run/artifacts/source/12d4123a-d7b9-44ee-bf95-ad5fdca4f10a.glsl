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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
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

// Synthesize a shader that fuses an underwater coral’s organic growth with the digital chaos of a cosmic nebula.
// The coral structure is represented by fractal-like branching, while the nebula introduces glitchy disruption.
float coralBranch(vec2 p) {
    // Transform coordinates for vertical coral growth
    p -= vec2(0.5, 0.0);
    float growth = smoothstep(0.0, 1.0, p.y * 1.8);
    
    // Branch spread using polar coordinates; stray sine curves simulate organic curves and random shifts.
    float angle = atan(p.y, p.x);
    float branch = smoothstep(0.03, 0.0, abs(p.x - sin(angle * 4.0 + time * 1.5) * 0.06 - fbm(p * 12.0) * 0.04));
    
    return branch * growth;
}

float digitalGlitch(vec2 p) {
    // Introduce digital glitch by shifting coordinates with time and noise
    float glitch = step(0.9, fract(fbm(p * 15.0 + time * 2.0)));
    vec2 shift = vec2(noise(vec2(time, p.y * 5.0)), 0.0) * glitch * 0.1;
    return noise(p + shift);
}

void main() {
    vec2 p = uv;
    
    // Background: cosmic nebula with glitch effects. Blend dark cosmic blues to vibrant purples.
    vec3 nebulaColor = mix(vec3(0.05, 0.0, 0.1), vec3(0.4, 0.1, 0.5), p.y);
    nebulaColor += 0.15 * vec3(fbm(p * 8.0 + time * 0.3));
    
    // Superimpose digital glitches over the nebula for interstellar disruption.
    float glitchMask = digitalGlitch(p);
    nebulaColor = mix(nebulaColor, vec3(0.9, 0.8, 0.2), glitchMask);
    
    // Foreground: organic coral branches rising from the bottom, rendered with warm, earthy coral tones.
    float coral = coralBranch(p);
    vec3 coralColor = mix(vec3(0.3, 0.1, 0.0), vec3(0.9, 0.4, 0.2), coral);
    
    // Composite the scene: blend the cosmic glitch nebula with the organic coral structures.
    vec3 finalColor = mix(nebulaColor, coralColor, coral);
    
    gl_FragColor = vec4(finalColor, 1.0);
}