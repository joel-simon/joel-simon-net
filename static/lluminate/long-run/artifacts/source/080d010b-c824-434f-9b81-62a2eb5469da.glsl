precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.03;
    float shift = pseudoRandom(vec2(floor(pos.y * 20.0), t)) * amt;
    pos.x += shift;
    return pos;
}

float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 15.0 + t * 6.0));
    float n = smoothstep(0.3, 0.7, pseudoRandom(pos * t));
    return mix(stripes, n, 0.4);
}

// Creative Idea: Replace a common symbol (heart) with a tree, where growth (trait T) is essential.
// Tree silhouette function with fuzzy organic form.
float treeShape(vec2 p) {
    // Shift tree to lower half and center.
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 1.8;
  
    // Trunk: vertical barrier.
    float trunk = smoothstep(0.04, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.4);
    
    // Branches: undulating sine waves for texture.
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float branch = smoothstep(0.025, 0.02, abs(pos.x - 0.1 * sin(12.0 * pos.y + time + fi)));
        branch *= smoothstep(0.0, 0.4 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    // Canopy: a soft blob that replaces the typical heart shape.
    float canopy = smoothstep(0.45, 0.40, length(vec2(pos.x, pos.y - 0.8)));
    
    return max(trunk, max(branches, canopy));
}

// Color modulation combining organic tree aesthetics and digital glitch effects.
vec3 colorModulation(vec2 pos, float t, float treeMask) {
    float glitchPattern = stripedGlitch(pos, t);
    vec3 digitalColor = mix(vec3(0.1, 0.7, 0.8), vec3(0.9, 0.3, 0.2), glitchPattern);
    vec3 treeColor = mix(vec3(0.0, 0.3, 0.0), vec3(0.2, 0.8, 0.3), uv.y);
    return mix(digitalColor, treeColor, treeMask);
}

void main() {
    vec2 pos = uv;
    
    // Slight rotation for digital perturbation.
    float angle = sin(time * 0.5) * 0.12;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Evaluate tree shape (organic element replacing a heart symbol).
    vec2 p = uv;
    p.x += sin(time * 10.0 + uv.y * 20.0) * 0.005;
    float treeMask = treeShape(p);
    
    // Digital terrain created by fbm and glitch.
    vec2 fbmPos = pos * 4.0 + vec2(time * 0.2);
    float terrain = fbm(fbmPos);
    float glitch = (pseudoRandom(pos * time) - 0.5) * 0.3;
    float pattern = terrain + glitch;
    
    // Invert center intensity - focus on digital edge effects.
    float edgeFactor = 1.0 - length(uv - vec2(0.5));
    float intensity = smoothstep(0.3, 0.0, edgeFactor + pattern * 0.5);
    
    vec3 color = colorModulation(pos, time, treeMask);
    
    // Blend with additional glitch overlay.
    float glitchMask = smoothstep(0.2, 0.5, pattern);
    color = mix(color, vec3(0.9), glitchMask * 0.25);
    
    gl_FragColor = vec4(color * intensity, 1.0);
}