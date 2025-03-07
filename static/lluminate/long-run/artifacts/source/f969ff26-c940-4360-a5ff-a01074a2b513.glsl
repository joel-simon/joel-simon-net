precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash noise function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function
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

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 3.0;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(p * frequency + time * 0.2);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Organic tree-like shape function
float treeShape(vec2 p) {
    // Normalize p to [-1,1]
    p = (p - 0.5) * 2.0;
    // Trunk with smooth edges
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    // Branch distortion using sine patterns modulated by time
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    // Combine trunk and branch with vertical taper for organic feel
    float shape = max(trunk, branch);
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

void main() {
    // Background: dynamic organic noise landscape
    float organicNoise = fbm(uv * 3.0);
    float organicBlend = smoothstep(0.3, 0.7, organicNoise);
    vec3 organicColor = mix(vec3(0.1, 0.05, 0.2), vec3(0.3, 0.2, 0.5), 0.5 + 0.5 * sin(time + length(uv - 0.5) * 10.0));
    
    // Digital glitch grid
    vec2 gridUV = uv * 10.0;
    vec2 grid = fract(gridUV);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y)) +
                 smoothstep(0.48, 0.5, min(1.0 - grid.x, 1.0 - grid.y));
    
    // Glitch offset
    float glitch = sin(uv.y * 20.0 + time) * 0.03;
    vec2 digitalUV = uv + vec2(glitch, 0.0);
    vec2 digitalGrid = fract(digitalUV * 10.0);
    float digitalLine = smoothstep(0.48, 0.5, min(digitalGrid.x, digitalGrid.y)) +
                        smoothstep(0.48, 0.5, min(1.0 - digitalGrid.x, 1.0 - digitalGrid.y));
                        
    float mixedGrid = mix(line, digitalLine, organicBlend);
    
    // Emergent radial distortion effect
    vec2 pos = uv * 2.0 - 1.0;
    float radial = smoothstep(0.3, 0.0, length(pos) + 0.3 * sin(time + length(pos) * 10.0));
    
    // Organic tree structure overlay
    float tree = treeShape(uv);
    
    // Blend organic and digital visuals
    vec3 baseColor = mix(organicColor, vec3(0.3, 0.8, 0.9) * mixedGrid, radial);
    vec3 treeColor = mix(vec3(0.0), vec3(0.1, 0.5, 0.1), tree);
    vec3 finalColor = mix(baseColor, treeColor, tree);
    
    gl_FragColor = vec4(finalColor, 1.0);
}