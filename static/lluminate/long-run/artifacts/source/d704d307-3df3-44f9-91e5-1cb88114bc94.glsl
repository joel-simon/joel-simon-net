precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Anchor and reposition UVs to center space and scale up for grid detail
    vec2 pos = (uv - 0.5) * 3.0;
    
    // Rotate coordinates with a twist that evolves over time
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
    
    // Generate a grid pattern using fract and smooth thresholding
    vec2 grid = abs(fract(pos) - 0.5);
    float gridLines = smoothstep(0.45, 0.47, min(grid.x, grid.y));
    
    // Create a dynamic radial glow that evolves with time
    float dist = length(uv - 0.5);
    float glow = 1.0 - smoothstep(0.3, 0.35 + 0.1 * sin(time), dist);
    
    // Mix two distinct color palettes based on the radial glow and overlay grid
    vec3 background = mix(vec3(0.15, 0.55, 0.75), vec3(0.8, 0.4, 0.2), glow);
    vec3 finalColor = mix(background, vec3(1.0), gridLines);
    
    gl_FragColor = vec4(finalColor, 1.0);
}