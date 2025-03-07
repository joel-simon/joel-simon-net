precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 23.0))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
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

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Creative Idea:
    // Trait: Organic Growth
    // Symbol S: A small seed
    // Context: In nature, a seed transforms into a mighty tree when nurtured.
    // Replace the seed (symbol of potential) with the tree (subject) that embodies organic growth.
    
    // Seed phase (central circle) grows into branching patterns as time increases.
    float seed = smoothstep(0.2, 0.18, radius);
    float growFactor = smoothstep(0.0, 1.0, time);
    
    // Generate branch patterns radiating from center
    float branches = 0.0;
    for (int i = 0; i < 8; i++) {
        // Each branch is modulated by its angle offset and time 
        float branchAngle = angle - float(i) * (3.14159 * 2.0 / 8.0);
        float branch = abs(cos(branchAngle * 3.0 + time * 2.0));
        branch = smoothstep(0.5, 0.52, branch);
        // Vary branch length with noise
        float nval = fbm(pos * 2.0 + float(i));
        branch *= smoothstep(0.3 + nval * 0.2, 0.29 + nval * 0.2, radius);
        branches += branch;
    }
    
    // Organic texture for tree bark and leaves
    float texture = fbm(pos * 5.0 + time);
    vec3 seedColor = vec3(0.2, 0.15, 0.1);
    vec3 treeColor = mix(vec3(0.1, 0.4, 0.1), vec3(0.0, 0.6, 0.2), texture);
    
    // The tree emerges from the seed: mix transitions based on time.
    vec3 color = mix(seedColor, treeColor, growFactor);
    // Overlay branch patterns
    color += vec3(0.15, 0.1, 0.05) * branches;
    
    // Soft gradient in the background
    float bg = smoothstep(0.7, 1.0, radius);
    color = mix(color, vec3(0.95, 0.95, 0.9), bg);
    
    gl_FragColor = vec4(color, 1.0);
}