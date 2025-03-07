precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = smoothstep(0.0, 1.0, fract(st));
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

vec3 reverseGravity(vec2 pos) {
    // Reverse the typical assumption of center brightness:
    // Instead, edge glows while center is dark.
    float dist = length(pos);
    float edgeGlow = smoothstep(0.3, 1.2, dist);
    // Invert noise modulation: chaos is stronger at the center
    float chaotic = noise(pos * 8.0 - time);
    float intensity = mix(chaotic, edgeGlow, 0.6);
    vec3 col = vec3(intensity * 0.2, intensity * 0.5, intensity);
    return col;
}

vec3 deconstructedPattern(vec2 pos) {
    // Reverse symmetry: shift the UV base mathematically with time-modulated offsets
    float angle = time * 1.2;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Create broken grid structure by inverting regular pattern logic
    vec2 grid = abs(fract(pos * 5.0 - 0.5) - 0.5);
    float line = smoothstep(0.45, 0.5, max(grid.x, grid.y));
    
    // Use reversed assumption: disable standard grid clarity,
    // introduce noise-dislodged interruptions.
    float glitch = noise(pos * 10.0 + time);
    float pattern = mix(line, glitch, 0.5);
    
    return vec3(pattern * 0.7, pattern * 0.9, pattern);
}

void main() {
    // Center the UV around 0 with deliberate asymmetry
    vec2 pos = uv - 0.5;
    
    // Apply a dynamic non-uniform distortion: different speeds in x and y
    pos.x *= 1.5 + 0.5 * sin(time * 1.7);
    pos.y *= 1.0 + 0.7 * cos(time * 1.1);
    
    // Combine reversed gravity glow with the deconstructed pattern
    vec3 colorA = reverseGravity(pos);
    vec3 colorB = deconstructedPattern(pos);
    
    // Blend them using a non-linear mask that inverts typical radial progression
    float mask = 1.0 - smoothstep(0.0, 0.8, length(pos) + 0.3 * sin(time*3.0));
    vec3 emergent = mix(colorB, colorA, mask);
    
    // Impart an extra layer of chaotic noise for unpredictability
    float overlay = noise(pos * 15.0 - time * 1.5);
    emergent += 0.1 * vec3(overlay * 0.8, overlay, overlay * 1.2);
    
    gl_FragColor = vec4(emergent, 1.0);
}