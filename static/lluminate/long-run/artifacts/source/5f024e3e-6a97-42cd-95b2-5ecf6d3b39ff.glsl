precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

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

float fbm(vec2 p) {
    float f = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return f;
}

// Simulate an urban grid structure with glitches
float urbanGrid(vec2 p) {
    vec2 grid = fract(p * 10.0);
    float line = step(0.04, grid.x) * step(0.04, grid.y);
    float glitch = smoothstep(0.3, 0.5, fbm(p + time * 0.5));
    return mix(line, 1.0, glitch);
}

// Create an organic, bioluminescent shimmer effect resembling deep-sea creatures
float bioShimmer(vec2 p) {
    float dist = length(p - 0.5);
    float shimmer = smoothstep(0.4, 0.2, dist);
    shimmer += 0.3 * sin(20.0 * p.x + time * 3.0) * sin(20.0 * p.y + time * 2.0);
    return clamp(shimmer, 0.0, 1.0);
}

// Combine the digital urban grid and organic deep-sea shimmer with a subtle twist
void main(void) {
    vec2 pos = uv;
    
    // Offset to create slight movement in the grid pattern
    vec2 gridPos = pos + vec2(sin(time * 0.3), cos(time * 0.2)) * 0.02;
    float grid = urbanGrid(gridPos);
    
    // Create a swirling effect for the bioluminescent effect
    vec2 swirlCenter = vec2(0.5);
    vec2 diff = pos - swirlCenter;
    float angle = atan(diff.y, diff.x);
    float radius = length(diff);
    angle += 0.3 * sin(time + radius * 10.0);
    vec2 swirlPos = swirlCenter + vec2(cos(angle), sin(angle)) * radius;
    float bio = bioShimmer(swirlPos);
    
    // Blend the two domains: urban absense and organic glow
    vec3 urbanColor = mix(vec3(0.05, 0.05, 0.1), vec3(0.2, 0.2, 0.3), grid);
    vec3 bioColor = mix(vec3(0.0, 0.1, 0.2), vec3(0.0, 0.6, 0.8), bio);
    
    // Synthesize: combine with a dynamic mix that oscillates with time
    float mixFactor = smoothstep(0.3, 0.7, sin(time * 0.5) * 0.5 + 0.5);
    vec3 color = mix(urbanColor, bioColor, mixFactor);
    
    gl_FragColor = vec4(color, 1.0);
}