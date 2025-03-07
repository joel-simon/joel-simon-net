precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Transform uv into centered coordinates and rotate to reverse typical orientation
    vec2 pos = (uv - 0.5) * 2.0;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // SCAMPER Operations:
    // 1. Eliminate: Remove typical organic sin wave; instead, use a sharp modular grid
    // 2. Reverse: Invert the radial gradient to create a moon-like effect
    // 3. Combine: Merge a spiral modulation with the grid
    
    // Create a spiral pattern based on reversed angle progression
    float spiral = cos(-4.0 * angle + time * 1.5);
    
    // Create a grid pattern using modulus (eliminating smooth organic waves)
    vec2 grid = mod(pos * 5.0, 1.0);
    float gridPattern = step(0.45, grid.x) * step(0.45, grid.y);
    
    // Invert the radial gradient to emphasize the outer regions
    float invertedRadial = 1.0 - smoothstep(0.0, 1.0, radius);
    
    // Blend spiral and grid patterns
    float pattern = mix(spiral, gridPattern, 0.6) * invertedRadial;
    
    // Construct color channels with offset phases and mixed bases
    vec3 color;
    color.r = 0.5 + 0.5 * cos(time + pattern + angle);
    color.g = 0.5 + 0.5 * cos(time + pattern * 1.3 + angle + 1.0);
    color.b = 0.5 + 0.5 * cos(time + pattern * 1.7 + angle + 2.0);
    
    gl_FragColor = vec4(color, 1.0);
}