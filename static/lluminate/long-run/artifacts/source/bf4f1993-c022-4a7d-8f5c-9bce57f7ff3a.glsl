precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Tree branch function simulating organic growth
float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = sin(t * 0.5) * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    float branch = smoothstep(0.2, 0.3, abs(wave) * trunk);
    return branch;
}

// Glitch effect with color channel offsets
vec3 glitchColor(vec2 pos, float t) {
    float r = random(pos + vec2(t * 0.1, 0.0));
    float g = random(pos + vec2(0.0, t * 0.15));
    float b = random(pos + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, random(pos * 50.0 + t));
    return mix(col, vec3(1.0), glitch);
}

// Synthesize organic growth with digital glitch aesthetics
vec3 synthesizeScene(vec2 pos, float t) {
    // Base color background
    vec3 baseColor = vec3(0.1, 0.15, 0.2);
    
    // Organic tree growth detail
    float branchDetail = treeBranch(pos, t);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor  = vec3(0.1, 0.8, 0.3);
    vec3 organicColor = mix(trunkColor, leafColor, branchDetail);
    organicColor = mix(baseColor, organicColor, smoothstep(0.15, 0.35, branchDetail + random(pos * 5.0 + t) * 0.2));
    
    // Glitch overlay effect
    vec3 glitch = glitchColor(pos * 2.0, t);
    
    // Create swirling pattern for cosmic feel
    vec2 centered = pos - 0.5;
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    float spiral = sin(10.0 * radius - t * 4.0 + angle * 5.0);
    float pattern = smoothstep(0.2, 0.3, radius + 0.1 * spiral);
    
    // Mix glitch with organic growth
    vec3 mixedColor = mix(organicColor, glitch, 0.25);
    mixedColor *= pattern;
    
    // Vignette effect for depth
    float vignette = smoothstep(0.7, 0.3, radius);
    mixedColor *= vignette;
    
    return mixedColor;
}

void main() {
    // Apply a gentle zoom and pan effect
    vec2 pos = (uv - 0.5) * (1.0 + 0.3 * sin(time * 0.7)) + 0.5;
    
    vec3 color = synthesizeScene(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}