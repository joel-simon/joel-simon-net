precision mediump float;
varying vec2 uv;
uniform float time;

float fractalTree(vec2 pos, float t) {
    // Reverse polar coordinates for a fractal branch impression.
    float angle = atan(pos.y, pos.x) - t * 0.5;
    float radius = length(pos);
    // Create branch-like features by repeating angular pattern.
    float branches = abs(sin(6.0 * angle));
    // Emulate fractal recursion with logarithmic scaling.
    float detail = smoothstep(0.2, 0.25, log(radius + 1.0));
    return branches * detail;
}

void main(void) {
    // Center uv to [-1,1].
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply reverse transformation to emulate time inversion.
    pos *= 1.0 + 0.5 * sin(time * -0.7);
    
    // Rotate coordinates slowly.
    float sine = sin(time * 0.3);
    float cosine = cos(time * 0.3);
    pos = mat2(cosine, -sine, sine, cosine) * pos;
    
    // Use SCAMPER operations: Substitute phoenix with a mystical tree;
    // Combine fractal modulation with reverse rotation.
    float treeMod = fractalTree(pos, time);
    
    // Create a glowing core that expands and contracts with time.
    float centerGlow = smoothstep(0.3, 0.28, length(pos));
    
    // Synthesize the final mask.
    float shape = smoothstep(0.35 + treeMod * 0.1, 0.33 + treeMod * 0.1, length(pos));
    
    // Color modulation: organic greens merging with digital glitch blue.
    vec3 colorTree = vec3(0.1, 0.5 + 0.3 * sin(time + pos.x * 3.0), 0.2);
    vec3 colorGlitch = vec3(0.0, 0.2, 0.5 + 0.4 * cos(time + pos.y * 3.0));
    vec3 col = mix(colorTree, colorGlitch, treeMod);
    
    // Add reversing bright pulses.
    float pulse = smoothstep(0.0, 0.04, abs(fract(time * 0.5) - 0.5));
    col += pulse * centerGlow * 0.6;
    
    // Final shaping using the mask.
    col *= shape;
    
    gl_FragColor = vec4(col, 1.0);
}