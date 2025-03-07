precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

void main() {
    // Invert conventional coordinate expectations: origin is top-right rather than center.
    vec2 st = (uv - vec2(1.0, 1.0)) * 2.0;
    
    // Reverse assumption: Instead of calm gradients, create a chaotic swirling digital cosmos.
    float angle = time * 0.5 + fbm(st * 3.0);
    st = rotate(st, angle);
    
    // Build a dual layer of patterns:
    // Layer 1: A fractal landscape of reversed noise: high values denote void holes.
    float n1 = fbm(st * 2.5 - time * 0.3);
    float landscape = smoothstep(0.6, 0.65, n1);
    
    // Layer 2: A grid of glitch-like cells is imposed by a repetitive modulated pattern.
    vec2 grid = fract(st * 4.0);
    float cell = step(0.3, grid.x) * step(0.3, grid.y) * step(grid.x, 0.7) * step(grid.y, 0.7);
    
    // Reverse conventional expectation: use cell value as negative influence.
    float glitch = 1.0 - cell;
    
    // Mix a digital neon color scheme with reversed organic gradients.
    vec3 colorA = vec3(0.05, 0.2, 0.4); // deep digital void
    vec3 colorB = vec3(0.8, 0.3, 0.9);  // unexpected neon burst

    // Dynamic color modulation based on noise and glitch intensity.
    float mixFactor = fbm(st * 5.0 + time);
    vec3 baseColor = mix(colorA, colorB, mixFactor);

    // Blend with glitch grid and chaotic landscape.
    vec3 finalColor = mix(baseColor, vec3(0.0), landscape);
    finalColor = mix(finalColor, vec3(1.0, 0.5, 0.2), glitch * 0.4);

    gl_FragColor = vec4(finalColor, 1.0);
}