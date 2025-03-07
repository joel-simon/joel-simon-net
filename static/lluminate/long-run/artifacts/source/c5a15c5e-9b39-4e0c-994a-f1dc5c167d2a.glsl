precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * noise(p);
        p *= 2.0;
        a *= 0.5;
    }
    return v;
}

void main(void) {
    // Center the uv coordinates for polar computations.
    vec2 pos = uv * 2.0 - 1.0;
    float r = length(pos);
    float angle = atan(pos.y, pos.x);

    // Creative Strategy:
    // Identify trait: growth, symbol: heart (universal symbol for love)
    // Create a context where love is essential for growth: a blooming tree.
    // Replace the heart with the tree itself by generating swirling, fractal branches that pulse with life.
    
    // Create a swirling modulation for branch-like structures.
    float swirl = sin(6.0 * angle + time * 1.5) * 0.2;
    
    // Carve out branch forms by mixing radial distance with swirl perturbation.
    float branchMask = smoothstep(0.5 + swirl, 0.48 + swirl, r);

    // Add detailed fractal noise to simulate organic branch texture.
    float detail = fbm(pos * 2.5 + time * 0.3);

    // Use the detail to further sculpt the branch shapes.
    float branches = smoothstep(0.45, 0.42, r + 0.15 * detail);

    // Synthesize colors: use soft, warm pinks for the blooming aspect and deep greens for robust growth.
    vec3 bloomColor = vec3(1.0, 0.75, 0.8);
    vec3 branchColor = vec3(0.0, 0.5, 0.0);
    vec3 mixedColor = mix(bloomColor, branchColor, branches);

    // Add a gentle pulsating effect to evoke the beating heart of growth.
    float pulse = 0.5 + 0.5 * sin(time * 2.0 + r * 12.0);
    mixedColor *= pulse;

    // Combine everything using the branch mask to reveal a blooming tree replacing the heart symbol.
    vec3 finalColor = mixedColor * branchMask;

    gl_FragColor = vec4(finalColor, 1.0);
}