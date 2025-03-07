precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center the coordinate system around (0,0)
    vec2 pos = uv - 0.5;
    
    // Compute polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create an animated radial pattern based on time and angle
    float pattern = sin(10.0 * radius - time * 2.0 + angle * 4.0);
    
    // Create a color based on the pattern and add some color variation with angle
    vec3 color = vec3(0.5 + 0.5 * sin(pattern + time),
                      0.5 + 0.5 * sin(pattern + time + 2.094),
                      0.5 + 0.5 * sin(pattern + time + 4.188));
    
    // Apply a smooth edge using the radial distance
    float vignette = smoothstep(0.7, 0.3, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}