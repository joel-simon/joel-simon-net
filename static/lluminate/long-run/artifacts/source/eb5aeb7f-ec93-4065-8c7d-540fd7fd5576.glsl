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

vec3 glitchColor(vec2 p, float t) {
    float n = noise(p * 50.0 + t);
    float r = noise(p + vec2(t * 0.1, 0.0));
    float g = noise(p + vec2(0.0, t * 0.15));
    float b = noise(p + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

vec3 cosmicSpiral(vec2 pos) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(10.0 * r - time * 3.0 + angle * 4.0);
    float intensity = smoothstep(0.5, 0.0, r) * abs(spiral);
    vec3 color = mix(vec3(0.0, 0.0, 0.2), vec3(0.8, 0.4, 0.2), intensity);
    return color;
}

vec3 organicOverlay(vec2 pos) {
    float organic = noise(pos * 4.0 + time);
    float flow = smoothstep(0.4, 0.0, length(pos)) * organic;
    vec3 color = vec3(0.0, 0.3, 0.4) + vec3(0.2, 0.5, 0.3) * flow;
    return color;
}

void main() {
    vec2 centered = (uv - 0.5) * 2.0;
    
    // Rotate coordinates for dynamic swirl effect
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(centered.x * c - centered.y * s, centered.x * s + centered.y * c);
    
    // Synthesize cosmic spiral with an organic underwater vibe by blending two conceptual spaces.
    vec3 spaceA = cosmicSpiral(rotated);
    vec3 spaceB = organicOverlay(centered);
    
    float blendMask = smoothstep(0.6, 0.0, length(centered + 0.2 * sin(time + length(centered) * 3.0)));
    vec3 blended = mix(spaceA, spaceB, blendMask);
    
    // Apply glitch effects to create abrupt digital artifacts.
    vec3 glitch = glitchColor(centered * 1.5, time);
    vec3 finalColor = mix(blended, glitch, 0.3);
    
    // Vignette effect to focus the pattern near the center.
    float vignette = smoothstep(0.8, 0.2, length(centered));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}