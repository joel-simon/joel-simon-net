precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 glitch(vec2 p, float t) {
    float shift = sin(p.y * 80.0 + t * 5.0) * 0.01;
    p.x += shift;
    p.y += cos(p.x * 80.0 + t * 5.0) * 0.01;
    return p;
}

vec3 subjectPattern(vec2 p) {
    // Organic tree-like structure representing resilience but digitally rendered.
    float n = fbm(p * 4.0 - time * 0.2);
    float trunk = smoothstep(0.45, 0.5, abs(p.x)) * smoothstep(0.0, 0.5, 1.0 - abs(p.y));
    float branches = smoothstep(0.4, 0.35, abs(n - length(p)));
    vec3 baseColor = mix(vec3(0.1, 0.4, 0.0), vec3(0.3, 0.6, 0.1), n);
    return baseColor * mix(trunk, branches, 0.5);
}

vec3 digitalContext(vec2 p) {
    // Digital glitch effects reminiscent of circuitry.
    vec2 grid = fract(p * 25.0 + time * 0.5);
    float line = smoothstep(0.0, 0.04, abs(grid.y - 0.5));
    float glitchPulse = step(0.98, hash(p * time)) * 0.4;
    return mix(vec3(0.0, 0.0, 0.2), vec3(0.5, 0.8, 1.0), line) + glitchPulse;
}

void main(){
    // Center coordinates and scale.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a rotation that evolves with time.
    float angle = fbm(pos * 2.0 + time * 0.3) * 6.2831;
    vec2 rotated = rotate(pos, angle);
    
    // Introduce a glitch to distort the digital structure.
    vec2 distorted = glitch(rotated, time);
    
    // The creative twist: a symbol of a sturdy tree (resilience) now represented within a digital glitch context.
    vec3 subject = subjectPattern(distorted);
    vec3 digital = digitalContext(distorted * 0.8);
    
    // Blend the organic resilience with digital systematic structure.
    float mixAmt = smoothstep(0.3, 0.8, length(pos));
    vec3 colorMix = mix(subject, digital, mixAmt);
    
    gl_FragColor = vec4(colorMix, 1.0);
}