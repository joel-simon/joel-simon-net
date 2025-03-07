precision mediump float;
varying vec2 uv;
uniform float time;

float newHash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = newHash(i);
    float b = newHash(i + vec2(1.0, 0.0));
    float c = newHash(i + vec2(0.0, 1.0));
    float d = newHash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 1.0;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 reversedSwirl(vec2 p, float strength) {
    p -= 0.5;
    float r = length(p);
    float angle = atan(p.y, p.x) - strength * r;
    p = vec2(cos(angle), sin(angle)) * r;
    return p + 0.5;
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

float organicBranch(vec2 p, float t) {
    p = p * 2.0 - 1.0;
    float r = length(p);
    float angle = atan(p.y, p.x);
    float wave = sin(12.0 * r - angle * 5.0 + t * 3.0);
    float branch = exp(-4.0 * r);
    return smoothstep(0.3, 0.5, abs(wave) * branch);
}

float mountain(vec2 p) {
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

float errorBand(vec2 p) {
    float band = sin(p.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

void main(void) {
    vec2 pos = uv;
    
    // Apply a glitch offset to introduce digital distortion
    pos += glitchOffset(pos);
    
    // Create two conceptual spaces: a reversed swirling organic form and a static branch structure.
    vec2 revPos = reversedSwirl(uv, 2.5 * sin(time * 0.7));
    float branchA = organicBranch(uv, time);
    float branchB = organicBranch(revPos, time * 1.1);
    float branches = mix(branchA, branchB, 0.5);
    
    // Introduce a cosmic noise field as a digital texture.
    float cosmic = fbm(uv * 6.0 + time * 0.5);
    
    // Generate a mountain-like silhouette from noise and sine modulation.
    float m = mountain(uv);
    float mountainMask = step(uv.y, m);
    
    // Create dynamic error bands for a glitch effect.
    float bands = errorBand(uv);
    
    // Combine color schemes from both organic and digital spaces.
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.1, 0.1, 0.2), uv.y);
    vec3 cosmicColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.2, 0.1, 0.3), cosmic);
    vec3 branchColor = mix(vec3(0.1, 0.5, 0.2), vec3(0.0, 0.3, 0.1), branches);
    vec3 mountainColor = mix(vec3(0.05, 0.05, 0.15), vec3(0.6, 0.4, 0.2), cosmic);
    vec3 glitchColor = vec3(1.0, 0.9, 0.4) * bands;
    
    // Base is blend of sky and mountain silhouette.
    vec3 baseColor = mix(skyColor, mountainColor, mountainMask);
    // Blend in organic branch forms.
    baseColor = mix(baseColor, branchColor, smoothstep(0.25, 0.35, branches));
    // Overlay cosmic texture and glitch interference.
    vec3 finalColor = mix(baseColor, cosmicColor, 0.5);
    finalColor = mix(finalColor, glitchColor, 0.5 * bands);
    
    gl_FragColor = vec4(finalColor, 1.0);
}