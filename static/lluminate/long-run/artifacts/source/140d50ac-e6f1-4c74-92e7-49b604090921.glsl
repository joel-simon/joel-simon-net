precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    // Fractal Brownian Motion
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Polar coordinates for swirling branches
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Anchor Concept: Stability represented by a sturdy cosmic tree.
    // Medium Association: A swirling, fractal tree structure emerging from an energy vortex.
    // Develop Association: Modulate tree branches with fbm to create organic, unexpected branching.
    
    // Create a branching pattern using polar modulation of angle and radius.
    float branch = abs(sin(5.0 * angle + time + 3.0 * fbm(pos * 3.0))) * 0.7;
    float trunk = smoothstep(0.4, 0.38, r);
    
    // Use fbm to carve organic texture into the branches
    float branches = smoothstep(branch, branch + 0.02, r);
    
    // Create a dynamic glow at the center, as if the tree is rooted in a cosmic vortex.
    float glow = 1.0 - smoothstep(0.0, 0.5, r);
    float pulse = 0.5 + 0.5 * sin(time * 2.0 + fbm(pos * 5.0));
    glow *= pulse;
    
    // Mix trunk, branches and glow to form the cosmic tree silhouette
    vec3 trunkColor = vec3(0.15, 0.1, 0.05);
    vec3 branchColor = vec3(0.1, 0.3, 0.2);
    vec3 glowColor = vec3(0.9, 0.7, 0.4);
    
    vec3 color = mix(trunkColor, branchColor, branches);
    color = mix(color, glowColor, glow * 0.5);
    
    // Add subtle digital glitch organic effects
    float glitch = noise(uv * 20.0 + time * 2.0);
    color += glitch * 0.06;
    
    // Final color blending with slight vignette
    float vignette = smoothstep(1.0, 0.2, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}