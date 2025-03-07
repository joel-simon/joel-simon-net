precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
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

// The creative concept: Replace the heart (traditional symbol of love) with the brain (subject)
// in a context where intellectual connectivity is essential.
// This function simulates intricate "neural" fissure patterns that evoke a brain's structure.
float brainFringe(vec2 pos) {
    // Warp coordinates for unpredictability
    vec2 warped = pos + 0.3 * vec2(sin(pos.y * 10.0 + time), cos(pos.x * 10.0 + time));
    // Base pattern using fbm for organic complexity
    float nerves = fbm(warped * 3.0);
    
    // Create fissure-like structures by emphasizing edges in the fbm field.
    float edge = smoothstep(0.4, 0.5, abs(sin(10.0 * warped.x + nerves*6.28)));
    return edge;
}

vec3 brainColor(vec2 pos, float pattern) {
    // Color mix representing warm creativity and cool logic
    vec3 cool = vec3(0.1, 0.4, 0.8);
    vec3 warm = vec3(0.8, 0.3, 0.1);
    float mixVal = fbm(pos * 4.0 + time * 0.5);
    vec3 base = mix(cool, warm, mixVal);
    // Emphasize the neural fringes with an extra glow
    return base + pattern * vec3(0.2, 0.2, 0.4);
}

void main() {
    // Normalize uv coordinates from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Rotate coordinates slowly over time to simulate thought motion
    float angle = time * 0.3;
    float s = sin(angle), c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Create central brain fissure pattern
    float fissure = brainFringe(pos * 1.5);
    
    // Generate a dynamic neural field swirling in the background
    float neuralField = fbm(pos * 2.0 + time);
    neuralField = smoothstep(0.3, 0.7, neuralField);
    
    // Composite the two layers: the detailed brain fissures and the neural field.
    vec3 color = brainColor(pos, fissure);
    color = mix(color, vec3(0.05, 0.05, 0.1), neuralField);
    
    // Add subtle pulsations to simulate electrical spikes.
    float pulse = smoothstep(0.2, 0.3, abs(sin(time * 3.0 + random(uv)*6.28)));
    color += pulse * vec3(0.1, 0.1, 0.2);
    
    gl_FragColor = vec4(color, 1.0);
}