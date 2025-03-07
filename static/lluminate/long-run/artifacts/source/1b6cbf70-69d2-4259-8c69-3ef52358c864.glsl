precision mediump float;
varying vec2 uv;
uniform float time;

float treeShape(vec2 p) {
    // Center the tree horizontally and sink it towards the bottom.
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    
    // Create the trunk as a narrow vertical strip with soft edges.
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    
    // Generate wavy branches using sin functions that evolve with time.
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        // Branch position drifts horizontally with a sine modulation based on vertical position.
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        // Branch contribution: its width decreases as it goes upward.
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    // Canopy: a soft circular blob representing leaves that hovers above the trunk.
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    
    // Combine trunk, branches, and canopy to form the full tree silhouette.
    return max(trunk, max(branches, canopy));
}

void main() {
    // Apply a subtle glitch effect by distorting the x coordinate.
    vec2 p = uv;
    float glitch = sin(50.0 * p.y + time * 10.0) * 0.005;
    p.x += glitch;
    
    // Create a dynamic background with a flowing gradient and subtle swirling.
    float swirl = sin(10.0 * (p.x + p.y) + time);
    vec3 bgColor = mix(vec3(0.05, 0.05, 0.1), vec3(0.2, 0.25, 0.4), p.y + 0.5 * swirl);
    
    // Evaluate the tree shape.
    float tree = treeShape(p);
    
    // Define the tree color with a natural green that varies vertically.
    vec3 treeColor = mix(vec3(0.1, 0.4, 0.15), vec3(0.2, 0.7, 0.3), p.y);
    
    // Blend the tree silhouette with the background.
    vec3 finalColor = mix(bgColor, treeColor, tree);
    
    gl_FragColor = vec4(finalColor, 1.0);
}