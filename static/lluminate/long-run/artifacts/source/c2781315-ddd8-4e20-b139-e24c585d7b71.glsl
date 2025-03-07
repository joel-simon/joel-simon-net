precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Glitch offset for digital decay.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.04;
    float shift = fract(sin(dot(pos, vec2(17.0, 43.0))) * 43758.5453 + t) * amt;
    pos.x += shift;
    return pos;
}

// Digital distortion stripe effect.
float glitchStripe(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 30.0 + t * 6.0));
    float n = noise(pos * t);
    return mix(stripes, smoothstep(0.3, 0.7, n), 0.4);
}

// Organic tree branch pattern function.
// This represents a tree structure where growth (trait: organic growth) is essential for the tree to thrive.
// We replace the conventional symbol of heart (emotion) with a tree structure, emphasizing growth as life.
float treeBranch(vec2 st) {
    // Convert to polar coordinates.
    float r = length(st);
    float angle = atan(st.y, st.x);
    
    // Simulate branching with sine modulations.
    float branch = smoothstep(0.02, 0.0, abs(sin(5.0 * angle + time * 1.2)) - r);
    
    // Add fractal detail.
    float detail = 0.0;
    vec2 pos = st * 3.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        detail += amp * noise(pos);
        pos *= 1.8;
        amp *= 0.5;
    }
    
    return mix(branch, detail, 0.3);
}

// Background swirl function.
float swirl(vec2 st, float t) {
    float r = length(st);
    float a = atan(st.y, st.x);
    float swirlEffect = sin(8.0 * r - t * 1.5 + a);
    return swirlEffect;
}

// Color modulation combining glitch and organic tree aesthetics.
vec3 colorMix(vec2 st, float t) {
    float treePattern = treeBranch(st);
    float glitchEffect = glitchStripe(st, t) + 0.5 * glitchStripe(st * 1.5, t);
    
    vec3 organicColor = vec3(0.1, 0.6, 0.2) * (1.0 - treePattern);
    vec3 digitalColor = vec3(0.9, 0.3, 0.6) * glitchEffect;
    
    return mix(organicColor, digitalColor, 0.5 + 0.5 * sin(t));
}

void main() {
    // Remap uv from [0,1] to [-1,1] space.
    vec2 st = uv * 2.0 - 1.0;
    
    // Create a dynamic swirling organic background.
    float bgSwirl = swirl(st, time);
    vec3 bgColor = mix(vec3(0.02, 0.02, 0.05), vec3(0.1, 0.07, 0.1), bgSwirl);
    
    // Generate tree branch pattern emphasizing growth.
    float tree = treeBranch(st * 1.8);
    vec3 treeColor = vec3(0.05, 0.35, 0.1) * (1.0 - tree);
    
    // Apply digital distortion for glitch aesthetics.
    vec2 glitchUV = st;
    float angleRot = time * 0.3;
    float s = sin(angleRot), c = cos(angleRot);
    mat2 rotation = mat2(c, -s, s, c);
    glitchUV = rotation * glitchUV;
    float digitalDistort = glitchStripe(glitchUV, time);
    
    // Mix the organic tree (growth symbol) with digital glitch (decay symbol).
    vec3 finalColor = mix(bgColor, treeColor, smoothstep(0.4, 0.35, length(st)));
    finalColor = mix(finalColor, colorMix(glitchUV, time), digitalDistort);
    
    gl_FragColor = vec4(finalColor, 1.0);
}