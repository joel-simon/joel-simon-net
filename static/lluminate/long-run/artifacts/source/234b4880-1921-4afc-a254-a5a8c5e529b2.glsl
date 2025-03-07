precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center UV coordinates
    vec2 pos = (uv - 0.5) * 2.0;  
    
    // Convert to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a dynamic spiral pattern, reversing typical rotation
    float spiral = cos(-6.0 * angle + time * 2.0);
    
    // Generate a grid pattern using modulus
    vec2 grid = mod(pos * 6.0, 1.0);
    float gridPattern = step(0.4, grid.x) * step(0.4, grid.y);
    
    // Blend a radial gradient with the spiral and grid effects
    float radial = 1.0 - smoothstep(0.3, 1.0, radius);
    float pattern = mix(spiral, gridPattern, 0.5) * radial;
    
    // Offset and blend color channels in a time-dependent fashion
    vec3 color;
    color.r = 0.5 + 0.5 * cos(time + pattern + angle);
    color.g = 0.5 + 0.5 * cos(time + pattern * 1.3 + angle + 1.0);
    color.b = 0.5 + 0.5 * cos(time + pattern * 1.7 + angle + 2.0);
    
    gl_FragColor = vec4(color, 1.0);
}