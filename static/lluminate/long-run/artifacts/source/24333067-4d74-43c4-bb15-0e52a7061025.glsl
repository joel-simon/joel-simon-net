precision mediump float;
varying vec2 uv;
uniform float time;

// 2D Hash function
float hash(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p + 34.45);
    return fract(p.x * p.y);
}

// 2D Noise function based on hash
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion (FBM)
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

// Merge two conceptual spaces:
// 1. Glitch digital grid
// 2. Organic fluid noise (like water waves)
// Create an emergent structure with properties of both.
vec3 blendedScene(vec2 pos, float t) {
    // Space 1: Digital grid with glitch distortion.
    float gridSize = 10.0;
    vec2 grid = fract(pos * gridSize);
    float line = step(0.05, grid.x) * step(0.05, grid.y);
    float glitch = sin((pos.x + pos.y + t) * 50.0) * 0.5 + 0.5;
    
    // Distort grid with a glitch offset.
    float gridPattern = mix(line, glitch, 0.4);
    
    // Space 2: Organic fluid noise.
    vec2 warpedPos = pos;
    warpedPos += 0.1 * vec2(sin(t + pos.y * 5.0), cos(t + pos.x * 5.0));
    float organic = fbm(warpedPos * 3.0 + t * 0.5);
    
    // Blend the two spaces selectively.
    float blendFactor = smoothstep(0.3, 0.7, organic);
    float emergent = mix(gridPattern, organic, blendFactor);
    
    // Map to colors: digital space is cool cyan; organic space is a warm amber.
    vec3 digitalColor = vec3(0.0, 0.8, 0.9);
    vec3 organicColor = vec3(0.9, 0.6, 0.2);
    return mix(digitalColor, organicColor, emergent);
}

void main() {
    // Map UV to a -1.0 to 1.0 range with subtle rotation over time.
    vec2 pos = uv * 2.0 - 1.0;
    float angle = 0.2 * sin(time);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Adjust scale over time to introduce an emergent zoom effect.
    pos *= 1.0 + 0.3 * sin(time * 0.7);
    pos += vec2(0.1*sin(time*1.3), 0.1*cos(time*1.1));
    
    // Synthesize the blended scene.
    vec3 color = blendedScene(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}