precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 glitch(vec2 p, float t) {
    float g = step(0.95, fract(sin(dot(p, vec2(12.34,45.67))) * 43758.5453 + t));
    return p + vec2(0.1 * g, 0.0);
}

vec3 organicLayer(in vec2 p, float t) {
    // simulate organic growth using FBM
    float n = fbm(p * 3.0 + t * 0.5);
    float growth = smoothstep(0.4, 0.6, n);
    vec3 col1 = vec3(0.1,0.6,0.3);
    vec3 col2 = vec3(0.8,0.9,0.4);
    return mix(col1, col2, growth);
}

vec3 digitalLayer(in vec2 p, float t) {
    // simulate digital distortion using glitch and noise stripes
    vec2 gp = glitch(p, t);
    float stripe = step(0.5, abs(sin(gp.y * 30.0 + t*3.0)));
    float d = noise(gp * 10.0 + t);
    float mixVal = smoothstep(0.3, 0.7, d);
    vec3 colA = vec3(0.9,0.2,0.3);
    vec3 colB = vec3(0.2,0.3,0.9);
    return mix(colA, colB, mixVal) * stripe;
}

vec3 layeredSynthesis(vec2 p, float t) {
    // organic background layer
    vec3 organic = organicLayer(p, t);
    // digital glitch layer
    vec3 digital = digitalLayer(p, t);
    // blend layers with a time based modulation
    float blend = 0.5 + 0.5 * sin(t + p.x * 3.0);
    return mix(organic, digital, blend);
}

void main(){
    // map uv from [0,1] to centered [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Create swirling distortions using polar coordinates
    float r = length(st);
    float a = atan(st.y, st.x);
    float swirl = sin(r * 10.0 - time * 2.0 + a * 3.0);
    float pattern = smoothstep(0.35, 0.36, r + 0.1 * swirl);
    
    // Layered synthesis with slight gradient modulation
    vec3 base = layeredSynthesis(st, time);
    vec3 finalColor = mix(base, vec3(0.0), pattern);
    
    // Add subtle edge darkening to simulate depth
    finalColor *= smoothstep(1.0, 0.7, r);
    
    gl_FragColor = vec4(finalColor, 1.0);
}