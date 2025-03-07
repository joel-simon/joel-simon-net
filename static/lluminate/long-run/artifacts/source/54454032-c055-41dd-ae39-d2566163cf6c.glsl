precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random function based on UV coordinates.
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

void main(void) {
    // Do not assume a central symmetry.
    // Instead, manipulate a grid pattern that "breaks" the typical continuous image assumptions.
    vec2 gridUV = uv * 10.0;  // Create a grid of cells.
    vec2 cellIndex = floor(gridUV);
    vec2 cellUV = fract(gridUV);

    // Create a swirling noise inside each grid cell.
    float angle = time + rand(cellIndex) * 6.2831;
    float s = sin(angle), c = cos(angle);
    mat2 rotation = mat2(c, -s, s, c);
    cellUV = rotation * (cellUV - 0.5) + 0.5;
    
    // Reverse the common assumption that smooth shapes are always positive.
    // Here we invert thresholds to create unexpected negative spaces.
    float pattern = step(0.5, cellUV.x) * step(0.5, cellUV.y);
    pattern = 1.0 - pattern;

    // Introduce a glitch modulated by time and cell randomness.
    float glitch = sin((cellUV.x + cellUV.y + time) * 20.0 + rand(cellIndex) * 10.0);
    glitch = smoothstep(-0.1, 0.1, glitch);

    // Combine grid pattern and glitch effect.
    float mixVal = mix(pattern, glitch, 0.5);
    
    // Use a non-traditional color palette that contrasts digital structure with organic gradients.
    vec3 color1 = vec3(0.0, 0.8, 1.0); // Metallic cyan.
    vec3 color2 = vec3(1.0, 0.2, 0.4); // Vivid magenta.
    vec3 finalColor = mix(color1, color2, mixVal);
    
    // Final fragment output with full opacity.
    gl_FragColor = vec4(finalColor, 1.0);
}