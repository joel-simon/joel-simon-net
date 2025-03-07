precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
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

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

// Organic tree branch pattern
float treeBranch(vec2 pos, float t) {
    // Map coord from [0,1] to [-1,1]
    pos = pos * 2.0 - 1.0;
    // Rotate based on time for organic sway
    pos = rotate(pos, sin(t * 0.5) * 0.5);
    
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

vec3 treeGrowth(vec2 pos, float t) {
    vec3 baseColor = vec3(0.1, 0.15, 0.2);
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 leafColor = vec3(0.1, 0.8, 0.3);
    
    float branchPattern = treeBranch(pos, t);
    float n = noise(pos * 5.0 + t);
    
    vec3 color = mix(trunkColor, leafColor, branchPattern);
    return mix(baseColor, color, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
}

void main() {
    vec2 st = uv;
    
    // Apply a subtle zoom and pan effect over time to introduce motion
    st = (st - 0.5) * (1.0 + 0.3 * sin(time * 0.7)) + 0.5;
    
    // Generate global fractal noise for cosmic background texture
    float globalNoise = fbm(st * 3.0 + time * 0.2);
    
    // Set up glitch grid overlay
    vec2 grid = fract(st * 4.0);
    float glitch = step(0.3, grid.x) * step(0.3, grid.y) * step(grid.x, 0.7) * step(grid.y, 0.7);
    glitch = 1.0 - glitch;
    
    // Generate tree growth pattern (organic element)
    vec3 treeColor = treeGrowth(st, time);
    
    // Combine background cosmic effect with organic tree and digital glitch overlay
    vec3 cosmicColor = mix(vec3(0.05, 0.2, 0.4), vec3(0.8, 0.3, 0.9), globalNoise);
    vec3 combined = mix(cosmicColor, treeColor, 0.5);
    combined = mix(combined, vec3(1.0, 0.5, 0.2), glitch * 0.4);
    
    gl_FragColor = vec4(combined, 1.0);
}