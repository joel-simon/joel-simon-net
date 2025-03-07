precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 reverseWarp(vec2 p, float t) {
    // Reverse assumption: Instead of warping forward based on noise, we warp by "un-perturbing" the coordinates.
    float n = noise(p * 5.0 - t);
    float angle = n * 6.2831;
    mat2 rot = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
    return rot * p * (0.8 + 0.2 * n);
}

float quantize(float val, float levels) {
    return floor(val * levels) / levels;
}

void main() {
    // Start with centered uv coordinates
    vec2 st = uv * 2.0 - 1.0;
    
    // Reverse the typical assumption of continuous warping:
    // Instead of continuously distorting, we "pull back" the fragmentation
    vec2 warped = reverseWarp(st, time * 0.5);
    
    // Create a fractal texture background using fbm, but quantize the value for a digital feel.
    float f = fbm(warped * 3.0 + time * 0.2);
    f = quantize(f, 8.0);
    
    // Introduce a digital grid pattern that challenges the assumption of smooth light gradients.
    vec2 grid = abs(fract(st * 10.0 - time * 0.3) - 0.5);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y));
    
    // Mix the fractal texture with the grid, inverting the polarity of the grid pattern.
    vec3 colorA = vec3(f * 0.6 + 0.2, f * 0.3 + 0.1, 1.0 - f);
    vec3 colorB = vec3(1.0 - f, f * 0.4, f * 0.8);
    vec3 baseColor = mix(colorA, colorB, step(0.5, line));
    
    // Overlay a pulsating "digital reversion" effect that periodically inverts the colors.
    float pulse = sin(time * 3.0) * 0.5 + 0.5;
    vec3 finalColor = mix(baseColor, vec3(1.0) - baseColor, pulse);
    
    gl_FragColor = vec4(finalColor, 1.0);
}