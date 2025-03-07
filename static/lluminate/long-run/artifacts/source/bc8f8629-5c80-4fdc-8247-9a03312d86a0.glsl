precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
               u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

void main(void) {
    // Transform uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Conceptual Space A: Organic texture via fbm
    float organicFactor = fbm(pos * 3.0 + time);

    // Conceptual Space B: Digital grid distortion and glitch elements
    vec2 gridCoord = uv * 10.0;
    vec2 gridPattern = abs(fract(gridCoord - 0.5));
    float gridLines = smoothstep(0.45, 0.47, min(gridPattern.x, gridPattern.y));

    // Map cross-space: Modulate the organic texture with the grid values selectively
    float blendedSpace = mix(organicFactor, gridLines, 0.5 + 0.5 * sin(time + radius * 10.0));

    // Develop emergent: Introduce polar modulation based on angle for an additional swirl
    float polarMod = 0.5 + 0.5 * sin(angle * 4.0 + time);
    float emergent = mix(blendedSpace, polarMod, 0.5);

    // Color dynamics: blend warm and cool palettes
    vec3 warmColor = vec3(0.85, 0.4, 0.3);
    vec3 coolColor = vec3(0.3, 0.6, 0.9);
    vec3 finalColor = mix(warmColor, coolColor, emergent);

    gl_FragColor = vec4(finalColor, 1.0);
}