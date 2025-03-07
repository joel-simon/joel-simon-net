precision mediump float;
varying vec2 uv;
uniform float time;

//
// Reversed Assumption: Instead of assuming "space" is empty and coordinates should be uniform, we assume that the entire canvas is alive and reactive. 
// We invert the common approach by making the center highly unstable and the edges stable.
//

// A simple hash for pseudo-randomness.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Noise function using hash.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Create a glitch/displacement effect that increases toward the center.
vec2 centerGlitch(vec2 p) {
    float dist = length(p);
    // Reverse assumption: noise-based offset increases as we approach zero.
    float strength = (1.0 - smoothstep(0.0, 1.0, dist)) * 0.1;
    float angle = noise(p * 10.0 + time) * 6.2831;
    return vec2(cos(angle), sin(angle)) * strength;
}

// Inverted vignette: brighten the edges and darken the center.
float invertedVignette(vec2 p) {
    float r = length(p);
    return smoothstep(0.0, 0.6, 1.0 - r);
}

void main(void) {
    // Remap uv to centered coordinates.
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply glitch effect that intensifies near the center.
    p += centerGlitch(p);
    
    // Create a swirling pattern influenced by fbm.
    float swirl = fbm(p * 3.0 - time);
    float angle = atan(p.y, p.x);
    float radius = length(p);
    
    // Reverse assumption: Instead of using static color palettes, we derive color from dynamic swirling noise.
    float dynamicWave = sin(angle * 8.0 + time * 3.0 + swirl * 6.2831);
    float structure = smoothstep(0.4, 0.5, radius + dynamicWave * 0.1);
    
    // Instead of a typical gradient that is more vibrant near the center, we reverse it: center is subdued, edges are luminous.
    vec3 centerColor = vec3(0.1, 0.1, 0.2);
    vec3 edgeColor = vec3(0.8, 0.9, 1.0) * invertedVignette(p);
    
    // Mix colors along the radial distance.
    vec3 color = mix(centerColor, edgeColor, radius);
    
    // Add a secondary mix from dynamic noise to add unpredictable glitches.
    vec3 glitchColor = vec3(0.9, 0.2 + 0.3 * sin(time + angle), 0.4);
    color = mix(color, glitchColor, smoothstep(0.3, 0.5, abs(dynamicWave)));
    
    // Final shape mask.
    color *= structure;
    
    gl_FragColor = vec4(color, 1.0);
}