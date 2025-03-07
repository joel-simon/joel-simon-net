precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Shift uv to range [0,1] and then offset by time to create moving grid effects
    vec2 pos = uv;
    
    // Reverse the assumption: Instead of polar swirling centered effects, use a grid distortion
    // Create a grid pattern using mod and sin functions
    float gridSize = 10.0;
    vec2 grid = fract(pos * gridSize + vec2(sin(time), cos(time)));
    
    // Compute a smooth grid line pattern by blending the grid cells to create a continuous distortion
    float distX = abs(grid.x - 0.5);
    float distY = abs(grid.y - 0.5);
    float line = smoothstep(0.48, 0.5, distX) + smoothstep(0.48, 0.5, distY);
    
    // Use a nonlinear mapping: twist the grid pattern with time-based sine modulation
    float twist = sin((pos.x + pos.y) * 10.0 + time * 3.0);
    
    // Combine grid line pattern with twist effect and oscillate colors based on position and twist
    vec3 col = vec3(
        sin((grid.x + twist) * 6.2831 + time) * 0.5 + 0.5,
        cos((grid.y - twist) * 6.2831 + time * 0.75) * 0.5 + 0.5,
        sin((grid.x + grid.y) * 6.2831 + time * 1.5) * 0.5 + 0.5
    );
    
    // Mix the color with the grid lines to create stark contrast
    col = mix(col, vec3(0.0), line);
    
    gl_FragColor = vec4(col, 1.0);
}