precision mediump float;
varying vec2 uv;
uniform float time;

float treeShape(vec2 p) {
    // Center coordinates and scale
    p = (p - 0.5) * 2.0;
    
    // Vertical trunk: centered at x=0, with varying thickness along y.
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    
    // Branch structures: create oscillatory branches using sine distortion.
    // The branches shift horizontally based on the y coordinate.
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    
    // Combine trunk and branch contributions.
    float shape = max(trunk, branch);
    
    // Add a fading effect at the top to simulate foliage soft edges.
    shape *= smoothstep(0.1, -0.3, p.y);
    
    return shape;
}

void main() {
    // Map the uv coordinates
    vec2 p = uv;
    
    // Background: a soft radial gradient representing sky and ground
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    vec3 bgColor = mix(vec3(0.9, 0.95, 1.0), vec3(0.8, 0.9, 0.7), smoothstep(0.0, 0.7, dist));
    
    // Generate tree shape which replaces the heart symbol in a context where love (growth) is essential.
    float tree = treeShape(p);
    
    // Define color for the tree: brown for trunk and green for leaves on the upper part.
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.2, 0.6, 0.2);
    
    // Calculate a blending factor based on vertical position to simulate leaves on top.
    float leafBlend = smoothstep(0.0, 0.6, (p.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Composite the tree shape onto the background
    vec3 color = mix(bgColor, treeColor, tree);
    
    gl_FragColor = vec4(color, 1.0);
}