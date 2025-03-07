precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Basic noise function
float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// A swirling distortion for digital glitch aesthetics
vec2 swirl(in vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Organic fractal branch: polar mapping blended with fractal noise texture
float fractalBranch(in vec2 pos, float t) {
    // Remap uv to polar coordinates (range -1.0 to 1.0)
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Create a fractal layered sine wave pattern
    float wave = sin(5.0 * r - a * 3.0 + t);
    float fbm = 0.0;
    vec2 p = pos;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        fbm += amp * noise(p * 3.0 + t);
        p *= 2.0;
        amp *= 0.5;
    }
    
    // Combine fractal noise with branch pattern
    float branch = smoothstep(0.3, 0.4, abs(wave)) * exp(-3.0 * r) + fbm * 0.1;
    return branch;
}

// Digital grid pattern blended with organic noise
float digitalMesh(in vec2 pos, float t) {
    pos = pos * 10.0;
    vec2 gv = fract(pos) - 0.5;
    float d = length(gv);
    float mask = smoothstep(0.4, 0.42, d);
    float glitch = noise(pos + t);
    return mask + 0.2 * glitch;
}

void main() {
    vec2 pos = uv;
    
    // Concept Space 1: Organic fractal branch structure
    float organic = fractalBranch(pos, time);
    
    // Concept Space 2: Digital glitch mesh with swirling distortions
    vec2 glitchUV = swirl(pos - 0.5, 4.0 * sin(time * 1.5));
    glitchUV += 0.5;
    float digital = digitalMesh(glitchUV, time * 0.8);
    
    // Map correspondence between spaces: radial gradient used to blend
    vec2 centered = (pos - 0.5) * 2.0;
    float radial = length(centered);
    float blendFactor = smoothstep(0.3, 0.6, radial);
    
    // Emergent structure: blend organic and digital components selectively
    float emergent = mix(organic, digital, blendFactor);
    
    // Color dynamics: organic part uses earthy tones, digital part uses neon glow.
    vec3 organicColor = mix(vec3(0.1, 0.3, 0.0), vec3(0.6, 0.4, 0.1), organic);
    vec3 digitalColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.2, 0.8, 1.0), digital);
    
    vec3 color = mix(organicColor, digitalColor, blendFactor);
    
    // Enhance emergent structure over the background with additional noise texture
    float detail = noise(pos * 15.0 + time * 0.5);
    color += 0.1 * detail;
    
    gl_FragColor = vec4(color, 1.0);
}