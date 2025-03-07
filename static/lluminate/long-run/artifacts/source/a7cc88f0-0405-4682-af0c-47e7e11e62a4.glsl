precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)),
                   hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)),
                   hash(i + vec2(1.0,1.0)), u.x), u.y);
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453123 + t) * amt;
    pos.x += shift;
    return pos;
}

float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float n = smoothstep(0.3, 0.7, noise(pos * t));
    return mix(stripes, n, 0.3);
}

float treeShape(vec2 p) {
    // Shift UV to lower center.
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    
    // Trunk shape.
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    
    // Branches using sine waves.
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    // Canopy shape.
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    
    return max(trunk, max(branches, canopy));
}

vec3 colorModulation(vec2 pos, float t, float tree) {
    float glitchFactor = stripedGlitch(pos, t);
    vec3 digitalColor = mix(vec3(0.1, 0.8, 0.7), vec3(0.9, 0.2, 0.3), glitchFactor);
    vec3 treeColor = mix(vec3(0.1, 0.4, 0.15), vec3(0.2, 0.7, 0.3), uv.y);
    return mix(digitalColor, treeColor, tree);
}

void main() {
    // Centered coordinates and a slight rotation for digital perturbation.
    vec2 pos = uv;
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle), cos(angle));
    pos = rot * (pos - 0.5) + 0.5;
    
    // Evaluate tree shape with an added glitch on the x coordinate.
    vec2 p = uv;
    float glitchPerturb = sin(50.0 * p.y + time * 10.0) * 0.005;
    p.x += glitchPerturb;
    float tree = treeShape(p);
    
    // Create a swirling organic background.
    vec2 st = uv * 2.0 - 1.0;
    float radius = length(st);
    float angleSt = atan(st.y, st.x);
    float swirl = sin(6.0 * radius - time * 1.5 + angleSt);
    float dynamicNoise = noise(st * 4.0 + time);
    float organicPattern = mix(swirl, dynamicNoise, 0.5);
    vec3 bgColor = mix(vec3(0.05, 0.1, 0.15), vec3(0.1, 0.05, 0.1), organicPattern);
    
    // Digital glitch overlay.
    float pattern = stripedGlitch(pos, time);
    vec3 digital = vec3(0.3, 0.8, 0.9) * pattern;
    
    // Combine background with digital glitch effects.
    vec3 combinedColor = mix(bgColor, digital, 0.5 + 0.5 * sin(time));
    float emergent = smoothstep(0.35, 0.0, radius + 0.3 * sin(time + radius * 10.0));
    vec3 mixedColor = mix(combinedColor, colorModulation(pos, time, tree), emergent);
    
    gl_FragColor = vec4(mixedColor, 1.0);
}