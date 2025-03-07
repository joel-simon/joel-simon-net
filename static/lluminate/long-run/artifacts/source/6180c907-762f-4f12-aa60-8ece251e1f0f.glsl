precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 pos, float amt) {
    float len = length(pos);
    float angle = amt * len;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 glitchWarp(vec2 p) {
    float n = fbm(p * 8.0 + time * 0.7);
    p.x += 0.05 * sin(10.0 * p.y + time) * n;
    p.y += 0.05 * cos(10.0 * p.x + time) * n;
    return p;
}

float organicShape(vec2 p) {
    // Center and scale coordinates to focus on the organic shape
    p = (p - 0.5) * 2.0;
    // create a wavy circular organic shape
    float r = length(p);
    float angle = atan(p.y, p.x);
    float modulator = sin(6.0 * angle + time) * 0.15;
    float shape = smoothstep(0.5 + modulator, 0.48 + modulator, r);
    return shape;
}

void main() {
    // Apply glitch warp to uv for digital distortion
    vec2 pos = glitchWarp(uv);
    
    // Apply a swirling transformation to introduce organic motion
    pos = swirl(pos - 0.5, 3.0 + sin(time) * 2.0) + 0.5;
    
    // Create a fractal noise background that simulates digital field
    float fbmVal = fbm(pos * 5.0 + time * 0.3);
    
    // Synthesize organic shape with digital interference
    float orgShape = organicShape(pos);
    
    // Color blending: digital cyan field with organic magenta overlay
    vec3 digitalColor = vec3(0.0, 0.8, 0.9) * fbmVal;
    vec3 organicColor = vec3(0.8, 0.1, 0.7) * orgShape;
    vec3 color = mix(digitalColor, organicColor, orgShape);
    
    // Apply vignette to softly darken edges
    float vignette = smoothstep(1.0, 0.4, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}