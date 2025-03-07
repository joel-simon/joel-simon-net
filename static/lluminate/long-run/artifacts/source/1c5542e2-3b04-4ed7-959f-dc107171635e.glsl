precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center and scale uv coordinates
    vec2 p = uv - 0.5;
    p *= 2.0;
    
    // Rotate coordinates over time
    float angle = time * 0.5;
    float c = cos(angle);
    float s = sin(angle);
    mat2 rot = mat2(c, -s, s, c);
    p = rot * p;
    
    // Create a dynamic pattern with multiple sin waves
    float pattern = sin(10.0 * p.x + time) + sin(10.0 * p.y + time);
    
    // Create smooth color transitions
    vec3 color = vec3(0.5 + 0.5 * sin(pattern + vec3(0.0, 2.0, 4.0)));
    
    gl_FragColor = vec4(color, 1.0);
}