precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for randomized noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise function.
float noise(vec2 p){
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)),
                   hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)),
                   hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Function to create branching fractal structure reminiscent of organic trees merging with digital glitches.
float fractalTree(vec2 st) {
    // Convert to polar coordinates.
    float angle = atan(st.y, st.x);
    float radius = length(st);
    
    // Create a base spiral that evolves with time.
    float spiral = sin(6.0 * angle + time + radius * 10.0);
    
    // Iterate to simulate branches.
    float branches = 0.0;
    vec2 p = st;
    for (int i = 0; i < 5; i++) {
        // Vary the scale and rotate each iteration.
        p = abs(p) / dot(vec2(1.0, 1.0), abs(p)) - 0.5;
        branches += abs(sin(5.0 * p.x + time)) * 0.15;
    }
    return smoothstep(0.4, 0.42, spiral + branches);
}

void main(){
    // Center uv coordinates.
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply a subtle rotation based on time.
    float angle = time * 0.3;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    st = rot * st;
    
    // Base background with digital noise.
    float n = noise(st * 3.0 + time * 0.5);
    vec3 bgColor = mix(vec3(0.0, 0.05, 0.1), vec3(0.05, 0.0, 0.1), n);
    
    // Draw fractal tree structure
    float tree = fractalTree(st * 1.5);
    
    // Introduce extra glitch detail using noise.
    float glitch = noise(st * 10.0 - time * 2.0);
    tree = mix(tree, glitch, 0.3);
    
    // Color the fractal with a mix of neon cyan and magenta.
    vec3 treeColor = mix(vec3(0.0, 0.8, 0.8), vec3(0.8, 0.0, 0.8), fract(tree * 5.0));
    
    // Merge the fractal structure with the background.
    vec3 color = mix(bgColor, treeColor, tree);
    
    gl_FragColor = vec4(color, 1.0);
}