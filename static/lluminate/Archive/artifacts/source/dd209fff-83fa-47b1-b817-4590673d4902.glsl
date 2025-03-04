precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    vec2 pos = uv - 0.5;
    float radius = length(pos) * 2.0;
    float angle = atan(pos.y, pos.x);
    
    // Create a dynamic swirling pattern
    float pattern = sin(radius * 10.0 - time * 3.0 + angle * 5.0);
    
    // Color based on the pattern and time
    vec3 color = vec3(
        0.5 + 0.5 * cos(time + pattern),
        0.5 + 0.5 * sin(time + pattern + 1.0),
        0.5 + 0.5 * cos(time + pattern + 2.0)
    );
    
    gl_FragColor = vec4(color, 1.0);
}