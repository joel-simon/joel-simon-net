precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Reverse the common assumption of polar-based swirling by using a grid-based glitch effect.
    vec2 gridUV = uv * 10.0;
    vec2 id = floor(gridUV);
    vec2 f = fract(gridUV);
    
    // Create a glitch shift that disrupts the uniform grid pattern over time.
    float glitch = sin(time + id.x * 0.7 + id.y * 1.3);
    f += (glitch - 0.5) * 0.2;
    
    // Generate a checker pattern among grid cells
    float checker = mod(id.x + id.y, 2.0);
    
    // Color modulation based on the grid position and glitch effect.
    vec3 color1 = vec3(0.2, 0.6, 0.9);
    vec3 color2 = vec3(0.9, 0.3, 0.5);
    vec3 baseColor = mix(color1, color2, checker);
    
    // Emphasize the glitch effect with a radial darkening from the center
    vec2 centeredUV = uv - 0.5;
    float vignette = smoothstep(0.5, 0.2, length(centeredUV));
    
    // Combine the glitch detail with the base grid pattern.
    float detail = smoothstep(0.4, 0.5, length(f - 0.5 + 0.5 * sin(time)));
    vec3 finalColor = mix(baseColor, vec3(0.0), detail);
    
    gl_FragColor = vec4(finalColor * vignette, 1.0);
}