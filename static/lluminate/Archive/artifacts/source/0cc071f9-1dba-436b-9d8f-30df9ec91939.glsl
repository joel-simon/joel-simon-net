precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center coordinates relative to middle
    vec2 pos = uv - vec2(0.5);
    
    // Create a swirling effect by rotating the coordinates over time
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rotation = mat2(c, -s, s, c);
    pos = rotation * pos;
    
    // Create a radial pattern based on distance from center
    float radius = length(pos);
    
    // Create a dynamic pattern using sine functions
    float spiral = sin(20.0 * radius - time * 5.0);
    float ring = smoothstep(0.2, 0.21, abs(spiral));
    
    // Mix colors based on UV and dynamic patterns
    vec3 color1 = vec3(0.4, 0.2, 0.7);
    vec3 color2 = vec3(0.9, 0.6, 0.2);
    
    // Compute final color by blending based on the ring pattern
    vec3 color = mix(color1, color2, ring);
    
    // Add an outer glow by using smoothstep on radius
    float glow = smoothstep(0.5, 0.45, radius);
    color += glow * 0.3;
    
    // Write the final fragment color
    gl_FragColor = vec4(color, 1.0);
}