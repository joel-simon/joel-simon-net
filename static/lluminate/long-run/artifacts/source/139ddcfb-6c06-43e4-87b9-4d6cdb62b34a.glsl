precision mediump float;
varying vec2 uv;
uniform float time;

// Organic growth functions (sinuous waves)
float organic(vec2 p) {
    p *= 3.0;
    float wave = sin(p.x + sin(p.y + time));
    return smoothstep(0.3, 0.31, abs(wave));
}

// Mechanical fractal functions (iterative grid distortion)
float mechanical(vec2 p) {
    vec2 ip = floor(p * 5.0);
    vec2 fp = fract(p * 5.0);
    float grid = step(0.45, fp.x) * step(0.45, fp.y);
    for (int i = 0; i < 3; i++) {
        p = p * 2.0 + vec2(time * 0.1);
        grid += step(0.48, abs(fract(p.x) - 0.5))
             * step(0.48, abs(fract(p.y) - 0.5));
    }
    return clamp(grid * 0.2, 0.0, 1.0);
}

// Blend two conceptual spaces: organic growth and mechanical fractals
float emergentStructure(vec2 p) {
    // Map the two spaces: use polar coordinates for organic aspect
    vec2 center = p - 0.5;
    float radius = length(center);
    float angle = atan(center.y, center.x);
    vec2 polar = vec2(angle / 6.2831, radius);
    
    // Selectively blend: use organic function on polar and mechanical on uv
    float a = organic(polar);
    float b = mechanical(p);
    
    // Develop emergent property with non-linear blend
    return smoothstep(0.4, 0.6, a * (1.0 - b) + b * (1.0 - a));
}

void main() {
    vec2 p = uv;
    
    // Create background gradients with asymmetric color distribution 
    float d = length(p - 0.5);
    vec3 bgLeft = vec3(0.05, 0.1, 0.15);
    vec3 bgRight = vec3(0.2, 0.25, 0.35);
    vec3 background = mix(bgLeft, bgRight, p.x);
    background += 0.3 * (1.0 - smoothstep(0.3, 0.6, d));
    
    // Get emergent structure from blended functions
    float structure = emergentStructure(p);
    
    // Define color palettes from both input spaces
    vec3 organicColor = vec3(0.8, 0.5, 0.6); // warm organic tone
    vec3 mechanicalColor = vec3(0.4, 0.7, 0.9); // cool mechanical tone
    
    // Blend colors based on structure and vertical gradient
    vec3 structureColor = mix(organicColor, mechanicalColor, p.y);
    
    // Composite emergent structure onto the background using non-linear mixing
    vec3 finalColor = mix(background, structureColor, pow(structure, 1.2));
    
    gl_FragColor = vec4(finalColor, 1.0);
}