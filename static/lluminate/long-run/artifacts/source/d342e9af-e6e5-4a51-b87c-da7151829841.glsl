precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(13.0, 37.0))) * 43758.5453);
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
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 glitchOffset(vec2 pos) {
    float glitch = step(0.95, fract(sin(dot(pos.xy, vec2(12.9898,78.233))) * 43758.5453 + time));
    float offset = glitch * (noise(pos * 20.0 + time) - 0.5) * 0.15;
    return pos + vec2(offset, 0.0);
}

vec3 organicTexture(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float r = length(pos);
    float cell = smoothstep(0.4, 0.38, abs(n - r));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

vec3 digitalBurst(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float burst = step(0.95, hash(pos * 1.3 + vec2(time, time))) * 0.3;
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + burst;
}

float treeBranch(vec2 pos, float t) {
    vec2 p = pos * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

void main(void) {
    vec2 pos = uv;
    
    // Introduce error as a hidden intention: glitch the coordinate.
    pos = glitchOffset(pos - 0.5) + 0.5;
    
    // Apply a polar transformation based on fbm noise.
    float angle = fbm(pos * 3.0 + time) * 6.2831 * 0.2;
    vec2 rotatedPos = polarTransform(pos - 0.5, angle) + 0.5;
    
    // Add a swirling distortion for organic flow.
    vec2 swirledPos = swirl(rotatedPos - 0.5, 3.0 * sin(time * 0.8)) + 0.5;
    
    // Generate organic pattern texture.
    vec3 organic = organicTexture(pos);
    
    // Generate tree branch like pattern.
    float branch1 = treeBranch(pos, time);
    float branch2 = treeBranch(swirledPos, time * 0.9);
    float branchMix = mix(branch1, branch2, 0.5);
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchMix);
    
    // Introduce cosmic digital burst.
    vec3 digital = digitalBurst(swirledPos);
    
    // Synthesize layers using a radial mix factor.
    float mixFactor = smoothstep(0.6, 0.2, length(pos - 0.5));
    vec3 colorMix = mix(organic, digital, mixFactor);
    colorMix = mix(colorMix, treeColor, smoothstep(0.15, 0.35, branchMix + noise(pos * 5.0 + time) * 0.2));
    
    // Create a swirling vortex effect in the background.
    vec2 centered = (uv - 0.5) * 2.0;
    float radius = length(centered);
    float vortex = sin(atan(centered.y, centered.x) * 6.0 + time * 2.0 + fbm(centered * 3.0)) * 0.3;
    float mask = smoothstep(0.7 + vortex, 0.68 + vortex, radius);
    
    // Final color blending with radial mask.
    vec3 finalColor = colorMix * mask;
    
    gl_FragColor = vec4(finalColor, 1.0);
}