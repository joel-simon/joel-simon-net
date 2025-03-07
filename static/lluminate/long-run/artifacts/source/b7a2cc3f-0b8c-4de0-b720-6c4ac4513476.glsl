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

// Creative concept: Replace the fragile symbol of shattering glass with the resilient essence of a tree.
// Subject: Tree (P) represents resilience.
// Trait: Resilience.
// Symbol (S): Shattered glass, typically delicate.
// Context: Instead of glass breaking under pressure, a tree naturally grows stronger.
// This branch function simulates organic branching structures of a tree.
float treeBranch(vec2 p) {
    // Move origin to center bottom
    p -= vec2(0.5, 0.0);
    
    // Map vertical axis to growth progress
    float growth = smoothstep(0.0, 1.0, p.y * 1.8);
    
    // Polar coordinates for branch spread
    float angle = atan(p.y, p.x);
    
    // Create branch outlines with sine waves based on time and noise disturbances (simulating wind)
    float branch = smoothstep(0.02, 0.0, abs(p.x - sin(angle * 3.0 + time * 1.3) * 0.05 - fbm(p * 10.0) * 0.03));
    
    // Multiply with growth to have branches only appear as they "rise"
    return branch * growth;
}

void main() {
    // Normalize coordinates
    vec2 p = uv;
    
    // Background: a gradient from a cool dawn to warm sunrise representing the passing of a fragile moment.
    vec3 bgColor = mix(vec3(0.02, 0.05, 0.15), vec3(0.4, 0.3, 0.2), p.y);
    bgColor += 0.1 * fbm(p * 5.0 + time * 0.5);
    
    // Foreground: organic tree branches emerging resiliently against the delicate background.
    // Instead of broken glass, branches grow in a bottom-up fashion.
    float branchPattern = treeBranch(p);
    
    // Introduce subtle color variation for the tree: earthy tones with hints of green.
    vec3 treeColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.0, 0.4, 0.1), branchPattern);
    
    // Composite the scene with the branches emerging.
    vec3 finalColor = mix(bgColor, treeColor, branchPattern);
    
    gl_FragColor = vec4(finalColor, 1.0);
}