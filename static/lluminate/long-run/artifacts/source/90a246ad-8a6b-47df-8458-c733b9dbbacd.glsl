precision mediump float;
varying vec2 uv;
uniform float time;

// 2D random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    // Smooth Interpolation
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Swirl function: rotates uv around center with radial strength
vec2 swirl(vec2 p, float amt) {
    vec2 center = vec2(0.5);
    vec2 toCenter = p - center;
    float dist = length(toCenter);
    float angle = amt * (1.0 - dist);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return center + rot * toCenter;
}

void main() {
    // Apply swirl distortion based on time and noise
    vec2 p = uv;
    float n = noise(p * 3.0 + time * 0.5);
    p = swirl(p, n * 6.2831);
    
    // Generate a dynamic grid pattern using sinusoidal functions and noise
    float gridX = abs(sin((p.x + time * 0.2) * 20.0));
    float gridY = abs(sin((p.y + time * 0.2) * 20.0));
    float grid = smoothstep(0.0, 0.1, min(gridX, gridY));
    
    // Glitch effect: random speckles appear intermittently.
    float glitch = step(0.95, noise(p * 80.0 - time * 5.0));
    
    // Color scheme: mix vibrant colors and dark background.
    vec3 baseColor = mix(vec3(0.05, 0.05, 0.1), vec3(0.2, 0.1, 0.4), p.y);
    vec3 gridColor = mix(vec3(1.0, 0.5, 0.8), vec3(0.9, 0.7, 0.2), p.x);
    
    // Composite the layers with grid and glitch patterns
    vec3 color = mix(baseColor, gridColor, grid);
    color = mix(color, vec3(1.0, 1.0, 1.0), glitch * 0.8);
    
    gl_FragColor = vec4(color, 1.0);
}