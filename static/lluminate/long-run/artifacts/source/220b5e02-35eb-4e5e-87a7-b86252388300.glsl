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

float digitalCircuit(vec2 p) {
    // Create a grid structure simulating digital circuitry
    vec2 grid = fract(p * 10.0);
    float line = step(0.02, min(grid.x, grid.y)) * step(0.02, min(1.0-grid.x, 1.0-grid.y));
    // Glitch: perturb the grid with noise
    float glitch = fbm(p * 5.0 + time);
    return line * smoothstep(0.2, 0.8, glitch);
}

float organicTree(vec2 p) {
    // Translate p to originate from bottom center
    p -= vec2(0.5, 0.0);
    // Vertical growth progression
    float growth = smoothstep(0.0, 1.0, p.y * 1.8);
    // Create organic branching curves using sine waves and noise disturbances 
    float angle = atan(p.y, p.x);
    float branch = smoothstep(0.03, 0.0, abs(p.x - sin(angle * 4.0 + time * 1.5) * 0.06 - fbm(p * 8.0) * 0.04));
    return branch * growth;
}

void main() {
    vec2 p = uv;
    
    // Background: blend of dark night sky and neon digital grid lights
    vec3 bgColor = mix(vec3(0.02, 0.02, 0.08), vec3(0.06, 0.04, 0.12), p.y);
    bgColor += 0.08 * fbm(p * 5.0 + time * 0.3);
    
    // Digital circuit overlay (unrelated digital glitch element)
    float circuit = digitalCircuit(p);
    vec3 circuitColor = vec3(0.0, 0.8, 0.9) * circuit;
    
    // Organic tree structure (resilient natural growth)
    float tree = organicTree(p);
    vec3 treeColor = mix(vec3(0.02, 0.05, 0.0), vec3(0.1, 0.4, 0.05), tree);
    
    // Combine digital and organic elements in a novel synthesis
    vec3 colorMix = mix(bgColor, treeColor, tree);
    colorMix = mix(colorMix, circuitColor, circuit);
    
    gl_FragColor = vec4(colorMix, 1.0);
}