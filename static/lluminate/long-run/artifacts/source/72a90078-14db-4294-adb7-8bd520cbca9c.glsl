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

// Conceptual Space A: Celestial spiral (galactic)
vec3 celestial(vec2 pos) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(10.0 * r - angle + time);
    float intensity = smoothstep(0.3, 0.0, r) * spiral;
    vec3 color = vec3(0.1, 0.2, 0.5) + vec3(0.4, 0.3, 0.6) * intensity;
    return color;
}

// Conceptual Space B: Underwater reef (organic, fluid flow)
vec3 reef(vec2 pos) {
    float r = length(pos);
    float organic = noise(pos * 3.0 + time);
    float flow = smoothstep(0.4, 0.0, r) * organic;
    vec3 color = vec3(0.0, 0.4, 0.3) + vec3(0.2, 0.6, 0.5) * flow;
    return color;
}

// Blend two spaces to create emergent behavior
void main() {
    // Normalize and center uv coordinates
    vec2 st = uv - 0.5;
    st *= 2.0;
    
    // Distort coordinates to create interaction between spaces
    vec2 posA = st;
    vec2 posB = st;
    
    // Apply time based rotation and swirl to posA (celestial space)
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    posA = mat2(c, -s, s, c) * posA;
    
    // Add organic distortion to posB (reefs space)
    posB += 0.2 * vec2(noise(st * 5.0 + vec2(time)), noise(st * 5.0 - vec2(time)));
    
    // Map the two spaces to a common blended scale
    vec3 colorA = celestial(posA);
    vec3 colorB = reef(posB);
    
    // Selective blending: mix based on a radial mask that emerges from blending the two spaces.
    float blendMask = smoothstep(0.6, 0.0, length(st + 0.3 * sin(time + length(st)*3.0)));
    
    // Emergent color: Not present in either input alone.
    vec3 emergent = mix(colorA, colorB, blendMask);
    
    // Add subtle noise texture overlay for additional organic detail.
    float n = noise(st * 10.0 + time);
    emergent += 0.05 * vec3(n, n * 0.8, n * 1.2);
    
    gl_FragColor = vec4(emergent, 1.0);
}