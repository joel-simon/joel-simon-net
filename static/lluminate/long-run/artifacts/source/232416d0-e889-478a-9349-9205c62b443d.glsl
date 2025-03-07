precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 31.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 reverseWarp(vec2 p, float seed) {
    // Reverse operation: subtract a modulated noise factor to create a decaying warp
    float t = time * 0.3 + seed;
    float offset = (noise(p * 5.0 + t) - 0.5) * 0.25;
    return p - vec2(offset, -offset);
}

float centralDecay(vec2 p) {
    // Reverse typical radial growth: intense at center, then rapid decay outward.
    float r = length(p);
    return 1.0 - smoothstep(0.1, 0.5, r);
}

void main() {
    // Base transformation: center the coordinates and amplify them.
    vec2 st = uv * 2.0 - 1.0;
    st *= 1.2;
    
    // Apply a reverse warp using the new seed.
    vec2 warped = reverseWarp(st, 2.34);
    
    // Generate a fractal noise pattern.
    float fractal = fbm(warped * 3.0);
    
    // Apply a reverse decay that diminishes brightness outward.
    float decay = centralDecay(warped);
    
    // Create a dynamic gradient influenced by fractal modulation
    vec3 colorA = vec3(0.8, 0.2, 0.5);
    vec3 colorB = vec3(0.1, 0.8, 0.7);
    vec3 gradient = mix(colorA, colorB, uv.y);
    
    // Introduce digital interruption using periodic bands.
    float band = step(0.9, fract(fractal * 10.0 - time * 0.8));
    vec3 digital = vec3(0.0, 0.0, 0.0);
    
    // Merge effects: blend the gradient modulated by fractal noise and decay,
    // and overlay digital bands.
    vec3 finalColor = mix(gradient * decay * fractal, digital, band * 0.35);
    
    gl_FragColor = vec4(finalColor, 1.0);
}