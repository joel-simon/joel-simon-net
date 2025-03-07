precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
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

float glitch(vec2 p, float t) {
    float g = random(p * 20.0 + t);
    // Create occasional glitch stripes
    float stripes = step(0.95, g);
    return stripes;
}

vec3 cosmicGradient(vec2 p) {
    vec2 center = vec2(0.5);
    float dist = length(p - center);
    vec3 color1 = vec3(0.1, 0.15, 0.2);
    vec3 color2 = vec3(0.9, 0.8, 1.0);
    return mix(color1, color2, smoothstep(0.0, 0.7, dist));
}

void main() {
    vec2 pos = uv;
    
    // Introduce gentle zoom and pan effect to emphasize organic dynamics
    pos = (pos - 0.5) * (1.0 + 0.3 * sin(time * 0.7)) + 0.5;
    
    // Generate cosmic background using radial gradient
    vec3 bgColor = cosmicGradient(pos);
    
    // Generate tree branch pattern
    float branchPattern = treeBranch(pos, time);
    
    // Blend trunk color with leaf/fresh color
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.1, 0.8, 0.3);
    float blendFactor = smoothstep(0.0, 0.6, (pos.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, blendFactor);
    
    // Integrate glitch effect simulating digital distortions
    float glitchEffect = glitch(pos, time);
    
    // Composite the branch pattern and glitch into the final tree representation
    vec3 compositeTree = mix(bgColor, treeColor, branchPattern);
    // Overlay glitch bright white stripes
    compositeTree = mix(compositeTree, vec3(1.0), glitchEffect);
    
    gl_FragColor = vec4(compositeTree, 1.0);
}