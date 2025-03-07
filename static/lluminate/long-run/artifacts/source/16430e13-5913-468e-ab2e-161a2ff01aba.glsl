precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // Reverse assumption: Rather than centering uv, we assume the coordinate origin is at the top-left.
    // Instead, we use uv directly and interpret it unconventionally.
    vec2 pos = uv;
    
    // Instead of polar coordinates based on centered uv, use a "mirrored" coordinate system via reversed mappings.
    vec2 revPos = vec2(1.0 - pos.x, 1.0 - pos.y);
    
    // Generate a disjoint domain by mixing normal and reversed coordinates.
    vec2 mixedPos = mix(pos, revPos, 0.5 + 0.5 * sin(time));
    
    // Generate a pseudo-radial coordinate but with reversed influence: lower distance means farther out.
    float d = 1.0 - length(mixedPos - vec2(0.3, 0.7));
    
    // Create an "impossible" swirl that defies expected cosmic symmetry.
    float angle = atan(mixedPos.y - 0.7, mixedPos.x - 0.3);
    float reversedAngle = -angle + time * 0.75;
    
    // Introduce glitch: Instead of addition, subtract noise influences.
    float noise = pseudoNoise(mixedPos * 20.0 - time * 3.0);
    float glitch = sin(reversedAngle * 10.0 - d * 40.0) - noise * 0.3;
    
    // Create striking color transitions: Instead of cosmic gradients, use unconventional, almost neon hue shifts
    vec3 colorA = vec3(0.1, 0.95, 0.85);
    vec3 colorB = vec3(0.95, 0.2, 0.3);
    float mixFactor = smoothstep(0.2, 0.8, glitch);
    vec3 baseColor = mix(colorA, colorB, mixFactor);
    
    // Overlay extra fragmented glitch details that challenge digital smoothness.
    float glitchPattern = step(0.95, pseudoNoise(vec2(time * 1.5, reversedAngle * 5.0)));
    vec3 finalColor = baseColor + vec3(glitchPattern * 0.6, -glitchPattern * 0.3, glitchPattern * 0.4);
    
    // Final brightness modulation using the reversed radial coordinate.
    float brightness = smoothstep(0.0, 1.0, d + noise * 0.25);
    
    gl_FragColor = vec4(finalColor * brightness, 1.0);
}