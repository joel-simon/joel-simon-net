precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Center the UV coordinates
    vec2 pos = uv - 0.5;
    
    // Convert to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Domain 1 (Visual/Sound Waves): Swirling pattern modulated by sinusoidal and cosine functions.
    float swirl = sin(radius * 20.0 - time * 3.0 + angle * 6.0);
    
    // Domain 2 (Biological Patterns): Introduce more organic complexity by layering secondary oscillations.
    float organic = cos(radius * 30.0 + time * 4.0) * sin(angle * 8.0 - time);
    
    // Synthesize two domains by blending their contributions
    float pattern = mix(swirl, organic, 0.5);
    
    // Craft color channels by mapping polar coordinates and time to unique hues.
    vec3 color;
    color.r = 0.5 + 0.5 * sin(pattern + time + radius * 10.0);
    color.g = 0.5 + 0.5 * cos(angle + time * 1.5);
    color.b = 0.5 + 0.5 * sin(angle + radius * 15.0 - time);
    
    // Apply a subtle vignette effect using smoothstep for organic blending along the edges.
    float vignette = smoothstep(0.7, 0.3, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}