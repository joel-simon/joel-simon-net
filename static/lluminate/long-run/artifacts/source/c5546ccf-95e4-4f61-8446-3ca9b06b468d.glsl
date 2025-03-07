precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Normalize coordinates to center: from -1.0 to 1.0
    vec2 pos = uv * 2.0 - 1.0;
    
    // Calculate angle and radius from center
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create swirling effect with time and angle
    float swirl = sin(10.0 * r - time + angle * 3.0);
    
    // Color based on swirl and radial distance
    vec3 color = vec3(0.5 + 0.5 * cos(time + r*10.0 + vec3(0.0, 2.0, 4.0))) + swirl * 0.3;
    
    // Vignette effect for additional depth
    float vignette = smoothstep(0.8, 0.2, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}