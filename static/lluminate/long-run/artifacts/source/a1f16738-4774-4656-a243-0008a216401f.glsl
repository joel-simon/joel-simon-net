precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 239.345);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 1.8;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitch(vec2 p, float seed) {
    float t = time + seed;
    float shift = (noise(p * 10.0 + t) - 0.5) * 0.08;
    return p + vec2(shift, shift);
}

float starburst(vec2 pos) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float wave = sin(angle * 8.0 + time * 4.0) * 0.1;
    return smoothstep(0.0, 0.02, abs(radius - wave));
}

float treeBranch(vec2 p) {
    // Shift to simulate tree growth from bottom center.
    p = p * 1.2;
    p -= vec2(0.5, 0.0);
    float growth = smoothstep(0.0, 1.0, p.y * 1.8);
    float angle = atan(p.y, p.x);
    float branch = smoothstep(0.02, 0.0, abs(p.x - sin(angle * 3.0 + time * 1.3) * 0.05 - fbm(p * 10.0) * 0.03));
    return branch * growth;
}

float organicPulse(vec2 pos) {
    float r = length(pos);
    float pulse = sin(r * 12.0 - time * 3.0);
    return smoothstep(0.3, 0.31, abs(pulse));
}

void main() {
    vec2 st = uv * 2.0 - 1.0;
    st *= 1.2;
    
    // Apply a glitch distortion to simulate dynamic digital distortion.
    vec2 distorted = glitch(st, 3.14);
    
    // Create a dynamic background using fbm and starburst effects.
    float f = fbm(distorted * 2.0);
    float burst = starburst(distorted);
    vec3 bg = mix(vec3(0.1, 0.05, 0.2), vec3(0.0, 0.2, 0.4), f + burst);
    
    // Generate organic tree branch patterns representing resilience.
    float branchPattern = treeBranch(uv);
    vec3 treeColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.0, 0.4, 0.1), branchPattern);
    
    // Add an organic pulsating element via sine modulation.
    float pulse = organicPulse(st);
    vec3 organic = mix(vec3(0.8, 0.3, 0.2), vec3(0.2, 0.6, 0.4), pulse);
    
    // Blend layers: background, organic glow, and tree branches.
    vec3 composite = mix(bg, organic, 0.5 + 0.5 * sin(time * 0.7));
    composite = mix(composite, treeColor, branchPattern);
    
    // Final overlay of subtle glitches in stripes.
    float stripe = step(0.45, fract(uv.y * 20.0 + time));
    composite = mix(composite, vec3(0.0), stripe * 0.15);
    
    gl_FragColor = vec4(composite, 1.0);
}