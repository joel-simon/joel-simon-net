precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453);
}

float smoothNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * smoothNoise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 twist(vec2 p, float amt) {
    float angle = amt * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec2 digitalDistort(vec2 pos, float seed) {
    float glitch = sin(pos.y * 40.0 + seed) * 0.008 + smoothNoise(pos * 30.0 + seed) * 0.015;
    pos.x += glitch;
    return pos;
}

vec3 organicCore(vec2 pos) {
    float n = fbm(pos * 4.0 + time * 0.25);
    float ring = smoothstep(0.45, 0.42, abs(length(pos - 0.5) - n));
    vec3 baseColor = mix(vec3(0.0, 0.35, 0.15), vec3(0.8, 0.6, 0.2), n);
    return baseColor * ring;
}

vec3 digitalPulse(vec2 pos) {
    vec2 grid = fract(pos * 25.0 + time*0.5);
    float pulse = smoothstep(0.0, 0.03, abs(grid.y - 0.5));
    float burst = step(0.92, rand(pos * 2.5 + time)) * 0.4;
    vec3 pulseColor = mix(vec3(0.1, 0.1, 0.25), vec3(0.7, 0.9, 1.0), pulse);
    return pulseColor + burst;
}

float fractalBranches(vec2 pos, float t) {
    vec2 centered = pos - 0.5;
    float r = length(centered);
    float a = atan(centered.y, centered.x);
    float pattern = sin(7.0 * r - 3.0 * a + t*2.5);
    float decay = exp(-8.0 * r);
    return smoothstep(0.25, 0.35, abs(pattern) * decay);
}

void main(){
    vec2 pos = uv;
    
    // Anchor: natural growth swirling pattern.
    float baseAngle = fbm(pos * 2.5 + time) * 3.1416 * 0.5;
    vec2 rotated = twist(pos - 0.5, baseAngle) + 0.5;
    
    // Medium-distance digital distortion.
    vec2 distorted = digitalDistort(rotated, time);
    vec2 twistedDigital = twist(distorted - 0.5, sin(time * 0.9)) + 0.5;
    
    // Organic layer with flowing rings and fractal noise.
    vec3 organicLayer = organicCore(pos);
    
    // Branches reminiscent of tree network; subtle yet structured.
    float branchA = fractalBranches(pos, time);
    float branchB = fractalBranches(twistedDigital, time * 1.1);
    float branches = mix(branchA, branchB, 0.5);
    vec3 branchColor = mix(vec3(0.3, 0.2, 0.1), vec3(0.0, 0.7, 0.4), branches);
    
    // Digital pulse effect representing glitch and errors.
    vec3 digitalLayer = digitalPulse(twistedDigital);
    
    // Combine layers using radial blend
    float mixFactor = smoothstep(0.55, 0.25, length(pos - 0.5));
    vec3 mixBase = mix(organicLayer, digitalLayer, mixFactor);
    vec3 finalColor = mix(mixBase, branchColor, smoothstep(0.15, 0.35, branches));
    
    gl_FragColor = vec4(finalColor, 1.0);
}