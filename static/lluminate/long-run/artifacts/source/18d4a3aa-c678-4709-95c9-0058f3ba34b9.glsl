precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D Noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Organic tree-like shape function.
float treeShape(vec2 p) {
    // Center p into [-1, 1]
    p = (p - 0.5) * 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

// Glitch offset function.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453123 + t) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch effect.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float n = noise(pos * t);
    float noiseStrip = smoothstep(0.3, 0.7, n);
    return mix(stripes, noiseStrip, 0.3);
}

void main() {
    // Map uv to centered coordinates [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Dynamic swirling organic background.
    float radius = length(st);
    float angle = atan(st.y, st.x);
    float swirl = sin(6.0 * radius - time * 1.5 + angle);
    float dynamicNoise = noise(st * 4.0 + time);
    float organicPattern = mix(swirl, dynamicNoise, 0.5);
    vec3 bgColor = mix(vec3(0.05, 0.1, 0.15), vec3(0.1, 0.05, 0.1), organicPattern);
    
    // Generate digital grid glitch effect.
    vec2 glitchUV = uv;
    float angleRot = time * 0.4;
    float s = sin(angleRot);
    float c = cos(angleRot);
    mat2 rotation = mat2(c, -s, s, c);
    glitchUV = rotation * (glitchUV - 0.5) + 0.5;
    float glitchPattern = stripedGlitch(glitchUV, time);
    
    // Organic tree structure as symbolic element.
    float tree = treeShape(uv);
    vec3 treeColor = mix(vec3(0.0), vec3(0.1, 0.5, 0.1), tree);
    
    // Combine digital and organic aesthetic.
    vec3 digitalColor = vec3(0.3, 0.8, 0.9) * glitchPattern;
    vec3 combinedColor = mix(bgColor, digitalColor, 0.5 + 0.5 * sin(time));
    
    // Merge in tree structure and add radial emergent distortion.
    float emergent = smoothstep(0.35, 0.0, radius + 0.3 * sin(time + radius * 10.0));
    vec3 finalColor = mix(combinedColor, treeColor, emergent);
    
    gl_FragColor = vec4(finalColor, 1.0);
}