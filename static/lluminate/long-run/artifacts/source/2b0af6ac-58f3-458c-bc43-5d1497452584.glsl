precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    vec2 pos = uv - 0.5;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a wave pattern based on radius and time.
    float wave = sin(radius * 20.0 - time * 5.0);
    
    // Generate color components based on angle and time.
    vec3 color = 0.5 + 0.5 * cos(time + angle + vec3(0.0, 2.0, 4.0));
    
    // Modulate the color intensity by the wave pattern.
    color *= wave;
    
    gl_FragColor = vec4(color, 1.0);
}