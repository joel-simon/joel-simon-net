precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Transform uv to centered coordinates [-1, 1]
    vec2 p = uv * 2.0 - 1.0;
    
    // Compute polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a dynamic swirling ripple, combining angular modulation and radius distortion
    float ripple = cos(10.0 * r - time * 2.0 + 5.0 * a);
    
    // Create a twisting grid pattern effect using modulo arithmetic
    vec2 grid = abs(fract(p * 5.0) - 0.5);
    float line = smoothstep(0.45, 0.5, min(grid.x, grid.y));
    
    // Color based on polar angle and ripple effect
    vec3 color1 = 0.5 + 0.5 * cos(vec3(6.2831 * ripple + time, 6.2831 * ripple + time * 0.5, 6.2831 * ripple - time));
    vec3 color2 = vec3(0.0, 0.2, 0.4) + 0.8 * vec3(0.5 + 0.5 * cos(a + time), 0.5 + 0.5 * sin(a + time*0.7), 0.5 + 0.5 * cos(a - time*0.5));
    
    // Blend effects: the organic swirling ripple vs the geometric grid lines
    vec3 finalColor = mix(color1, color2, line);
    
    // Apply a vignetting effect based on radius
    float vignette = smoothstep(0.8, 0.3, r);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}