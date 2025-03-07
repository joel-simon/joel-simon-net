precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Fractal branch function simulating a tree structure that grows from the center
float treeBranch(vec2 pos, float t) {
    // Transform coordinate system from [0,1] to [-1,1]
    pos = pos * 2.0 - 1.0;
    // Rotate slowly over time for organic growth
    float angle = sin(t * 0.5) * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Create branching effect using polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    // Use sine waves to simulate branch undulation
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    // Emphasize trunk structure in the center using exponential decay
    float trunk = exp(-10.0 * r);
    // Combine branch detail and trunk intensity
    float branch = smoothstep(0.2, 0.3, abs(wave) * trunk);
    return branch;
}

// Generate a field pattern representing growth: a tree replacing the expected flower symbol
vec3 treeGrowth(vec2 pos, float t) {
    // Base color of the environment
    vec3 baseColor = vec3(0.1, 0.15, 0.2);
    // Define colors for the tree: trunk and foliage hint
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.1, 0.8, 0.3);
    
    float branchPattern = treeBranch(pos, t);
    
    // Introducing subtle noise for natural texture
    float noise = random(pos * 5.0 + t);
    
    // Mix trunk and leaf colors based on branch structure
    vec3 color = mix(trunkColor, leafColor, branchPattern);
    
    // Blend with base environment using noise as factor for organic integration
    color = mix(baseColor, color, smoothstep(0.15, 0.35, branchPattern + noise * 0.2));
    return color;
}

void main() {
    // "Replace the flower symbol of growth with the towering tree" to emphasize enduring stability.
    vec2 pos = uv;
    
    // Introduce a gentle zoom and pan effect
    pos = (pos - 0.5) * (1.0 + 0.3 * sin(time * 0.7)) + 0.5;
    
    // Synthesize tree growth pattern across the field
    vec3 finalColor = treeGrowth(pos, time);
    
    gl_FragColor = vec4(finalColor, 1.0);
}