precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = smoothstep(0.0, 1.0, fract(st));
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = random(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

float heartShape(vec2 pos) {
    float x = pos.x;
    float y = pos.y;
    float a = x*x + y*y - 1.0;
    return a*a*a - x*x * y*y*y;
}

vec3 cosmic(vec2 pos) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(10.0 * r - angle + time);
    float intensity = smoothstep(0.5, 0.0, r) * spiral;
    return vec3(0.1, 0.2, 0.5) + vec3(0.4, 0.3, 0.6) * intensity;
}

vec3 glitchMix(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    vec3 color = mix(colorA, colorB, stripes);
    color.r += (random(pos + vec2(t)) - 0.5) * 0.1;
    color.g += (random(pos - vec2(t)) - 0.5) * 0.1;
    color.b += (random(pos * 1.5) - 0.5) * 0.1;
    return color * base;
}

void main() {
    // Remap uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a slight rotation for creative twist.
    float angle = sin(time * 0.3) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Cosmic spiral background.
    vec3 colorCosmic = cosmic(pos);
    
    // Glitch inspired overlay.
    vec3 colorGlitch = glitchMix(pos, time);
    
    // Heart shape mask to overlay a pulsing heart pattern.
    float pulse = 1.0 + 0.3 * sin(time * 3.0);
    vec2 heartPos = pos / pulse;
    float heartVal = heartShape(heartPos);
    float heartEdge = smoothstep(0.02, -0.02, heartVal);
    vec3 heartColor = mix(vec3(1.0, 0.2, 0.3), vec3(0.9, 0.1, 0.4), heartEdge);
    
    // Blending cosmic with glitch effects and overlaying heart influence.
    float blendMask = smoothstep(0.7, 0.0, length(pos + 0.3 * sin(time + length(pos)*3.0)));
    vec3 combined = mix(colorCosmic, colorGlitch, blendMask);
    combined = mix(combined, heartColor, heartEdge);
    
    // Add subtle organic noise layering.
    float n = noise(pos * 10.0 + time);
    combined += 0.05 * vec3(n, n * 0.8, n * 1.2);
    
    gl_FragColor = vec4(combined, 1.0);
}