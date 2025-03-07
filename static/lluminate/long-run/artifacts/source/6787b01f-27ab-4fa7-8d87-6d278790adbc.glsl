precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(13.13, 91.91))) * 753.5453);
}

vec3 honorError(vec2 uv, float t) {
    // "Honor thy error as a hidden intention": embrace unpredictable offsets.
    float r = pseudoNoise(uv * 30.0 + vec2(t * 0.2, t * 0.3));
    float g = pseudoNoise(uv * 20.0 + vec2(-t * 0.15, t * 0.25));
    float b = pseudoNoise(uv * 40.0 + vec2(t * 0.1, -t * 0.2));
    // Introduce abrupt error zones
    float glitch = step(0.97, pseudoNoise(uv * 50.0 - vec2(t)));
    return mix(vec3(r, g, b), vec3(1.0 - r, 1.0 - g, 1.0 - b), glitch);
}

void main() {
    // Translate uv to center domain
    vec2 pos = uv - 0.5;
    
    // Apply a random card: "Honor thy error as a hidden intention"
    // Mix a rotated coordinate space with glitch error offsets:
    float angle = time * 0.5;
    float ca = cos(angle);
    float sa = sin(angle);
    mat2 rotation = mat2(ca, -sa, sa, ca);
    vec2 rotatedPos = rotation * pos;
    
    // Create dual layers: an organic wave and an error signal
    float wave = sin(10.0 * length(rotatedPos) - time * 3.0 + atan(rotatedPos.y, rotatedPos.x) * 4.0);
    float organic = smoothstep(0.2, 0.25, wave);
    
    // Generate hidden errors in the absolute pattern
    vec3 errorColor = honorError(pos * 3.0, time);
    
    // Fuse the layers using paradoxical blend: embrace error signals in the organic form
    vec3 organicColor = mix(vec3(0.0, 0.1, 0.3), vec3(0.8, 0.5, 0.2), length(pos) * 2.0);
    vec3 finalColor = mix(organicColor, errorColor, organic * 0.5);
    
    // Introduce a vignette that honors imperfections at the edges
    float vignette = smoothstep(0.6, 0.3, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}