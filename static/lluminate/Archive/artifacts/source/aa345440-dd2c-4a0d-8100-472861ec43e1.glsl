precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center uv coordinates and create polar coordinates
    vec2 pos = uv - 0.5;
    float radius = length(pos) * 2.0;
    float angle = atan(pos.y, pos.x);
    
    // Create a time-evolving swirling distortion
    float swirl = sin(radius * 10.0 - time * 3.0 + angle * 4.0);
    float distortion = smoothstep(0.0, 1.0, swirl + 0.5);
    
    // Apply twisting effect by modifying angle with a time based offset and swirling distortion
    float twist = angle + distortion * 3.14 * 0.5;
    
    // Create a dynamic pattern using combined sine waves on polar coordinates
    float pattern = sin(10.0 * radius - time * 2.0) + cos(8.0 * twist + time);
    pattern = pattern * 0.5 + 0.5;
    
    // Compute color gradients: base colors mix through radial and angular components
    vec3 color1 = vec3(0.1, 0.2, 0.7);
    vec3 color2 = vec3(0.8, 0.4, 0.2);
    vec3 color3 = vec3(0.3, 0.8, 0.5);
    
    // Color based on radius and twist dynamics, using smooth transitions
    vec3 color = mix(color1, color2, smoothstep(0.0, 1.0, radius));
    color = mix(color, color3, sin(twist + time) * 0.5 + 0.5);
    color *= pattern;
    
    gl_FragColor = vec4(color, 1.0);
}