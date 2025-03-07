precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

float digitalGrid(vec2 p) {
    // Create a digital grid-like disturbance.
    float gridSize = 10.0;
    vec2 grid = fract(p * gridSize);
    float lineWidth = 0.03;
    float vertical = smoothstep(0.0, lineWidth, grid.x) + smoothstep(1.0, 1.0 - lineWidth, grid.x);
    float horizontal = smoothstep(0.0, lineWidth, grid.y) + smoothstep(1.0, 1.0 - lineWidth, grid.y);
    return clamp(vertical + horizontal, 0.0, 1.0);
}

float organicPulse(vec2 p) {
    // Simulate an organic pulse, the reversal: instead of nature quietly growing,
    // here organic life explodes with digital interference.
    p -= 0.5;
    float dist = length(p);
    float pulse = sin(dist * 20.0 - time * 3.0);
    pulse = smoothstep(0.0, 0.1, abs(pulse));
    return pulse;
}

void main() {
    vec2 p = uv;
    
    // Create a background that challenges digital assumptions:
    // a digital glitch area with randomized fbm noise.
    float glitch = fbm(p * 15.0 + time);
    vec3 digitalColor = mix(vec3(0.0, 0.2, 0.4), vec3(0.4, 0.1, 0.2), glitch);
    
    // Organic burst that defies expectations by fragmenting and merging with digital grid.
    float pulse = organicPulse(p);
    float grid = digitalGrid(p + vec2(time * 0.1, time * 0.1));
    
    // Merge the digital grid with the organic pulse
    vec3 organicColor = mix(vec3(0.0, 0.3, 0.0), vec3(0.8, 0.9, 0.2), pulse);
    vec3 mixedColor = mix(digitalColor, organicColor, grid * pulse);
    
    // Introduce a time-varying glitch effect to further invert the traditional roles:
    float glitchEffect = smoothstep(0.2, 0.4, fbm(p * 50.0 + time * 5.0));
    vec3 finalColor = mix(mixedColor, vec3(glitchEffect, glitchEffect*0.5, 0.0), glitchEffect);
    
    gl_FragColor = vec4(finalColor, 1.0);
}