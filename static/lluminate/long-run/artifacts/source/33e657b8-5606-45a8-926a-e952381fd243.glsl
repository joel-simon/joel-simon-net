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
    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));
    return mix(mix(a,b,u.x), mix(c,d,u.x), u.y);
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

vec2 fromPolar(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

float treeBranch(vec2 p) {
    // Shift coordinate system: center bottom
    p -= vec2(0.5, 0.0);
    // Growth factor based on vertical position
    float growth = smoothstep(0.0, 1.0, p.y * 1.8);
    // Polar transformation
    float angle = atan(p.y, p.x);
    // Introduce organic branch shape with sine and noise
    float branch = smoothstep(0.02, 0.0, abs(p.x - sin(angle * 3.0 + time * 1.3)*0.05 - fbm(p*10.0)*0.03));
    return branch * growth;
}

float organicCircuit(vec2 p) {
    // Center and scale
    p = (p - 0.5) * 2.0;
    vec2 polar = toPolar(p);
    // Create swirling arms: digital interference meets organic rhythm
    float arms = sin(polar.y * 3.0 + time + fbm(p * 3.0));
    float branch = smoothstep(0.1 + 0.3 * arms, 0.12 + 0.3 * arms, polar.x);
    return branch;
}

vec2 glitchWarp(vec2 p) {
    float n = fbm(p * 8.0 + time * 0.7);
    p.x += 0.05 * sin(10.0 * p.y + time) * n;
    p.y += 0.05 * cos(10.0 * p.x + time) * n;
    return p;
}

void main() {
    // Apply glitch effect to uv coordinates
    vec2 pos = glitchWarp(uv);
    
    // Background gradient: cool digital tones blending with organic warmth
    vec3 bgColor = mix(vec3(0.02, 0.05, 0.15), vec3(0.4, 0.3, 0.2), uv.y);
    bgColor += 0.1 * fbm(uv * 5.0 + time * 0.5);
    
    // Generate two layers: one representing a tree branch growth and one representing an organic circuit
    float branchPattern = treeBranch(uv);
    float circuitPattern = organicCircuit(pos);
    
    // Synthesize colors from both conceptual spaces
    vec3 treeColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.0, 0.4, 0.1), branchPattern);
    vec3 circuitColor = mix(vec3(0.0, 0.8, 0.9), vec3(0.8, 0.1, 0.7), circuitPattern);
    
    // Combine layers using a blending formula to bring emergent properties
    vec3 combined = mix(bgColor, treeColor, branchPattern);
    combined = mix(combined, circuitColor, circuitPattern * 0.5);
    
    // Add a subtle vignette effect
    float vignette = smoothstep(1.0, 0.4, length(uv - 0.5));
    combined *= vignette;
    
    gl_FragColor = vec4(combined, 1.0);
}