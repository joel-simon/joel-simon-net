precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Create a swirling pattern based on uv and time.
    vec2 centeredUV = uv - 0.5;
    float angle = atan(centeredUV.y, centeredUV.x);
    float radius = length(centeredUV);
    
    // Applying a twisting effect with time.
    float twist = sin(radius * 10.0 - time * 2.0);
    float value = smoothstep(0.3 + twist * 0.1, 0.31 + twist * 0.1, radius);

    // Color based on angle for an interesting gradient effect.
    vec3 color = vec3(0.5 + 0.5 * cos(angle + time),
                      0.5 + 0.5 * sin(angle + time * 0.5),
                      0.5 + 0.5 * cos(angle - time * 0.5));
    
    // Blend the color with the pattern.
    gl_FragColor = vec4(color * value, 1.0);
}