precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on uv coordinates
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Organic noise function using fractal Brownian motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * random(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Digital grid pattern that glitches over time
float digitalGrid(vec2 pos, float t) {
    vec2 grid = fract(pos * 10.0) - 0.5;
    float line = step(abs(grid.x), 0.05) + step(abs(grid.y), 0.05);
    // Introduce glitch offset based on time
    float glitch = sin(t * 3.0 + random(floor(pos * 10.0)) * 6.28);
    return line * step(0.3, abs(glitch));
}

// Blend the two conceptual spaces into an emergent structure
vec3 emergentBlend(vec2 pos, float t) {
    // Map space A: the organic, noise-driven abstraction
    float organic = fbm(pos + sin(t * 0.5));
    
    // Map space B: the digital grid with glitch effects
    float grid = digitalGrid(pos, t);
    
    // Map crossspace: find analogies in frequency modulation: 
    // modulate organic patterns with the digital glitch intensity
    float blendFactor = smoothstep(0.3, 0.7, organic + grid);
    
    // Develop emergent colors: organic space (warm) and digital space (cool)
    vec3 warmColor = vec3(0.8, 0.5, 0.3) * organic;
    vec3 coolColor = vec3(0.3, 0.6, 0.9) * grid;
    
    // Combine the two color elements
    return mix(warmColor, coolColor, blendFactor);
}

void main() {
    // Center uv around [0,1] then map to a wider range for more detail
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a slow rotation over time to further blend spaces
    float angle = time * 0.2;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Create emergent property that merges organic and digital phenomena
    vec3 color = emergentBlend(pos, time);
    
    // Final vignette effect for depth
    float vignette = smoothstep(1.2, 0.0, length(pos));
    gl_FragColor = vec4(color * vignette, 1.0);
}