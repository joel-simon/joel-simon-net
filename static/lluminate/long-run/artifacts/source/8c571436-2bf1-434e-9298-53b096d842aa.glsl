precision mediump float;
varying vec2 uv;
uniform float time;

//-----------------------------------------------------------------
// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

//-----------------------------------------------------------------
// Creative Concept:
// Trait: Complexity and Insight
// Subject: A brain
// Symbol: A heart (commonly associated with emotion)
// Context: In a cerebral landscape, where intricate neural networks highlight insight, 
// we replace the heart symbol with a dynamic, networked brain pattern.
// The shader constructs a swirling, interconnected network with branching lines 
// representing neural connections, modulated by noise and time.

void main(void) {
    // Center uv coordinates to range [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create a subtle rotation over time to simulate dynamic neural flow
    float angleOffset = time * 0.3;
    float cosA = cos(angleOffset);
    float sinA = sin(angleOffset);
    pos = vec2(pos.x * cosA - pos.y * sinA, pos.x * sinA + pos.y * cosA);
    
    // Polar coordinates
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    
    // Neural network lines: use sine waves to generate pattern resembling neural branches.
    // The number 12 modulates the density; adjust frequency for intricate branch details.
    float branches = sin(12.0 * theta + time * 2.0);
    
    // Use smoothstep to create thin, bright neural strands over a diffuse background.
    float neuralStrand = smoothstep(0.02, 0.0, abs(fract(r * 10.0 - noise(pos * 3.0 + time)) - 0.5)) * abs(branches);
    
    // Create a background pattern with a soft gradient and dynamic noise to invoke depth.
    float bgNoise = noise(pos * 5.0 + time * 0.5);
    float bg = smoothstep(0.3, 0.0, r + bgNoise * 0.3);
    
    // Color Scheme: Use cool cerebral hues mixed with a hint of warm insight.
    vec3 brainColor = mix(vec3(0.1, 0.2, 0.4), vec3(0.4, 0.6, 0.8), bgNoise);
    vec3 strandColor = vec3(1.0, 0.8, 0.5) * neuralStrand;
    
    // Merge layers: neural strands on the cerebral background, emphasizing connectivity.
    vec3 finalColor = brainColor * bg + strandColor;
    
    gl_FragColor = vec4(finalColor, 1.0);
}