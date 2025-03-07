precision mediump float;
varying vec2 uv;
uniform float time;

// Random cryptic directive: "Honor thy error as a hidden intention."

// Basic hash function for randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Distortion function that punishes error by introducing randomness
vec2 errorDistort(vec2 p) {
    float n = fbm(p * 4.0 + time);
    // Introduce harsh, unpredictable shifts
    p.x += 0.1 * sin(15.0 * p.y + time * 2.0) * n;
    p.y += 0.1 * cos(15.0 * p.x + time * 2.0) * n;
    return p;
}

// Organic swirl function: twist the coordinates in a vortex pattern
vec2 swirl(vec2 p) {
    p -= 0.5;
    float angle = fbm(p * 3.0 + time) * 3.1415;
    float s = sin(angle);
    float c = cos(angle);
    p = vec2(c * p.x - s * p.y, s * p.x + c * p.y);
    p += 0.5;
    return p;
}

// Main pattern marrying organic growth with glitching digital error
float pattern(vec2 p) {
    p = errorDistort(p);
    p = swirl(p);
    // Create a branching, vein-like structure using fbm
    float branch = smoothstep(0.4, 0.45, fbm(p * 8.0 + time * 0.5));
    return branch;
}

void main() {
    vec2 pos = uv;
    // Introduce sporadic digital error by shifting rows based on a periodic error line
    float errorLine = step(0.48, abs(fract(time * 0.5) - pos.y));
    pos.x += errorLine * 0.08 * sin(50.0 * pos.y + time * 5.0);

    float organic = pattern(pos);
    // A background field combining multiple layers of fbm for digital texture
    float digitalField = fbm(pos * 5.0 - time * 0.3);

    // Color palette: organic warmth (reddish/orange) vs digital coolness (blue/cyan)
    vec3 organicColor = vec3(1.0, 0.5, 0.2) * organic;
    vec3 digitalColor = vec3(0.2, 0.6, 0.9) * digitalField;

    // Blend the two worlds in an unexpected mix
    vec3 color = mix(digitalColor, organicColor, organic);

    // Darken edges to simulate focus and hidden errors
    float vignette = smoothstep(0.8, 0.4, length(uv - 0.5));
    color *= vignette;

    gl_FragColor = vec4(color, 1.0);
}