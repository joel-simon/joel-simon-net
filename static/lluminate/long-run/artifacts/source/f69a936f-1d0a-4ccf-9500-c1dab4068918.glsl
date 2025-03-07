precision mediump float;
varying vec2 uv;
uniform float time;

float treeShape(vec2 p) {
    // Transform coordinates: center and scale to [-1,1]
    vec2 pos = (p - 0.5) * 2.0;
    
    // Trunk: vertical rectangle with soft edges
    float trunk = smoothstep(0.04, 0.0, abs(pos.x)) * smoothstep(0.1, 0.5, pos.y);
    
    // Branches: oscillatory branches using sine distortion over y
    float branches = smoothstep(0.045, 0.0, abs(pos.x - 0.35 * sin(5.0 * pos.y + time)));
    
    // Combine trunk and branches
    float shape = max(trunk, branches);
    
    // Fade the top for foliage softness
    shape *= smoothstep(0.0, -0.5, pos.y);
    return shape;
}

vec3 swirlingPattern(vec2 p, float t) {
    // Center coordinates
    vec2 centered = p - 0.5;
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    
    // Create twisting effect via radial sine modulation
    float twist = sin(radius * 10.0 - t * 2.0);
    float pattern = smoothstep(0.3 + twist * 0.1, 0.31 + twist * 0.1, radius);
    
    // Color gradient based on angle and time
    vec3 color = vec3(
        0.5 + 0.5 * cos(angle + t),
        0.5 + 0.5 * sin(angle + t * 0.5),
        0.5 + 0.5 * cos(angle - t * 0.5)
    );
    return color * pattern;
}

void main() {
    // Generate the swirling background pattern
    vec3 swirlColor = swirlingPattern(uv, time);
    
    // Generate the tree shape pattern
    float tree = treeShape(uv);
    
    // Define tree colors: base trunk and foliage gradient
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.6, 0.2);
    // Blending based on the vertical position to simulate foliage
    float leafBlend = smoothstep(0.0, 0.6, uv.y);
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Blend the two conceptual spaces using the tree shape as a mask
    vec3 finalColor = mix(swirlColor, treeColor, tree);
    
    gl_FragColor = vec4(finalColor, 1.0);
}