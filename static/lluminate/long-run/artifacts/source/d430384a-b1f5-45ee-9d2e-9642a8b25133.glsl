precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233)))*43758.5453);
}

float treeShape(vec2 p) {
    // Center coordinates and scale to [-1, 1]
    p = (p - 0.5) * 2.0;
    
    // Vertical trunk with noise-based perturbation
    float trunk = smoothstep(0.04, 0.0, abs(p.x));
    
    // Branch dynamics: oscillating branches with sine modulation and slight noise
    float branch = smoothstep(0.045, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    branch *= 0.8 + 0.2 * pseudoNoise(p * 5.0 + time);
    
    // Combine trunk and branch; fade towards top for organic soft edges.
    float shape = max(trunk, branch);
    shape *= smoothstep(0.2, -0.5, p.y);
    return shape;
}

vec3 glitchColor(vec2 pos, float t) {
    float n = pseudoNoise(pos * 50.0 + t);
    float r = pseudoNoise(pos + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(pos + vec2(0.0, t * 0.15));
    float b = pseudoNoise(pos + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.97, n);
    return mix(col, vec3(1.0), glitch);
}

void main() {
    // Remap uv to centered coordinates between -1 and 1.
    vec2 centered = uv - 0.5;
    
    // Cosmic swirling background using polar coordinates.
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    float spiral = sin(12.0 * radius - time * 3.0 + angle * 5.0);
    
    // Base cosmic gradient: deep purple to blue.
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.0, 0.4, 0.8), radius);
    
    // Overlay glitch patterns for digital disruption.
    vec3 digitalGlitch = glitchColor(centered * 2.0, time);
    
    // Synthesize tree organic growth and glitch: offset uv for tree.
    float tree = treeShape(uv);
    
    // Tree colors: trunk and foliage
    vec3 trunkColor = vec3(0.35, 0.20, 0.1);
    vec3 leafColor  = vec3(0.1, 0.5, 0.2);
    float leafMix = smoothstep(0.4, 0.8, uv.y);
    vec3 treeColor = mix(trunkColor, leafColor, leafMix);
    
    // Combine cosmic background with glitch artifacts.
    vec3 combined = mix(baseColor, digitalGlitch, 0.3);
    
    // Composite tree shape over the background.
    combined = mix(combined, treeColor, tree);
    
    // Apply a vignette effect for depth.
    float vignette = smoothstep(0.8, 0.2, radius);
    combined *= vignette;
    
    gl_FragColor = vec4(combined, 1.0);
}