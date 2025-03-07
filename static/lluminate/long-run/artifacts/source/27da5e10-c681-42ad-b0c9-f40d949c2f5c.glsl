precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
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
    for (int i = 0; i < 6; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 reverseWarp(vec2 p, float t) {
    float n = noise(p * 5.0 - t);
    float angle = n * 6.2831;
    mat2 rot = mat2(cos(angle), sin(angle), -sin(angle), cos(angle));
    return rot * p * (0.8 + 0.2 * n);
}

vec2 reverseGlitch(vec2 p, float seed) {
    float t = time * 0.5 + seed;
    float shift = (noise(p * 8.0 + t) - 0.5) * 0.15;
    return p - vec2(shift, shift);
}

float radialDecay(vec2 p) {
    float r = length(p);
    return 1.0 - smoothstep(0.2, 0.5, r);
}

float quantize(float val, float levels) {
    return floor(val * levels) / levels;
}

void main() {
    // Map uv to centered coordinate system
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply two types of coordinate modulations, one for organic texture and one for digital decay.
    vec2 warped = reverseWarp(st, time * 0.5);
    vec2 glitched = reverseGlitch(warped, 1.23);
    
    // Compute an fbm fractal noise on the modified coordinates
    float f = fbm(glitched * 3.0 + time * 0.2);
    f = quantize(f, 8.0);
    
    // Radial decay to simulate fading from the center
    float decay = radialDecay(st);
    
    // Create a digital grid line overlay effect using fract
    vec2 grid = abs(fract(st * 10.0 - time * 0.3) - 0.5);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y));
    
    // Combine colors from noise pattern and grid overlay with decay influence.
    vec3 colorA = vec3(f * 0.6 + 0.2, f * 0.3 + 0.1, 1.0 - f) * decay;
    vec3 colorB = vec3(1.0 - f, f * 0.4, f * 0.8) * decay;
    vec3 baseColor = mix(colorA, colorB, step(0.5, line));
    
    // Add a pulsating digital inversion effect
    float pulse = sin(time * 3.0) * 0.5 + 0.5;
    vec3 finalColor = mix(baseColor, vec3(1.0) - baseColor, pulse);
    
    gl_FragColor = vec4(finalColor, 1.0);
}