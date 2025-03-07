precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 glitchOffset(vec2 p) {
    float offset = noise(vec2(floor(p.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

vec2 digitalGrid(vec2 p) {
    vec2 grid = fract(p * 10.0);
    float jump = step(0.5, noise(floor(p * 10.0) + time));
    p += (jump - 0.5) * 0.1;
    return p;
}

vec2 spiral(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * p;
}

float organicBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = sin(t * 0.5) * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

float digitalGlitch(vec2 pos) {
    float glitch = step(0.45, fract(fbm(pos * 10.0) * 10.0));
    return glitch;
}

void main(void) {
    vec2 pos = uv;
    
    // Apply organic glitch distortion
    pos += glitchOffset(pos);
    
    // Digital spiral warp centered at uv=0.5
    pos = spiral(pos - 0.5, time * 0.5) + 0.5;
    
    // Apply digital grid distortion
    pos = digitalGrid(pos);
    
    // Organic layer: fractal noise base blended with branch structure
    float organicNoise = fbm(pos * 3.0 + time * 0.5);
    float branch = organicBranch(uv, time);
    
    // Digital layer: glitch patterns from fbm and abrupt thresholding
    float patternDigital = fbm(pos * 15.0 - time * 0.7);
    float glitch = digitalGlitch(pos);
    
    // Organic color blending: dark green to earthy brown based on branch function
    vec3 organicColor = mix(vec3(0.1, 0.5, 0.2), vec3(0.4, 0.25, 0.1), branch);
    
    // Digital synthetic blue modulated by glitch effect and noise pattern
    vec3 digitalColor = mix(vec3(0.1, 0.6, 0.9) * organicNoise, vec3(0.8, 0.8, 1.0), glitch);
    
    // Background sky: a gradient dark to subtle night tone
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.1, 0.1, 0.2), uv.y);
    
    // Layer blending: merge organic and digital aspects with a composite influence
    vec3 baseColor = mix(skyColor, organicColor, smoothstep(0.25, 0.35, branch));
    vec3 finalColor = mix(baseColor, digitalColor, 0.5 * glitch);
    
    gl_FragColor = vec4(finalColor, 1.0);
}