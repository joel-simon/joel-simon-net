precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Basic noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Fractal Brownian Motion, organic texture.
float fbm(vec2 p) {
    float total = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

// Digital glitch function: selectively displaces coordinates.
vec2 glitch(vec2 p, float t) {
    float offset = step(0.97, fract(sin(dot(p, vec2(12.34, 56.78)) + t * 8.0))) * 0.15;
    return p + vec2(offset, 0.0);
}

// Emergent blend: fusing digital grid with organic flow.
float emergent(vec2 p, float t) {
    // Map two conceptual spaces: 
    // 1. Organic fbm flow from natural patterns.
    // 2. Digital grid sensed via noise modulated by time.
    float organic = fbm(p * 2.0 + t * 0.2);
    vec2 gridUV = floor((p + 1.0) * 4.0) / 4.0;
    float digital = noise(gridUV * 8.0 + t * 0.5);
    // Map correspondences: interplay using mix.
    return mix(organic, digital, 0.5 + 0.5 * sin(t));
}

void main() {
    // Center uv coordinates.
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply glitch distortion.
    vec2 distorted = glitch(st, time);
    
    // Emergent structure, mapping blended inputs.
    float blend = emergent(distorted, time);

    // Create swirling pattern by rotating the coordinate based on the blend.
    float angle = blend * 3.1415;
    float s = sin(angle), c = cos(angle);
    vec2 rotated = vec2(c * distorted.x - s * distorted.y, s * distorted.x + c * distorted.y);
    
    // Additional layer: concentric digital waves.
    float waves = abs(sin(10.0 * length(rotated) - time * 3.0));
    
    // Color blending: Organic deep greens merging with neon digital blues.
    vec3 organicColor = vec3(0.0, 0.4 + 0.6 * blend, 0.0);
    vec3 digitalColor = vec3(0.0, 0.2, 0.4 + 0.6 * blend);
    vec3 emergentColor = mix(organicColor, digitalColor, blend);
    
    // Introduce digital wave highlights.
    emergentColor += vec3(waves * 0.3, waves * 0.2, waves * 0.5);
    
    // Final shading with vignette to enhance depth.
    float vignette = smoothstep(1.2, 0.2, length(st));
    vec3 finalColor = emergentColor * vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}