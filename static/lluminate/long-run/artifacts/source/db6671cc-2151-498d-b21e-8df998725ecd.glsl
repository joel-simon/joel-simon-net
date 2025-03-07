precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Shift uv to range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;

    // Create a dynamic rotation matrix based on time
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    vec2 rotatedPos = rot * pos;
    
    // Compute polar coordinates from the rotated position
    float d = length(rotatedPos);
    float a = atan(rotatedPos.y, rotatedPos.x);
    
    // Create a swirling wave pattern using sine of a combination of d, a, and time
    float swirl = sin(10.0 * d - time + a * 5.0);

    // Grid component: modulating pattern over original uv space
    float gridSize = 10.0;
    vec2 grid = fract(uv * gridSize + vec2(sin(time), cos(time)));
    float distX = abs(grid.x - 0.5);
    float distY = abs(grid.y - 0.5);
    float line = smoothstep(0.48, 0.5, distX) + smoothstep(0.48, 0.5, distY);
    
    // Create base color gradients based on the swirling effect
    vec3 col = vec3(
        0.5 + 0.5 * sin(swirl + time),
        0.5 + 0.5 * cos(swirl + time * 0.5),
        0.5 + 0.5 * sin(swirl + time * 0.7)
    );

    // Introduce glitchy grid lines: mix with black based on computed line pattern
    col = mix(col, vec3(0.0), line);

    // Vignette effect: darken the edges for depth
    float vignette = smoothstep(0.8, 0.3, d);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}