precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    // Anchor concept: celestial spiral; medium association: ripple distortions.
    // Transform uv to range [-1,1] for symmetry.
    vec2 st = uv * 2.0 - 1.0;
    
    // Convert to polar coordinates.
    float r = length(st);
    float angle = atan(st.y, st.x);
    
    // Create a swirling spiral pattern.
    float spiral = sin(8.0 * (angle + r * 2.0 - time));
    
    // Medium association: subtle ripple effects with pseudo randomness.
    float noise = pseudoRandom(vec2(r, angle));
    float ripple = sin(20.0 * r - time * 3.0 + noise * 6.2831);
    
    // Blend spiral and ripple using smooth transition.
    float blend = mix(spiral, ripple, 0.4);
    
    // Color palette based on the polar coordinates.
    vec3 color = vec3(0.5 + 0.5 * cos(angle + time),
                      0.5 + 0.5 * sin(r * 10.0 - time),
                      0.5 + 0.5 * cos(spiral * 3.0 + time));
                      
    // Apply a vignette effect for a focused centralized output.
    float vignette = smoothstep(1.0, 0.0, r);
    color *= vignette * blend;
    
    gl_FragColor = vec4(color, 1.0);
}