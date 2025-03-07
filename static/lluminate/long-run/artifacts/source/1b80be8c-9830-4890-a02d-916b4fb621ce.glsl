precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion for organic texture
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

// Swirl distortion function
vec2 swirl(vec2 p, float strength) {
    float angle = strength * length(p);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * p;
}

// Grid pattern for digital artifact
float digitalGrid(vec2 p) {
    vec2 grid = step(0.45, abs(fract(p) - 0.5));
    return grid.x * grid.y;
}

void main(void) {
    // Center uv coordinates around (0,0) and scale for effect
    vec2 p = uv * 2.0 - 1.0;
    
    // Select two distinct conceptual spaces:
    // Space A: Organic fractal fluidity (fbm, swirl)
    // Space B: Digital grid and glitch artifacts
    
    // Apply swirl distortion to emphasize organic movement
    vec2 pSwirl = swirl(p, 3.0 + 0.5 * sin(time));
    
    // Develop emergent texture from organic space using fbm
    float organic = fbm(3.0 * pSwirl + time * 0.2);
    
    // Map digital space using a grid pattern over original coordinates
    float grid = digitalGrid(10.0 * p + vec2(time * 0.5));
    
    // Blend selectively: use grid to modulate the organic fbm
    float emergent = mix(organic, grid, 0.5 + 0.5 * sin(time * 1.5));
    
    // Further enhance emergent behavior with a pulsing modification
    emergent *= mix(0.8, 1.2, 0.5 + 0.5 * sin(organic * 10.0 + time));
    
    // Create two color palettes representing the dual input spaces
    vec3 organicColor = vec3(0.1, 0.5, 0.2) + emergent * vec3(0.3, 0.4, 0.3);
    vec3 digitalColor = vec3(0.6, 0.2, 0.8) * emergent;
    
    // Map cross-space: use p.x (horizontal structure) to determine blend between spaces
    float blendFactor = smoothstep(-0.2, 0.2, p.x);
    
    vec3 color = mix(digitalColor, organicColor, blendFactor);
    
    // Final digital glitches overlay: add fine noise
    float glitch = noise(50.0 * p + time) * 0.1;
    color += glitch;
    
    gl_FragColor = vec4(color, 1.0);
}