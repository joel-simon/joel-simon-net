precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float hash2(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash2(i);
    float b = hash2(i + vec2(1.0, 0.0));
    float c = hash2(i + vec2(0.0, 1.0));
    float d = hash2(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x),
               mix(c, d, u.x), u.y);
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

vec2 reverseGlitch(vec2 p, float seed) {
    float t = time * 0.5 + seed;
    float shift = (noise(p * 8.0 + t) - 0.5) * 0.15;
    return p - vec2(shift, shift);
}

float organicVein(vec2 p) {
    p = (p - vec2(0.5, 0.3)) * vec2(1.0, 1.5);
    float r = length(p);
    float angle = atan(p.y, p.x);
    float growth = smoothstep(0.0, 0.5, p.y);
    float branch = abs(sin(angle * 5.0 + time + fbm(p * 8.0) * 3.0));
    float taper = smoothstep(0.5, 0.2, r);
    return growth * branch * taper;
}

float radialDecay(vec2 p) {
    float r = length(p);
    return 1.0 - smoothstep(0.2, 0.5, r);
}

void main() {
    vec2 p = uv;
    
    // Background gradient blending digital and organic tones.
    vec3 digitalColor = vec3(0.1, 0.3, 0.5);
    vec3 organicColor = vec3(0.1, 0.5, 0.2);
    vec3 bgColor = mix(digitalColor, organicColor, p.y);
    
    // Introduce reverse glitch distortion
    vec2 glitchUV = reverseGlitch(p * 2.0 - 1.0, 1.23);
    glitchUV = (glitchUV + 1.0) * 0.5;
    
    // Compute fractal noise for digital interference
    float glitch = fbm(glitchUV * 12.0 + time);
    
    // Organic vein effect mimicking natural growth and structure
    float vein = organicVein(p);
    
    // Radial decay for central fading effect
    float decay = radialDecay(p * 2.0 - 1.0);
    
    // Dynamic color gradient based on angle and glitch noise
    float angle = atan(p.y - 0.5, p.x - 0.5);
    vec3 warmColor = vec3(1.0, 0.4, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(angle + time) + 1.0) * 0.5);
    
    // Blend organic and digital elements
    vec3 organicLayer = mix(bgColor, vec3(0.0, 0.4, 0.1), vein);
    vec3 digitalLayer = mix(bgColor, vec3(0.05, 0.05, 0.1), glitch * 0.5);
    
    // Combine layers with radial decay and dynamic gradient
    vec3 combined = mix(organicLayer, digitalLayer, 0.5);
    combined = mix(combined, colorGradient, decay * 0.6);
    
    // Overlay glitch flashes
    float flash = smoothstep(0.4, 0.42, glitch);
    vec3 flashColor = vec3(0.8, 0.8, 1.0) * flash;
    
    gl_FragColor = vec4(combined + flashColor, 1.0);
}