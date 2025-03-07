precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo random function using sine
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = smoothstep(0.0, 1.0, fract(st));
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

// Rotate a 2D vector by an angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Gear shape using polar coordinates (mechanical motif)
float gear(vec2 pos, float t) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float spikes = 8.0;
    float gearShape = abs(sin(spikes * angle + t)) * 0.3;
    return smoothstep(gearShape, gearShape + 0.02, radius);
}

// Tree branch pattern using sinusoidal modulation (organic motif)
float tree(vec2 pos, float t) {
    pos.y += 0.5;
    float branch = smoothstep(0.02, 0.0, abs(pos.x - 0.2 * sin(pos.y * 12.0 + t * 3.0)));
    branch += smoothstep(0.02, 0.0, abs(pos.x + 0.2 * sin(pos.y * 10.0 + t * 2.5)));
    branch += (random(pos * (t + 1.0)) - 0.5) * 0.1;
    return branch;
}

// Reverse gravity glow: center dark, edges lit with noise modulated brightness
vec3 reverseGravity(vec2 pos) {
    float dist = length(pos);
    float edgeGlow = smoothstep(0.3, 1.2, dist);
    float chaotic = noise(pos * 8.0 - time);
    float intensity = mix(chaotic, edgeGlow, 0.6);
    return vec3(intensity * 0.2, intensity * 0.5, intensity);
}

// Create a deconstructed pattern inspired by fragmentation of symbol S replaced by subject P
vec3 deconstructedPattern(vec2 pos) {
    float angle = time * 1.2;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    vec2 grid = abs(fract(pos * 5.0 - 0.5) - 0.5);
    float line = smoothstep(0.45, 0.5, max(grid.x, grid.y));
    float glitch = noise(pos * 10.0 + time);
    float pattern = mix(line, glitch, 0.5);
    return vec3(pattern * 0.7, pattern * 0.9, pattern);
}

void main() {
    // Center uv and create asymmetry
    vec2 pos = uv - 0.5;
    
    // Dynamic distortion on pos
    pos.x *= 1.5 + 0.5 * sin(time * 1.7);
    pos.y *= 1.0 + 0.7 * cos(time * 1.1);
    
    // Split domain: left for mechanical gear, right for organic tree
    float domainMix = smoothstep(-0.05, 0.05, pos.x);
    
    vec2 gearPos = pos;
    gearPos = rotate(gearPos, time * 0.5);
    float gearPattern = gear(gearPos, time);
    
    vec2 treePos = pos;
    float treePattern = tree(treePos, time);
    
    float patternMix = mix(gearPattern, treePattern, domainMix);
    
    // Use the reverse gravity glow and deconstructed artifact as overlay elements
    vec3 colorA = reverseGravity(pos);
    vec3 colorB = deconstructedPattern(pos);
    
    // Combine mechanical/organic domain with chaotic overlays highlighting the key trait shift
    vec3 baseColor;
    vec3 mechColor = mix(vec3(0.3, 0.4, 0.5), vec3(0.6, 0.7, 0.8), gearPattern);
    vec3 organColor = mix(vec3(0.2, 0.1, 0.0), vec3(0.4, 0.3, 0.1), treePattern);
    baseColor = mix(mechColor, organColor, domainMix);
    
    // Blend overlay patterns with base
    vec3 emergent = mix(colorB, colorA, 1.0 - smoothstep(0.0, 0.8, length(pos) + 0.3 * sin(time * 3.0)));
    emergent = mix(baseColor, emergent, 0.5);
    
    // Final chaotic noise layer
    float overlay = noise(pos * 15.0 - time * 1.5);
    emergent += 0.1 * vec3(overlay * 0.8, overlay, overlay * 1.2);
    
    gl_FragColor = vec4(emergent, 1.0);
}