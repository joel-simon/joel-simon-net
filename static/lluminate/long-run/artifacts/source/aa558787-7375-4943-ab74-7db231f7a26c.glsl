precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233)))*43758.5453);
}

float flameShape(vec2 p) {
    p.y += 0.5;
    p.y *= 1.8;
    float base = 1.0 - length(p);
    float n = noise(p * 4.0 - time * 2.0);
    n = smoothstep(0.3, 0.7, n);
    return smoothstep(0.0, 0.05, base + 0.3 * n);
}

vec3 glitchColor(vec2 p, float t) {
    float n = pseudoNoise(p * 50.0 + t);
    float r = pseudoNoise(p + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(p + vec2(0.0, t * 0.15));
    float b = pseudoNoise(p + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0, 1.0, 1.0), glitch);
}

void main() {
    // Remap uv to centered coordinates [-1, 1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Create a stormy, swirling background.
    float angle = atan(st.y, st.x);
    float radius = length(st);
    float swirl = sin(10.0 * radius - time * 1.5 + angle);
    float bgNoise = noise(st * 3.0 + time);
    float bgMix = mix(swirl, bgNoise, 0.6);
    vec3 background = mix(vec3(0.0, 0.0, 0.1), vec3(0.05, 0.1, 0.2), bgMix);
    
    // Digital glitch spiral overlay for urban cosmic effect.
    vec2 centered = uv - 0.5;
    float spiral = sin(10.0 * length(centered) - time * 4.0 + atan(centered.y, centered.x) * 5.0);
    vec2 grid = abs(fract(centered * 10.0) - 0.5);
    float gridLine = smoothstep(0.4, 0.42, min(grid.x, grid.y));
    float pattern = smoothstep(0.2, 0.3, length(centered) + 0.1 * spiral) * (1.0 - gridLine);
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.2, 0.8, 1.0), length(centered));
    vec3 glitch = glitchColor(centered * 2.0, time);
    vec3 urbanCosmic = mix(baseColor, glitch, 0.25);
    urbanCosmic *= pattern;
    
    // Creative substitution strategy:
    // Trait: Passion
    // Symbol: Traditionally, a heart.
    // Context: In a stormy, glitch-infused environment, passion transforms into a dynamic flame.
    vec2 flameCoord = st;
    flameCoord.y -= 0.2;
    float flame = flameShape(flameCoord);
    vec3 flameColor = mix(vec3(0.8, 0.2, 0.1), vec3(1.0, 0.9, 0.3), flame);
    
    // Merge layers: background, cosmic glitch overlay, and the passionate flame.
    vec3 combinedBG = mix(background, urbanCosmic, 0.3);
    vec3 finalColor = mix(combinedBG, flameColor, flame);
    
    gl_FragColor = vec4(finalColor, 1.0);
}