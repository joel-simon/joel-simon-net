precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Transform uv to a center-based coordinate system
    vec2 pos = uv * 2.0 - 1.0;
    
    // Calculate polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a dynamic wave pattern using sine functions
    float wave = sin(10.0 * radius - 3.0 * time + 5.0 * angle);
    
    // Use smoothstep to create bands of brightness
    float intensity = smoothstep(0.45, 0.5, wave);
    
    // Set the final color
    gl_FragColor = vec4(vec3(intensity), 1.0);
}