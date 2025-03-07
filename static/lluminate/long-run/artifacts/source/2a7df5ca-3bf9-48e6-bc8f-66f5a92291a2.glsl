precision mediump float;
varying vec2 uv;
uniform float time;

// 2D rotation matrix
mat2 rotate(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

// Simple hash function for noise generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7)))*43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) + 
           (c - a)* u.y * (1.0 - u.x) + 
           (d - b) * u.x * u.y;
}

// Function to simulate origami folds using repeated mirrored segments
float origamiFold(vec2 p, int folds) {
    for (int i = 0; i < folds; i++) {
        p = abs(p); // mirror along the axis
        p = rotate(0.5) * p; // slight rotation per fold
    }
    return length(p);
}

// Digital ocean wave function combining neural folds and wave interference
vec3 digitalOcean(vec2 pos, float t) {
    // Create a wave-like interference pattern
    float wave1 = sin(pos.x * 10.0 + t * 3.0);
    float wave2 = sin(pos.y * 10.0 - t * 2.0);
    float waves = (wave1 + wave2) * 0.5;
    
    // Add noisy perturbation to simulate digital interference
    float n = noise(pos * 3.0 + t);
    
    // Synthesize an "origami" interference: folds in the ocean surface
    float fold = origamiFold(pos - 0.5, 3);
    float foldPattern = smoothstep(0.2, 0.25, fold);
    
    // Merge ocean waves with origami digital artifacts
    float blend = mix(waves, foldPattern, 0.5) + n * 0.2;
    
    // Color modulation: dark digital blue with origami paper highlights
    vec3 baseColor = vec3(0.0, 0.05, 0.2);
    vec3 highlight = vec3(0.8, 0.9, 1.0);
    
    return mix(baseColor, highlight, blend);
}

void main() {
    // Adjust coordinates to center and scale them
    vec2 pos = uv;
    pos = pos * 2.0 - 1.0;
    pos *= 1.2;
    
    // Apply a subtle rotation over time to mimic drifting origami
    pos = rotate(time * 0.2) * pos;
    
    // Synthesize the final color by blending digital ocean waves with origami folds
    vec3 color = digitalOcean(pos * 0.8 + 0.5, time);
    
    gl_FragColor = vec4(color, 1.0);
}