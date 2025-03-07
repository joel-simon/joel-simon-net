precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(63.726, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

vec2 vortex(vec2 p, float strength) {
    vec2 center = vec2(0.5, 0.5);
    vec2 diff = p - center;
    float dist = length(diff);
    float angle = strength / (dist + 0.1);
    float s = sin(angle);
    float c = cos(angle);
    return center + vec2(diff.x * c - diff.y * s, diff.x * s + diff.y * c);
}

vec3 crypticPalette(float t) {
    // "Honor thy error as a hidden intention"
    float r = 0.5 + 0.5 * sin(t + 0.0);
    float g = 0.5 + 0.5 * sin(t + 2.0);
    float b = 0.5 + 0.5 * sin(t + 4.0);
    return vec3(r, g, b);
}

void main() {
    vec2 p = uv;
    
    // Apply vortex transformation based on time
    p = vortex(p, time);
    
    // Create a layered noise effect for organic texture.
    float n = noise(p * 8.0 + time * 0.5);
    float n2 = noise(p * 16.0 - time * 0.8);
    float combinedNoise = mix(n, n2, 0.5);
    
    // Create a swirling grid pattern to simulate digital artifact.
    vec2 grid = fract(p * 10.0);
    float line = smoothstep(0.04, 0.05, min(grid.x, grid.y));
    
    // Blend an "old idea" organic gradient with digital glitch.
    vec3 color1 = crypticPalette(combinedNoise * 6.2831);
    vec3 color2 = mix(vec3(0.1, 0.2, 0.3), vec3(0.9, 0.8, 0.7), p.y);
    
    // "What would your closest friend do?" - merge randomness
    vec3 finalColor = mix(color1, color2, line);
    
    // Apply a rhythmic modulation
    float modulation = 0.5 + 0.5 * sin(time * 3.0 + p.x * 10.0);
    finalColor *= modulation;
    
    gl_FragColor = vec4(finalColor, 1.0);
}