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
    return mix(a, b, u.x) * (1.0 - u.y) + mix(c, d, u.x) * u.y;
}

float fbm(vec2 p) {
    float total = 0.0, amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Combine two unrelated domains: Biological cell growth and cosmic fracturing.
// We'll distort the scene with "celullar burst" patterns over a cosmic background.
vec2 cellDisturb(vec2 pos) {
    float n = noise(pos * 5.0 + time);
    float burst = smoothstep(0.45, 0.55, n);
    float angle = burst * 6.2831;
    vec2 offset = vec2(cos(angle), sin(angle)) * 0.03;
    return pos + offset;
}

void main(void) {
    // Center uv in [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply cellular-like disturbance
    pos = cellDisturb(pos);
    
    // Convert to polar coordinates for cosmic fracture effect
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    
    // Create fractal cracks modulated by fbm as if cosmic energy is fracturing
    float crack = abs(sin(8.0 * theta + time * 1.2 + fbm(pos * 3.0)));
    crack = smoothstep(0.48, 0.5, crack);
    
    // Introduce a biological organic growth pattern using fbm
    float organic = fbm(pos * 4.0 - time * 0.5);
    
    // Cosmic radient background: deep purples and blues.
    vec3 cosmic = mix(vec3(0.05, 0.0, 0.2), vec3(0.0, 0.2, 0.5), r);
    
    // Organic cellular colors: pulsating magenta hints.
    vec3 organicColor = vec3(0.7, 0.0, 0.4) * (0.5 + 0.5 * sin(time + organic * 6.2831));
    
    // Synthesize the blend: use cracks as tension and blend cosmic and organic.
    vec3 baseColor = mix(cosmic, organicColor, organic);
    vec3 finalColor = mix(baseColor, vec3(1.0, 1.0, 1.0), crack * 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}