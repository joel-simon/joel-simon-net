precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 digitalGlitch(vec2 p, float seed) {
    float shift = (noise(p * 20.0 + seed + time) - 0.5) * 0.1;
    return p + vec2(shift, shift);
}

float organicBranch(vec2 p) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    float branch = sin(angle * 6.0 + time * 2.0) * 0.3;
    return smoothstep(0.2, 0.21, abs(r - branch));
}

void main() {
    // Merge two conceptual spaces: digital error and organic growth
    vec2 st = uv * 2.0 - 1.0;
    
    // Map digital space using a glitch distortion of coordinates
    vec2 digitalSpace = digitalGlitch(st, 1.23);
    float digitalNoise = fbm(digitalSpace * 3.0);
    
    // Map organic space by simulating branching and growth
    vec2 organicSpace = st * (1.0 + 0.5 * sin(time));
    float organicPattern = organicBranch(organicSpace);
    float organicFBM = fbm(organicSpace * 4.0);
    
    // Map crossspace: blend emergent structures from digital noise and organic growth
    float emergent = mix(digitalNoise, organicFBM, 0.5) + organicPattern;
    
    // Develop emergent colors from blended space
    vec3 digitalColor = vec3(0.1, 0.3, 0.7) * digitalNoise;
    vec3 organicColor = vec3(0.7, 0.4, 0.2) * organicPattern;
    
    vec3 blendedColor = mix(digitalColor, organicColor, 0.5 + 0.5*sin(time * 0.5));
    blendedColor += emergent * 0.3;
    
    // Final glitch overlay based on a time modulated stripe
    float stripe = step(0.6, fract(uv.y * 30.0 + time * 2.0));
    blendedColor = mix(blendedColor, vec3(0.0), stripe * 0.2);
    
    gl_FragColor = vec4(blendedColor, 1.0);
}