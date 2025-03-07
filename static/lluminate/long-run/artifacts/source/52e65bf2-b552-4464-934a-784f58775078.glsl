precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on UV coordinates.
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Inverse distortion: Instead of ordering by distance, invert by applying chaos.
vec2 inverseDistort(vec2 pos, float t) {
    float distortStrength = 0.15 + 0.1 * sin(t * 2.0);
    float angle = pseudoRandom(pos * t) * 6.2831853;
    vec2 offset = vec2(cos(angle), sin(angle)) * distortStrength;
    return pos + offset;
}

// Death of symmetry: create an asymmetrical chaotic grid.
float chaoticGrid(vec2 pos, float t) {
    pos *= 10.0;
    vec2 index = floor(pos);
    vec2 f = fract(pos);
    float rng = pseudoRandom(index + t);
    float threshold = smoothstep(0.2, 0.8, rng);
    return smoothstep(threshold - 0.2, threshold + 0.2, length(f - vec2(0.5)));
}

// Channel disintegration: misalign each color channel with different distortions.
vec3 disintegrateColor(vec2 pos, float t) {
    vec2 posR = inverseDistort(pos, t);
    vec2 posG = inverseDistort(pos + 0.05, t * 1.1);
    vec2 posB = inverseDistort(pos - 0.05, t * 0.9);

    float gridR = chaoticGrid(posR, t);
    float gridG = chaoticGrid(posG, t);
    float gridB = chaoticGrid(posB, t);

    // Invert base assumption: chaotic intensity creates subtraction of light.
    vec3 color = vec3(1.0 - gridR, 1.0 - gridG, 1.0 - gridB);
    return color;
}

// Chaos blending: Combine patterned chaos with a swirling disruptive field.
vec3 chaosBlend(vec2 pos, float t) {
    // Radial inversion: instead of fading out with distance, intensify chaos.
    vec2 centered = pos - 0.5;
    float radius = length(centered) * 2.0;
    float swirl = sin(radius * 10.0 - t * 3.0);
    float chaotic = chaoticGrid(pos + swirl * 0.1, t);
    vec3 color = disintegrateColor(pos, t);
    // Blend in chaotic modulation.
    color *= mix(0.5, 1.5, chaotic);
    return color;
}

void main() {
    // Start with an assumption of orderly space, then defy it.
    vec2 pos = uv;
    
    // Invert symmetry through unpredictable distortions.
    pos = inverseDistort(pos, time);
    
    // Build the image upon chaotic disruption and reversed assumptions.
    vec3 finalColor = chaosBlend(pos, time);
    
    // Final tone: slight vignette to emphasize central disruption.
    float vignette = smoothstep(1.0, 0.2, distance(uv, vec2(0.5)));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}