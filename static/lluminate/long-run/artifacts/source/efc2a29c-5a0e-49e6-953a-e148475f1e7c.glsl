precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Domain 1: Analytical grid and geometric shapes.
    // Domain 2: Organic rhythms of marine bioluminescence.
    // Synthesize by mapping grid distortions to fluid, organic patterns.
    
    // Center the coordinates
    vec2 pos = uv - 0.5;
    
    // Create a subtle rotating wave pattern mimicking tidal movement.
    float angle = time * 0.5;
    float s = sin(angle), c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Generate base grid pattern using sine waves (analytical domain)
    float grid = sin(pos.x * 20.0) * sin(pos.y * 20.0);
    
    // Introduce organic ripple using radial distance and time modulation (marine bioluminescence)
    float dist = length(pos);
    float ripple = sin((dist - time * 2.0) * 30.0);
    
    // Combine grid and ripple in a non-linear fashion
    float combined = mix(grid, ripple, 0.5);
    
    // Enhance organic glow effect with a smooth radial fade
    float glow = smoothstep(0.3, 0.0, dist);
    
    // Map the result to a color palette with deep blue and bright neon accents
    vec3 baseColor = vec3(0.0, 0.05, 0.2);
    vec3 neon = vec3(0.0, 0.8, 1.0) * abs(combined);
    vec3 color = mix(baseColor, neon, glow);
    
    gl_FragColor = vec4(color, 1.0);
}