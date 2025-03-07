precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Bioluminescent noise for underwater coral dynamics
float coralNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
    // Map coordinates: blend underwater dynamics with urban neon structure
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.2;
    
    // Domain 1: Underwater coral flow dynamics
    float coralFlow = coralNoise(pos * 3.0 + time * 0.5);
    float coralShape = smoothstep(0.3, 0.35, abs(coralFlow - fract(pos.y * 3.0 + sin(time))));
    
    // Domain 2: Urban neon geometric grid
    vec2 grid = abs(fract(pos * 10.0 - 0.5) - 0.5);
    float neonLine = smoothstep(0.48, 0.5, min(grid.x, grid.y));
    
    // Combine two domains: underwater organic shape modulated with neon grid shine
    float combined = mix(coralShape, neonLine, 0.5 + 0.5 * sin(time * 1.5));
    
    // Create a ripple effect to blend domains further
    float ripple = sin(20.0 * length(pos) - time * 3.0);
    combined += ripple * 0.1;
    
    // Neon colors with an underwater glow: vibrant purples and cyans
    vec3 coralColor = vec3(0.2, 0.6, 0.7) * (0.6 + 0.4 * sin(time + pos.y * 5.0));
    vec3 neonColor = vec3(0.8, 0.2, 0.9) * (0.5 + 0.5 * cos(time + pos.x * 7.0));
    
    // Synthesize final color by mixing based on combined factor
    vec3 color = mix(coralColor, neonColor, 0.5 + 0.5 * combined);
    
    // Dark vignette at the edges for focus
    float vignette = smoothstep(0.9, 0.4, length(pos));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}