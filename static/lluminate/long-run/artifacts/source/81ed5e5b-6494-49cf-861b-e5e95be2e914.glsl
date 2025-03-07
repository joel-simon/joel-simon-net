precision mediump float;
varying vec2 uv;
uniform float time;

// A helper function to perform a folding transformation based on an origami fold idea.
vec2 origamiFold(vec2 pos, float folds) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float foldAngle = 3.1415926 / folds;
    angle = mod(angle, 2.0 * foldAngle);
    angle = abs(angle - foldAngle);
    return vec2(cos(angle), sin(angle)) * radius;
}

// A helper function to generate a pseudo-random value based on input coordinates.
float random2d(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Domain 1: Celestial Mechanics - simulating orbiting lights.
    // Domain 2: Origami Art - structured folding pattern.
    
    // Center uv coordinates and apply a subtle zoom.
    vec2 st = (uv - 0.5) * 2.0;
    
    // Create multiple layers of orbital rings.
    float rings = 0.0;
    for (int i = 1; i <= 3; i++) {
        float factor = float(i);
        float angle = atan(st.y, st.x) + time * 0.5 / factor;
        float radius = length(st) * factor;
        // Introduce a folding effect from origami art on the phase.
        vec2 folded = origamiFold(vec2(cos(angle), sin(angle)), 4.0);
        float orbital = sin(radius - time * factor + folded.x * 2.0);
        rings += orbital / factor;
    }
    rings = abs(rings);
    
    // Create an origami-like grid that folds and unfolds.
    vec2 grid = fract(st * 4.0) - 0.5;
    grid = origamiFold(grid, 3.0);
    float gridPattern = smoothstep(0.3, 0.35, length(grid));
    
    // Synthesize both domains: blend orbital light with structured origami grid.
    float composite = mix(rings, gridPattern, 0.5 + 0.5 * sin(time));
    
    // Color dynamics: shifting between cosmic blue and origami white with a hint of gold.
    vec3 color1 = vec3(0.0, 0.3, 0.6);
    vec3 color2 = vec3(1.0, 0.9, 0.6);
    vec3 finalColor = mix(color1, color2, composite);
    
    // Final output with a gentle vignette.
    float vignette = smoothstep(0.9, 0.3, length(uv - 0.5));
    gl_FragColor = vec4(finalColor * vignette, 1.0);
}