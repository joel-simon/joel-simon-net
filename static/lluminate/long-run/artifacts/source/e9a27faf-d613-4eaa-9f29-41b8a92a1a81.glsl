precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

// Swirl function for glitch/digital effect
vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Tree branch function using polar distortion and sine modulations
float treeBranch(vec2 pos, float t) {
    // Center coords in [-1,1]
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    // Modulated sinusoid for organic branch effect
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    // Emphasize center trunk decay
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

void main() {
    // Base UV coordinates centered around 0.0
    vec2 pos = uv;
    
    // Apply swirling glitch effect on a secondary coordinate set
    vec2 glitchPos = swirl(pos - 0.5, 3.0 * sin(time * 0.8));
    glitchPos += 0.5;
    
    // Create cosmic starburst effect
    vec2 centered = (pos - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float burst = abs(cos(8.0 * angle + time * 2.0));
    float star = smoothstep(0.4, 0.38, radius) * burst;
    
    // Calculate tree growth pattern from original and glitched coordinates
    float branch1 = treeBranch(pos, time);
    float branch2 = treeBranch(glitchPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Introduce layered noise for organic texture
    float n = noise(pos * 5.0 + time);
    float n2 = noise(glitchPos * 10.0 - time);
    
    // Base cosmic colors
    vec3 baseCosmic = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.1, 0.25), radius);
    // Starburst warm colors
    vec3 starColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), n2);
    // Tree organic colors
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    
    // Combine effects: cosmic background, starburst overlay, and organic tree pattern with glitch noise
    vec3 color = baseCosmic;
    color = mix(color, starColor, star);
    color = mix(color, treeColor, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
    
    gl_FragColor = vec4(color, 1.0);
}