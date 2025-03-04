precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Normalize coordinates to center (range -1 to 1)
    vec2 p = uv * 2.0 - 1.0;
    
    // Compute radial distance
    float r = length(p);
    
    // Create a dynamic pattern using sine functions
    float angle = atan(p.y, p.x);
    float waves = sin(10.0 * r - time * 2.0 + sin(angle * 5.0));
    
    // Color using a mix of gradients based on wave pattern and radial distance
    vec3 color1 = vec3(0.2, 0.4, 0.8);
    vec3 color2 = vec3(0.8, 0.4, 0.2);
    vec3 color = mix(color1, color2, smoothstep(-0.5, 0.5, waves));
    
    // Additional vignette effect
    color *= smoothstep(1.2, 0.7, r);
    
    gl_FragColor = vec4(color, 1.0);
}