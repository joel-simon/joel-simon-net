precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
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

vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 15.0, time * 0.8));
    return p + vec2(n * 0.08, 0.0);
}

vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

float wave(vec2 p) {
    float w = sin(p.x * 6.2831 + time) * 0.1;
    w += sin(p.x * 12.5662 - time * 1.5) * 0.05;
    w += (noise(p * 8.0 + time) - 0.5) * 0.08;
    return w;
}

void main(void) {
    vec2 p = uv;
    p = glitch(p);
    
    // Create wave effect from digital ocean.
    float digitalWave = 0.5 + wave(p * 3.0);
    float oceanMask = step(p.y, digitalWave);
    
    // Apply swirl effect for organic distortion.
    vec2 glitchedPos = swirl(uv - 0.5, 3.0 * sin(time * 0.8));
    glitchedPos += 0.5;
    
    // Generate tree branch pattern based on original and glitched coordinates.
    float branch1 = treeBranch(uv, time);
    float branch2 = treeBranch(glitchedPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Layer additional noise.
    float n = noise(uv * 5.0 + time);
    float n2 = noise(glitchedPos * 10.0 - time);
    
    // Cosmic background color.
    vec2 centered = (uv - 0.5) * 2.0;
    float radius = length(centered);
    vec3 cosmicColor = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.1, 0.25), radius);
    
    // Digital ocean color with glitch stripes.
    float glitchStripes = abs(sin((uv.y + time * 3.0) * 40.0));
    float glitchEffect = smoothstep(0.4, 0.45, glitchStripes);
    vec3 oceanColor = mix(vec3(0.02, 0.05, 0.2), vec3(0.0, 0.4, 0.5), glitchEffect);

    // Organic tree color from branch patterns.
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    
    // Combine cosmic background and ocean waves,
    // then overlay the organic tree element to replace the traditional symbol (anchor) with dynamic nature.
    vec3 baseColor = mix(cosmicColor, oceanColor, oceanMask);
    vec3 finalColor = mix(baseColor, treeColor, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
    
    gl_FragColor = vec4(finalColor, 1.0);
}