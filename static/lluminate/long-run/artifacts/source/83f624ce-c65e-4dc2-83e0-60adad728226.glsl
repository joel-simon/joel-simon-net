precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Transform uv coordinates to range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Calculate polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a dynamic wave effect that oscillates with time and angle
    float wave = sin(10.0 * radius - time * 5.0 + angle * 3.0);
    
    // Generate colors using shifting cosine functions for a smooth gradient effect
    vec3 color = 0.5 + 0.5 * cos(time + vec3(0.0, 2.0, 4.0) + angle + radius);
    
    // Modulate the color by the wave effect for dynamic motion
    color *= wave;
    
    gl_FragColor = vec4(color, 1.0);
}