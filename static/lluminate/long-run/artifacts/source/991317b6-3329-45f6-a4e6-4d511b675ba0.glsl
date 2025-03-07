precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Shift UV coordinates to center around (0.0, 0.0)
    vec2 pos = uv - 0.5;
    
    // Calculate polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a wave pattern with time-based animation
    float wave = sin(10.0 * radius - time * 5.0 + 5.0 * sin(angle));
    
    // Define a color based on the wave pattern and angle
    vec3 color = vec3(0.5 + 0.5 * cos(angle + wave),
                      0.5 + 0.5 * sin(wave + time),
                      0.5 + 0.5 * cos(wave - angle));
    
    gl_FragColor = vec4(color, 1.0);
}