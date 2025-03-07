precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Transform uv to center coordinate system
    vec2 pos = uv * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Anchor concept: natural, organic growth patterns
    // Medium-distance association: fractal tree branches
    // Develop association: use layered wave modulations to mimic branching complexity

    // Base wave pattern combining radius and time for rhythmic pulses
    float baseWave = sin(12.0 * r - time * 2.5);
    
    // Intermediate pattern to mimic branching (branching frequencies)
    float branchWave = sin(8.0 * a + time * 1.5);
    
    // Mix layer influencing branch thickness and flicker
    float branchMix = sin(4.0 * r + branchWave * 2.0 - time);
    
    // Combine patterns to create a complex textured result
    float combined = smoothstep(0.2, 0.5, baseWave + branchMix * 0.5);
    
    // Add subtle shifting color layers using cosine modulation based on angle shifts
    vec3 color = vec3(
        0.5 + 0.5 * cos(time + combined + a),
        0.5 + 0.5 * cos(time + 2.0 * combined + a + 2.0),
        0.5 + 0.5 * cos(time + 3.0 * combined + a + 4.0)
    );
    
    // Add a vignette effect to highlight the center, mimicking depth
    float vignette = smoothstep(0.8, 0.3, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}