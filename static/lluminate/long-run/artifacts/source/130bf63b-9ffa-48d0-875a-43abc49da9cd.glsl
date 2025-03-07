precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center the uv coordinates around (0.5, 0.5)
    vec2 pos = uv - 0.5;
    
    // Calculate angle and radius for polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a swirling pattern that varies over time
    float pattern = sin(radius * 20.0 - time * 2.0 + angle * 5.0);
    
    // Map pattern to a color palette with dynamic hues
    vec3 color = vec3(0.5 + 0.5 * pattern, 0.5 + 0.5 * sin(time + pattern * 3.1415), 0.5 - 0.5 * pattern);
    
    gl_FragColor = vec4(color, 1.0);
}