precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 organicWarp(vec2 p) {
    // Apply fractal noise based warp to emulate organic growth
    float n = fbm(p * 3.0 + time * 0.5);
    float angle = n * 6.2831;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    return rot * p;
}

vec3 digitalGlitch(vec2 p) {
    // Create digital artifacts with a grid-like breakup
    float stripe = step(0.8, abs(sin((p.y + time*1.5)*40.0)));
    float shift = noise(p * 50.0 + time) * 0.3;
    vec3 col = vec3(0.0);
    col.r = stripe * abs(sin(p.x * 20.0 + shift + time));
    col.g = stripe * abs(cos(p.x * 20.0 - shift - time));
    col.b = stripe * abs(sin(p.x * 20.0 + shift - time));
    return col;
}

vec3 emergentOrganic(vec2 p) {
    // Build an emergent, organic fractal structure
    vec2 center = vec2(0.5);
    vec2 pos = p - center;
    float r = length(pos);
    // Non-linear growth with fbm and warped coordinates
    float organic = fbm(organicWarp(pos * 5.0));
    float mask = smoothstep(0.4, 0.0, r);
    vec3 col = mix(vec3(0.1, 0.2, 0.15), vec3(0.7, 0.9, 0.6), organic);
    return col * mask;
}

void main(void) {
    vec2 p = uv;
    
    // Conceptual Space 1: Emergent organic fractal growth
    vec3 organicZone = emergentOrganic(p);
    
    // Conceptual Space 2: Digitalized glitch interference
    vec3 digitalZone = digitalGlitch(p);
    
    // Map cross-space: mix based on a shifting threshold modulated by time
    float blendFactor = smoothstep(0.3, 0.7, noise(p*10.0 + time));
    
    // Blend selectively: each zone contributes inseparable traits
    vec3 emergent = mix(organicZone, digitalZone, blendFactor);
    
    gl_FragColor = vec4(emergent, 1.0);
}