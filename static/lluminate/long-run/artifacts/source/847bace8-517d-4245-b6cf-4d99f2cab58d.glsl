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
    vec2 u = f*f*(3.0-2.0*f);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Swirl transformation for dynamic background patterns
vec2 swirl(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

// Creative Implementation:
// Key Trait: Resilience
// Symbol Replaced: The mythical Phoenix (S) is replaced by a humble seedling (P)
// Context: Where resilience is essential for the seedling to grow against dynamic environmental challenges

// Create a dynamic ground field that represents nurturing soil
float ground(vec2 pos) {
    float n = fbm(pos * 3.0 - time * 0.2);
    return smoothstep(0.4, 0.5, pos.y + n * 0.1);
}

// Create a seedling shape rising from the ground
float seedling(vec2 pos) {
    // position offset for seedling center
    vec2 center = vec2(0.0, -0.2);
    pos -= center;
    // vertical growth line with slight bend using sinusoidal distortion (resilience through flexibility)
    float stem = 1.0 - abs(pos.x) * 5.0;
    float bend = smoothstep(-0.1, 0.0, pos.y - sin(time + pos.x * 10.0) * 0.05);
    return stem * bend;
}

// Create an ambient background using swirling cosmic patterns
vec3 background(vec2 pos) {
    vec2 swirled = swirl(pos, 2.0);
    float n = fbm(swirled * 2.5 + time * 0.1);
    return mix(vec3(0.05, 0.1, 0.2), vec3(0.2, 0.35, 0.5), n);
}

void main(){
    // Normalize and center UV coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Background layer: dynamic swirling cosmic colors
    vec3 bgColor = background(pos);
    
    // Ground layer: represent nurturing soil with dynamic noise texture
    float groundMask = ground(uv);
    vec3 groundColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.3, 0.2, 0.1), groundMask);
    
    // Seedling layer: resilient sprout rising from the ground
    float seed = seedling(pos);
    vec3 seedColor = vec3(0.0, 0.8, 0.2) * smoothstep(0.2, 0.5, seed);
    
    // Composite the layers: background, ground, and the resilient seedling
    vec3 color = mix(bgColor, groundColor, groundMask);
    color = mix(color, seedColor, seed);
    
    gl_FragColor = vec4(color, 1.0);
}