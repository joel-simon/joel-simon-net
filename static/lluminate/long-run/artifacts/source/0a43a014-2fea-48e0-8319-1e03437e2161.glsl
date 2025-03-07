precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 origamiFold(vec2 p) {
    // Perform a reflective fold to mimic origami creases.
    p = abs(p);
    p = (p - 0.5) * 2.0;
    return p;
}

vec2 digitalJitter(vec2 p, float intensity) {
    // Create a digital glitch inspired offset
    float offset = sin(p.y * 40.0 + time * 5.0) * intensity;
    p.x += offset;
    return p;
}

vec3 unfoldingOrigami(vec2 p) {
    // Create an interplay between organic fold and digital jitter
    p = origamiFold(p);
    p = digitalJitter(p, 0.03);
    float pattern = sin(p.x*10.0 + time) * cos(p.y*10.0 - time);
    float fb = fbm(p * 3.0 + time);
    float mixFactor = smoothstep(0.2, 0.8, fb);
    vec3 colorA = vec3(0.9, 0.6, 0.2); // warm, paper-like tone
    vec3 colorB = vec3(0.2, 0.7, 0.9); // cool, digital tone
    return mix(colorA, colorB, mixFactor + 0.3 * pattern);
}

void main(){
    // Map uv from [0,1] to [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Rotate the coordinate system slowly over time
    float angle = time * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Synthesize two unrelated domains: ancient origami (precise folds) and modern digital jitter
    vec3 color = unfoldingOrigami(pos);
    
    // Add subtle digital noise overlay
    float noiseVal = noise(uv * 20.0 + time);
    color += vec3(noiseVal * 0.08);
    
    gl_FragColor = vec4(color, 1.0);
}