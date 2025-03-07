precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitch(vec2 p) {
    float shift = noise(vec2(p.y * 20.0, time)) * 0.1;
    return p + vec2(shift, 0.0);
}

void main(void) {
    // Domain synthesis: underwater coral organic shape meets digital circuitry glitch.
    vec2 pos = (uv - 0.5) * 2.0;
    pos = glitch(pos);
    
    // Underwater swirling current (organic domain)
    float swirl = sin(5.0 * length(pos) - time * 2.0 + fbm(pos * 3.0));
    float coralShape = smoothstep(0.4 + 0.15 * fbm(pos * 5.0), 0.38, length(pos));
    
    // Digital circuitry motif (grid and glitches from the digital domain)
    vec2 gridUV = fract(pos * 10.0);
    float grid = smoothstep(0.02, 0.0, min(gridUV.x, gridUV.y)) +
                 smoothstep(0.02, 0.0, min(1.0 - gridUV.x, 1.0 - gridUV.y));
    
    // Combine both domains: underwater organic with digital glitches.
    float combined = mix(swirl, grid, 0.5 + 0.5 * sin(time * 0.7));
    combined *= coralShape;
    
    // Color synthesis: deep sea blues and neon circuit greens.
    vec3 deepSea = vec3(0.0, 0.2, 0.4) + 0.3 * fbm(pos * 2.0);
    vec3 neonCircuit = vec3(0.0, 0.8, 0.4) * abs(sin(time + pos.x*3.0));
    vec3 color = mix(deepSea, neonCircuit, grid);
    color *= (0.5 + 0.5 * combined);
    
    gl_FragColor = vec4(color, 1.0);
}