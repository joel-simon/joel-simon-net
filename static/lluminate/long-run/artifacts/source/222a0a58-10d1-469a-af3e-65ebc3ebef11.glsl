precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    // Center the coordinates
    vec2 pos = uv - 0.5;
    
    // Conceptual Space 1: Polar swirling spiral effect
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    // Create a spiral pattern using angle and logarithmic radius
    float spiral = sin(4.0 * a + 8.0 * log(r + 0.0001) - time * 2.0);
    
    // Conceptual Space 2: Tiling grid pattern
    // Generate a grid by repeating the uv coordinates
    vec2 gridPos = fract(uv * 10.0) - 0.5;
    // Create soft grid lines with a smooth threshold
    float gridPattern = smoothstep(0.4, 0.45, length(gridPos));
    
    // Blend the two conceptual spaces selectively
    // The blend factor oscillates over time to reveal emergent properties.
    float blend = mix(spiral, gridPattern, 0.5 + 0.5 * sin(time));
    
    // Develop emergent color properties by combining two color mappings
    vec3 colorA = vec3(0.5 + 0.5 * cos(time + blend + vec3(0.0, 2.0, 4.0)));
    vec3 colorB = vec3(0.5 + 0.5 * sin(time + 3.0 * blend + vec3(4.0, 2.0, 0.0)));
    vec3 col = mix(colorA, colorB, 0.5 + 0.5 * cos(spiral * 3.1416));
    
    // Apply a vignette effect based on distance from the center
    float vignette = smoothstep(0.0, 0.7, 1.0 - r);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}