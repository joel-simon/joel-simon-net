precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Convert uv to centered coordinates [-1, 1]
    vec2 p = uv * 2.0 - 1.0;
    
    // Compute polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a dynamic swirling ripple combining radius and angle distortions
    float ripple = cos(8.0 * r - time * 2.5 + 4.0 * a);
    
    // Create a grid pattern using modulo arithmetic with a slight time-varying offset
    vec2 gridPos = p * 6.0;
    vec2 grid = abs(fract(gridPos) - 0.5);
    float line = smoothstep(0.45, 0.5, min(grid.x, grid.y));
    
    // Generate base colors influenced by the ripple and angular position
    vec3 color1 = 0.5 + 0.5 * cos(vec3(3.14 * ripple + time, 3.14 * ripple + time * 0.5, 3.14 * ripple - time));
    vec3 color2 = vec3(0.1, 0.2, 0.3) + 0.7 * vec3(0.5 + 0.5 * cos(a + time * 1.2),
                                                   0.5 + 0.5 * sin(a + time * 0.8),
                                                   0.5 + 0.5 * cos(a - time));
    
    // Blend the swirling ripple with the geometric grid lines
    vec3 mixedColor = mix(color1, color2, line);
    
    // Introduce a glitch effect using a pseudo-random function based on p
    float glitch = step(0.99, fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453));
    mixedColor += glitch * 0.3;
    
    // Apply a vignetting effect based on the distance from the center
    float vignette = smoothstep(0.8, 0.3, r);
    mixedColor *= vignette;
    
    gl_FragColor = vec4(mixedColor, 1.0);
}