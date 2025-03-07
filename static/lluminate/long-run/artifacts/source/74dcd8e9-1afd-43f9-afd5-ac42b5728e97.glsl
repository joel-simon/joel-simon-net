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
    for (int i = 0; i < 6; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// This function simulates a living tree trunk with growth rings.
// We replace the fragile symbol of shattered glass with a robust tree trunk pattern.
// The rings represent time and resilience; subtle distortions give natural imperfections.
float treeTrunk(vec2 p) {
    // Transform coordinates to center the trunk
    vec2 pos = p - vec2(0.5, 0.5);
    float dist = length(pos);
    
    // Create concentric rings influenced by time to simulate growth layers.
    float rings = sin(20.0 * dist - time * 2.0);
    
    // Add organic imperfection with fbm noise.
    float imperfection = fbm(pos * 8.0 + time);
    
    // Mix the rings with noise to create a wood-like texture.
    float trunk = smoothstep(0.05, 0.0, abs(rings + imperfection * 0.2));
    
    return trunk;
}

// This function simulates branching edges emerging from the trunk's center.
// They represent natural offshoots and reinforce the idea of growth replacing fragility.
float treeBranches(vec2 p) {
    // Shift coordinate system to the bottom center for branch emergence.
    vec2 pos = p - vec2(0.5, 0.0);
    
    // Compute polar coordinates.
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create branching with sinusoidal offsets and noise disturbances.
    float branchLine = smoothstep(0.02, 0.0, abs(sin(angle * 4.0 + time) * 0.05 + fbm(pos * 15.0) * 0.03));
    
    // Modulate by vertical growth: branches appear after a threshold.
    float growth = smoothstep(0.2, 0.6, p.y);
    
    return branchLine * growth;
}

void main() {
    vec2 p = uv;
    
    // Create a background that gradually shifts from a dawn blue to a deep forest green.
    vec3 bgColor = mix(vec3(0.02, 0.1, 0.25), vec3(0.0, 0.2, 0.1), p.y);
    bgColor += fbm(p * 5.0 + time * 0.3) * 0.05;
    
    // Generate the tree trunk with dynamic rings to indicate resilience.
    float trunk = treeTrunk(p);
    
    // Generate branching structure emerging from the trunk.
    float branches = treeBranches(p);
    
    // Color for tree trunk: deep brown with subtle green hints.
    vec3 trunkColor = mix(vec3(0.15, 0.07, 0.03), vec3(0.05, 0.15, 0.05), trunk);
    
    // Color for branches: slightly lighter and infused with dynamic energy.
    vec3 branchColor = mix(vec3(0.18, 0.09, 0.04), vec3(0.1, 0.3, 0.1), branches);
    
    // Composite the final scene by layering trunk and branches on the background.
    vec3 composite = bgColor;
    composite = mix(composite, trunkColor, trunk);
    composite = mix(composite, branchColor, branches);
    
    gl_FragColor = vec4(composite, 1.0);
}