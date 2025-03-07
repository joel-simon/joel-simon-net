precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p ,vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
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

vec2 circuitDisturb(vec2 p, float intensity) {
    float n = fbm(p * 5.0 + time);
    float angle = n * 6.2831;
    vec2 offset = vec2(cos(angle), sin(angle)) * intensity;
    return p + offset;
}

float organicVine(vec2 p, float t) {
    p = p * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    float wave = sin(10.0 * r - a * 4.0 + t);
    float mask = smoothstep(0.7, 0.4, r);
    return mask * abs(wave);
}

void main(void) {
    vec2 pos = uv;
    
    // Apply electronic circuit disturbance: mimic circuit traces with noise offset.
    pos = circuitDisturb(pos, 0.03);
    
    // Create two domains:
    // Domain A: Organic, vine-like structures.
    float vine = organicVine(uv, time * 1.2);
    
    // Domain B: Structured circuit patterns using grid and noise.
    vec2 grid = fract(uv * 10.0) - 0.5;
    float circuitLines = smoothstep(0.02, 0.0, abs(grid.x)) + smoothstep(0.02, 0.0, abs(grid.y));
    circuitLines *= fbm(uv * 15.0 + time);
    
    // Synthesize dual domains from organic and digital worlds.
    float synth = mix(vine, circuitLines, 0.5);
    
    // Color synthesis: earthy greens for vines, cool blues for circuits.
    vec3 colorOrganic = mix(vec3(0.0, 0.2, 0.0), vec3(0.1, 0.6, 0.1), vine);
    vec3 colorCircuit = mix(vec3(0.0, 0.0, 0.2), vec3(0.2, 0.4, 0.7), circuitLines);
    vec3 colorBase = mix(colorOrganic, colorCircuit, 0.5);
    
    // Add a temporal pulsing digital accent.
    float pulse = smoothstep(0.3, 0.0, abs(sin(time * 2.0)));
    colorBase += pulse * vec3(0.15, 0.15, 0.25) * synth;
    
    gl_FragColor = vec4(colorBase, 1.0);
}