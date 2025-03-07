precision mediump float;
varying vec2 uv;
uniform float time;

// Random card: "Honor thy error as a hidden intention."
// We'll interpret this directive as intentionally adding subtle glitches and errors that reveal hidden beauty.

// Hash function for pseudo-random noise based on position.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise function with smooth interpolation.
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

// Swirl function to create organic chaotic motions.
vec2 swirl(vec2 p, float amount) {
    float a = amount * length(p);
    float s = sin(a);
    float c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

// Introduce intentional error by perturbing coordinates randomly.
vec2 intentionalError(vec2 p) {
    float e = noise(p * 30.0 + time);
    return p + vec2(e * 0.03, -e * 0.03);
}

// Generates organic vein patterns subtly inspired by error.
float veinPattern(vec2 p) {
    p = p * 3.0;
    float n = noise(p + vec2(time * 0.5, time * 0.3));
    return smoothstep(0.45, 0.55, fract(n * 10.0));
}

// Hidden error band to inject glitch stripes.
float errorBand(vec2 p) {
    float band = sin(p.y * 40.0 + time * 5.0);
    return smoothstep(0.04, 0.06, abs(band));
}

void main(void) {
    // Base UV coordinates shifted to center and with an intentional error.
    vec2 pos = intentionalError(uv * 1.0);
    
    // Create a swirled coordinate for a hidden chaotic structure.
    vec2 swirledPos = swirl(pos - 0.5, 2.5 * sin(time * 0.7)) + 0.5;
    
    // Generate a hidden organic vein pattern.
    float veins = veinPattern(swirledPos);
    
    // A glitchy stripe effect overlay.
    float glitch = errorBand(uv);
    
    // Background cosmic gradient influenced by noise and defects.
    float n = noise(uv * 5.0 + time * 0.3);
    vec3 cosmic = mix(vec3(0.05, 0.1, 0.2), vec3(0.15, 0.2, 0.35), n);
    
    // Vein colors emerge with a hint of error: mix of organic greens and subtle magenta.
    vec3 veinColor = mix(vec3(0.1, 0.5, 0.2), vec3(0.5, 0.1, 0.3), veins);
    
    // Integrate glitch bands as an intentional error overlay.
    vec3 finalColor = mix(cosmic, veinColor, 0.5 * veins);
    finalColor = mix(finalColor, vec3(0.8, 0.8, 0.8), glitch * 0.3);
    
    gl_FragColor = vec4(finalColor, 1.0);
}