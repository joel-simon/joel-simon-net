precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        total += amplitude * pseudoNoise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

void main() {
    // Anchor: "error" interpreted as a branching organic glitch
    // Transform uv to center coordinates
    vec2 pos = uv - vec2(0.5);
    
    // Rotate coordinates over time to simulate organic twisting
    float angle = time * 0.3;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Medium-distance association: tree branches emerging with fractal patterns
    // Compute fractal noise to simulate branch texture
    float branches = fbm(pos * 3.0 + time);
    
    // Create a branching mask using smoothstep, emphasizing medium detail
    float branchMask = smoothstep(0.4, 0.45, abs(pos.y) + 0.3 * branches);
    
    // Introduce random glitches to disturb the pattern in an organic manner
    float glitch = step(0.98, pseudoNoise(pos * 20.0 + time));
    
    // Color interpolation between deep earth and glitch inflections
    vec3 treeColor = mix(vec3(0.1, 0.1, 0.05), vec3(0.3, 0.2, 0.1), branches);
    vec3 glitchColor = vec3(0.8, 0.2, 0.5) * glitch;
    
    // Combine the base tree pattern with glitch artifacts
    vec3 color = mix(treeColor, glitchColor, glitch * 0.7);
    
    // Additional dynamic wave patterns to add organic shimmer
    float wave = sin(10.0 * length(pos) - time * 4.0);
    float waveMask = smoothstep(0.0, 0.1, abs(wave));
    
    // Final compositing using branch mask and wave mask to create delicate texture
    color *= branchMask;
    color += 0.2 * waveMask;
    
    gl_FragColor = vec4(color, 1.0);
}