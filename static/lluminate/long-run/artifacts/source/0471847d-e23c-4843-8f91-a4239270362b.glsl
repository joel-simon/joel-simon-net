precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise function using hash
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

// Swirl distortion inspired by "Honor thy error as a hidden intention"
vec2 swirl(vec2 p, float strength) {
    float angle = strength * 3.1415 * noise(p * 3.0 + time);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * (p - vec2(0.5)) + vec2(0.5);
}

// Recursive noise fractal
float fractal(vec2 p) {
    float freq = 1.0;
    float amp = 0.5;
    float sum = 0.0;
    for (int i = 0; i < 4; i++) {
        sum += noise(p * freq) * amp;
        freq *= 2.0;
        amp *= 0.5;
    }
    return sum;
}

void main(void) {
    // Begin with a swirling distorted coordinate space.
    vec2 p = swirl(uv, 1.0);
    
    // Introduce a digital error field with layers of noise.
    float errorField = fractal(p * 5.0 + time);
    
    // Use a paradoxical blend: a soft organic gradient disturbed by glitch error patterns.
    float organicLayer = smoothstep(0.3, 0.7, p.y + 0.2 * sin(time + p.x * 10.0));
    
    // Generate color channels with separate treatments reflecting intentional errors.
    float r = organicLayer + 0.3 * noise(p * 10.0 + time);
    float g = organicLayer + 0.3 * noise(p * 10.0 - time);
    float b = organicLayer + 0.3 * noise(p * 10.0 + 0.5 * time);
    
    // Overlay error fields as digital distortions on color.
    vec3 col = vec3(r, g, b);
    col += vec3(errorField * 0.2, errorField * 0.1, errorField * 0.15);
    
    // Create a subtle vignette effect using distance from center.
    float d = distance(uv, vec2(0.5));
    col *= smoothstep(0.7, 0.3, d);
    
    gl_FragColor = vec4(col, 1.0);
}