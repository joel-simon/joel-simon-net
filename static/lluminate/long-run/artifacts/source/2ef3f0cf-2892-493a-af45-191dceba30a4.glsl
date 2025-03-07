precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Function to create a tree silhouette using sine-modulated branches.
float treeShape(vec2 pos, float t) {
    // Center the coordinate system.
    pos = pos * 2.0 - 1.0;
    // Shift so that trunk is in the center bottom.
    pos.y += 0.5;
    
    // Create trunk: a vertical line near x=0.
    float trunk = smoothstep(0.03, 0.0, abs(pos.x));
    
    // Create branches using sine waves: they fan out from the trunk.
    float branch = 0.0;
    float yLayer = pos.y;
    // Use few layers of branches.
    for (int i = 0; i < 3; i++) {
        float layer = float(i) * 0.3;
        float width = 0.2 - float(i) * 0.05;
        // Offset branches using sine modulation with time and layer.
        float branchLine = smoothstep(width, width - 0.02, abs(pos.x - sin(t + pos.y*5.0 + layer)*0.4));
        // Only add branch if y is near the layer.
        float layerMask = smoothstep(layer + 0.05, layer, abs(pos.y - layer));
        branch += branchLine * layerMask;
    }
    
    // Combine trunk and branch shapes.
    return max(trunk, branch);
}

void main(void) {
    // Coordinate transformation
    vec2 pos = uv;
    
    // Create a dynamic digital glitch effect to overlay texture
    float glitch = noise(vec2(pos.y * 15.0, time * 0.5)) * 0.3;
    
    // Background color dynamically shifting with time.
    vec3 bgColor = mix(vec3(0.1, 0.2, 0.3), vec3(0.3, 0.2, 0.1), sin(time * 0.7) * 0.5 + 0.5);
    
    // Generate tree shape which replaces the symbol of a heart normally associated with love.
    // Here, we replace the heart with a tree,
    // emphasizing resilience as the key trait in a context where love (nurturing) is essential.
    float tree = treeShape(pos, time);
    
    // Color for the tree: a deep green-brown palette.
    vec3 treeColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.0, 0.35, 0.15), tree);
    
    // Mix glitchy color offsets into the tree
    treeColor += glitch * vec3(0.05, 0.1, 0.05);
    
    // Final output by overlaying the tree shape over the shifting background.
    vec3 color = mix(bgColor, treeColor, tree);
    
    gl_FragColor = vec4(color, 1.0);
}