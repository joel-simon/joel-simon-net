precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Normalize coordinates to -1.0 to 1.0
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create a rotation based on time
    float angle = time;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Compute distance and angle from center
    float d = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Create a swirling pattern based on distance and angle
    float swirl = sin(10.0 * d - time + a * 5.0);
    
    // Create color gradients based on swirling effect
    vec3 col = vec3(
        0.5 + 0.5 * sin(swirl + time),
        0.5 + 0.5 * cos(swirl + time * 0.5),
        0.5 + 0.5 * sin(swirl + time * 0.7)
    );
    
    // Darken outside the circle
    float mask = smoothstep(0.65, 0.60, d);
    col *= mask;
    
    gl_FragColor = vec4(col, 1.0);
}