precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash noise function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D Noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Organic tree-like shape function
float treeShape(vec2 p) {
    // Normalize p to [-1,1]
    p = (p - 0.5) * 2.0;
    // Trunk: centered and vertical with soft edges
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    // Branch distortion using time and sine patterns
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    // Combine trunk and branch with vertical taper (simulate foliage)
    float shape = max(trunk, branch);
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

void main(void) {
    // Map uv to centered coordinates in [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Conceptual Space 1: Organic noise landscape
    float organic = 0.0;
    float amplitude = 0.5;
    float frequency = 3.0;
    for (int i = 0; i < 4; i++) {
        organic += noise(pos * frequency + time * 0.2) * amplitude;
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    organic = smoothstep(0.3, 0.7, organic);
    
    // Conceptual Space 2: Digital grid with glitch distortion
    vec2 gridUV = uv * 10.0;
    vec2 grid = fract(gridUV);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y)) + 
                 smoothstep(0.48, 0.5, min(1.0 - grid.x, 1.0 - grid.y));
    
    // Apply digital glitch offset
    float glitch = sin(uv.y * 20.0 + time) * 0.03;
    vec2 digitalUV = uv + vec2(glitch, 0.0);
    vec2 digitalGrid = fract(digitalUV * 10.0);
    float digitalLine = smoothstep(0.48, 0.5, min(digitalGrid.x, digitalGrid.y)) + 
                        smoothstep(0.48, 0.5, min(1.0 - digitalGrid.x, 1.0 - digitalGrid.y));
    
    // Merge the two conceptual spaces using organic blend factor
    float blendFactor = smoothstep(0.2, 0.8, organic);
    float mixedLines = mix(line, digitalLine, blendFactor);
    
    // Emergent structure: radial distortion combined with tree shape
    float radius = length(pos);
    float emergent = smoothstep(0.3, 0.0, radius + 0.3 * sin(time + radius * 10.0));
    
    // Generate tree shape as a symbolic organic element in the scene
    float tree = treeShape(uv);
    
    // Color palettes: organic earth tones and digital neon tones
    vec3 organicColor = vec3(0.8, 0.5, 0.3) * organic;
    vec3 digitalColor = vec3(0.3, 0.8, 0.9) * mixedLines;
    
    // Blend colors based on the emergent structure and tree overlay
    vec3 baseColor = mix(organicColor, digitalColor, emergent);
    // Overlay tree element using a mix that emphasizes its form
    vec3 treeColor = mix(vec3(0.0), vec3(0.1, 0.5, 0.1), tree);
    vec3 finalColor = mix(baseColor, treeColor, tree);
    
    gl_FragColor = vec4(finalColor, 1.0);
}