precision mediump float;
varying vec2 uv;
uniform float time;

void main(void) {
    // Convert uv to center-based coordinates, aspect correction applied if needed.
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;

    // Rotation transformation based on time
    float angle = time;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    vec2 rotatedPos = rot * pos;
    
    // Polar coordinates calculations
    float radius = length(rotatedPos);
    float theta = atan(rotatedPos.y, rotatedPos.x);
    
    // Create swirling wave and reversed assumptions on geometry:
    // Instead of assuming radial fade, we mix inversion of radius logic.
    float wave1 = sin(10.0 * radius - time + theta * 5.0);
    float wave2 = sin(20.0 * radius - time * 2.0 + theta * 3.0);
    
    // Reverse assumption: Instead of light at center, we compute highlight at edges
    float edgeHighlight = smoothstep(0.5, 0.9, radius);
    
    // Combine dual effects: swirling and ripple waves:
    float combinedWave = mix(wave1, wave2, 0.5);
    
    // Base color channels modulated by time, angle, and inverted radial highlight.
    vec3 color = vec3(
        0.5 + 0.5 * sin(combinedWave + time + theta),
        0.5 + 0.5 * cos(combinedWave + time * 0.5 + theta),
        0.5 + 0.5 * sin(combinedWave + time * 0.7 - theta)
    );
    
    // Mix with white highlight based on swirling pattern and edge highlight.
    float mixFactor = smoothstep(-0.2, 0.2, combinedWave) * edgeHighlight;
    color = mix(color, vec3(1.0), mixFactor);
    
    gl_FragColor = vec4(color, 1.0);
}