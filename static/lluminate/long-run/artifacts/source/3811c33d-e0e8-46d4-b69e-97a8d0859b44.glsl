precision mediump float;
varying vec2 uv;
uniform float time;

// Substitute base tree shape with an inverted, swirling organic structure that blends digital grid artifacts.
// Use a reversed coordinate mapping and combine sinusoidal modulations with a grid function.
 
// Function to create a digital grid pattern.
float grid(vec2 p, float resolution) {
    vec2 gridUV = fract(p * resolution);
    float lineWidth = 0.03;
    float gridLine = step(gridUV.x, lineWidth) + step(gridUV.y, lineWidth);
    return clamp(gridLine, 0.0, 1.0);
}
 
// Function to create a looping organic branch pattern.
float branch(vec2 p, vec2 center, float scale, float phase) {
    vec2 diff = p - center;
    float angle = atan(diff.y, diff.x);
    float radius = length(diff);
    // Reverse the growth by mapping time backwards along radius.
    float wave = sin(10.0 * (radius - time * 0.5) + phase + angle * 3.0);
    return smoothstep(0.02, 0.0, abs(wave) * scale);
}
 
// Combine multiple branches to form an organic tree structure.
float organicTree(vec2 p) {
    float tree = 0.0;
    // Adjust and reverse coordinates for a different visual direction.
    vec2 pos = (p - 0.5) * vec2(-2.0, 2.0);
    // Combine multiple branch patterns at varying centers.
    tree = max(tree, branch(pos, vec2(0.0, -0.2), 0.35, 0.0));
    tree = max(tree, branch(pos, vec2(0.2, 0.0), 0.35, 1.57));
    tree = max(tree, branch(pos, vec2(-0.2, 0.0), 0.35, -1.57));
    return clamp(tree, 0.0, 1.0);
}
 
void main() {
    float aspect = 1.0;
    vec2 p = uv;
    
    // Create a dynamic, shifting background using a mix of colors.
    float dist = length(p - vec2(0.5));
    vec3 bgColor = mix(vec3(0.02, 0.05, 0.1), vec3(0.1, 0.2, 0.3), 0.5 + 0.5 * sin(time + dist * 20.0));
    
    // Generate the organic tree structure.
    float treeMask = organicTree(p);
    
    // Produce a digital grid overlay to add intentional glitch-like artifacts.
    float gridMask = grid(p + vec2(sin(time), cos(time)) * 0.1, 20.0);
    
    // Combine organic texture with digital grid.
    float compositeMask = max(treeMask, gridMask * 0.5);
    
    // Use a color scheme that rotates over time; use substitute imaginative hue transitions.
    vec3 treeColor = vec3(0.5 + 0.5 * sin(time + 3.14 * p.x), 0.4 + 0.6 * cos(time + 3.14 * p.y), 0.7 + 0.3 * sin(time));
    
    // Final composition: mix background with tree structure.
    vec3 finalColor = mix(bgColor, treeColor, compositeMask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}