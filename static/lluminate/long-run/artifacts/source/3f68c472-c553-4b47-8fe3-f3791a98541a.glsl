precision mediump float;
varying vec2 uv;
uniform float time;

// Hash-based pseudo-random function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
}

// Basic 2D noise
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

// Fractal Brownian Motion using noise
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

// Glitch distortion using noise modulation
vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 10.0, time));
    return p + vec2(n * 0.05, 0.0);
}

// Swirl distortion to simulate organic rotation
vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Organic pattern combining fbm and radial mask
vec3 organicPattern(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float r = length(pos - 0.5);
    float mask = smoothstep(0.4, 0.38, abs(n - r));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * mask;
}

// Tree branch function with wave modulation to indicate growth and resilience
float treeBranch(vec2 pos, float t) {
    vec2 p = pos * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

// Digital burst effect to introduce glitch artifacts
vec3 digitalBurst(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float burst = step(0.95, noise(pos * 1.3 + time)) * 0.3;
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + burst;
}

void main(void) {
    // Base coordinate from uv and apply glitch
    vec2 pos = glitch(uv);
    
    // Create a swirling effect by rotating around center and re-offset
    vec2 centeredPos = pos - 0.5;
    float swirlAmount = 3.0 * sin(time * 0.8);
    vec2 swirledPos = swirl(centeredPos, swirlAmount);
    swirledPos += 0.5;
    
    // Organic texture from FBM and organic pattern masking
    vec3 organic = organicPattern(pos);
    
    // Two layers using tree branch generation, one modified by swirl
    float branch1 = treeBranch(pos, time);
    float branch2 = treeBranch(swirledPos, time * 0.9);
    float branchMix = mix(branch1, branch2, 0.5);
    
    // Derive a natural wood-like color tone from branch characteristics
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchMix);
    
    // Digital burst effect for glitch-inspired details
    vec3 digital = digitalBurst(swirledPos);
    
    // Blend organic and digital components based on distance from center
    float mixFactor = smoothstep(0.6, 0.2, length(pos - 0.5));
    vec3 colorMix = mix(organic, digital, mixFactor);
    
    // Final mix incorporating tree structure to hint at resilience and organic growth
    colorMix = mix(colorMix, treeColor, smoothstep(0.15, 0.35, branchMix + noise(pos * 5.0 + time) * 0.2));
    
    gl_FragColor = vec4(colorMix, 1.0);
}