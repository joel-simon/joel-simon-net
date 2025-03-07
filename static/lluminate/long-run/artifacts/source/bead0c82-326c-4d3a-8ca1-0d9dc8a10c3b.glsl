precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(random(i), random(i + vec2(1.0,0.0)), u.x),
               mix(random(i + vec2(0.0,1.0)), random(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 swirl(vec2 p, float strength) {
    float r = length(p);
    float theta = atan(p.y, p.x) + strength * exp(-r * 2.0);
    return vec2(r * cos(theta), r * sin(theta));
}

float invertedTree(vec2 p, float seed) {
    p.y -= time * 0.3;
    float branch = smoothstep(0.0, 0.02, abs(p.x + cos(p.y * 3.0 + seed) * 0.2));
    return 1.0 - branch;
}

float glitch(vec2 p, float t) {
    float g = step(0.5, sin(p.y * 25.0 + t * 7.0));
    float off = (random(p * t) - 0.5) * 0.1;
    return mix(g, smoothstep(0.2, 0.8, noise(p + off)), 0.4);
}

float organicHeart(vec2 p) {
    p *= 1.3;
    float x = p.x;
    float y = p.y;
    float a = x*x + y*y - 1.0;
    return - (a*a*a - x*x*y*y*y);
}

void main() {
    // Remap uv coordinates from [0,1] to [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply a swirl transformation combined with fbm for a cosmic background twist.
    vec2 swirled = swirl(st, 3.0 * sin(time * 0.3));
    float cosmic = fbm(swirled * 2.5 + time * 0.5);
    vec3 cosmicColor = mix(vec3(0.05, 0.02, 0.1), vec3(0.4, 0.2, 0.6), cosmic);
    
    // Generate an inverted tree pattern that grows upward in reverse.
    float tree = invertedTree(st, 2.0);
    vec3 treeColor = vec3(0.1, 0.5, 0.3) * tree;
    
    // Draw an organic heart shape that emerges from negative space.
    float heart = organicHeart(st * 1.8);
    float heartMask = smoothstep(0.02, 0.005, heart);
    vec3 heartColor = vec3(0.8, 0.3, 0.35) * heartMask;
    
    // Apply a glitch effect using SCAMPER-inspired modification.
    float glitchEffect = glitch(uv, time);
    
    // Combine the layers with reversed blending for dynamic interplay.
    vec3 base = mix(cosmicColor, treeColor, 0.5 + 0.5 * sin(time));
    base = mix(base, heartColor, heartMask);
    base = mix(base, vec3(0.0), glitchEffect * 0.4);
    
    gl_FragColor = vec4(base, 1.0);
}