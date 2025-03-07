precision mediump float;
varying vec2 uv;
uniform float time;

// Random number generator
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
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

// Digital deconstruction: grid distortion function
vec2 digitalGrid(vec2 p) {
    // Inverse assumption: Instead of continuous smooth transitions, we enforce abrupt steps
    vec2 grid = fract(p * 10.0);
    // Create sudden jumps based on noise
    float jump = step(0.5, noise(floor(p * 10.0) + time));
    p += (jump - 0.5) * 0.1;
    return p;
}

// Synthetic spiral distortion
vec2 spiral(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    mat2 m = mat2(c, -s, s, c);
    return m * p;
}

void main() {
    // Reverse the common assumption of smooth organic growth: use stark, digital grid distortions
    vec2 pos = uv;
    
    // Warp coordinates with a synthetic spiral effect that increases with time
    pos = spiral(pos - 0.5, time * 0.5) + 0.5;
    
    // Apply digital grid distortion with abrupt jumps
    pos = digitalGrid(pos);
    
    // Generate layered patterns using fbm noise
    float pattern1 = fbm(pos * 3.0 + time * 0.3);
    float pattern2 = fbm(pos * 15.0 - time * 0.7);
    
    // Combine patterns to create an unexpected interplay between structured grids and chaotic noise
    float composite = mix(pattern1, pattern2, 0.5);
    
    // Use sharp thresholds to create digital glitches
    float glitch = step(0.45, fract(composite * 10.0));
    
    // Color palette: a stark digital blue modulated by glitch and grid structure against a consuming black background
    vec3 synthColor = vec3(0.1, 0.6, 0.9) * composite;
    synthColor += vec3(0.8, 0.8, 1.0) * glitch;
    
    // Introduce a subtle pulsating overlay from fbm pattern, deviating from smooth organic pulses
    float pulse = smoothstep(0.3, 0.7, fbm(uv * 20.0 + time));
    synthColor = mix(synthColor, vec3(0.0), pulse * 0.3);
    
    gl_FragColor = vec4(synthColor, 1.0);
}