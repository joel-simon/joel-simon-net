precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(13.0, 37.0))) * 43758.5453);
}

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

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 errorGlitch(vec2 pos) {
    float glitch = step(0.95, fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453 + time));
    float offset = glitch * (noise(pos * 20.0 + time) - 0.5) * 0.15;
    return pos + vec2(offset, 0.0);
}

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

vec3 organicTree(vec2 pos, float t) {
    vec3 baseColor = vec3(0.1, 0.15, 0.2);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.1, 0.8, 0.3);
    float branchPattern = treeBranch(pos, t);
    float n = random(pos * 5.0 + t);
    vec3 color = mix(trunkColor, leafColor, branchPattern);
    color = mix(baseColor, color, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
    return color;
}

void main() {
    vec2 pos = uv;
    pos = (pos - 0.5) * (1.0 + 0.3 * sin(time * 0.7)) + 0.5;
    
    // Apply glitch distortion
    pos = errorGlitch(pos);
    
    // Convert to centered coordinates for vortex effect
    vec2 centered = (pos - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float vortex = sin(angle * 6.0 + time * 2.0 + fbm(centered * 3.0)) * 0.3;
    float mask = smoothstep(0.7 + vortex, 0.68 + vortex, radius);
    
    // Combine organic tree growth with digital glitch vortex
    vec3 treeColor = organicTree(pos, time);
    float organicTex = fbm(pos * 4.0 + time);
    vec3 cosmic = vec3(0.1, 0.2, 0.5) + 0.3 * vec3(sin(time), cos(time), sin(time * 0.5));
    vec3 glitchColor = vec3(0.0, 0.8, 0.5) * abs(sin(time * 3.0 + angle));
    vec3 colorMix = mix(cosmic, glitchColor, organicTex);
    
    // Blend tree growth with the glitch-inspired background
    vec3 finalColor = mix(colorMix, treeColor, 0.5 + 0.5 * treeBranch(pos, time));
    finalColor *= mask;
    
    gl_FragColor = vec4(finalColor, 1.0);
}