precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random generator based on UV coordinate.
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise based on interpolation of random values.
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion (fbm) for richer noise detail.
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Digital glitch function: introduces temporal displacements.
vec2 digitalGlitch(vec2 pos, float intensity) {
    float glitchOffset = step(0.98, random(vec2(pos.y, time))) * intensity;
    return pos + vec2(glitchOffset, 0.0);
}

// Emergent fractal structure mixing celestial swirl with digital form.
float fractalStructure(vec2 pos) {
    float accum = 0.0;
    vec2 shift = vec2(cos(time), sin(time));
    for (int i = 0; i < 3; i++) {
        pos = abs(pos) / dot(pos, pos + 0.5) - shift;
        accum += length(pos);
    }
    return accum;
}

void main(void) {
    // Center UV and scale coordinates.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply digital glitch to the space.
    pos = digitalGlitch(pos, 0.3);
    
    // Map the celestial swirl: use polar transformation.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float swirl = sin(angle * 4.0 + time * 0.7);
    radius += swirl * 0.2;
    
    // Blend digital fractal structure with fbm noise.
    float emergent = fbm(pos * 3.0 + time) + fractalStructure(pos * 0.8);
    
    // Map emergent property into a pattern.
    float pattern = smoothstep(0.8, 1.2, emergent);
    
    // Celestial colors mixing warm nebula hues and cool digital tones.
    vec3 celestial = mix(vec3(0.8, 0.3, 0.4), vec3(0.2, 0.5, 0.9), noise(pos * 2.0 + time));
    // Overlay digital artifacts by modulating with grid pattern.
    vec2 grid = fract(uv * 30.0 - time * 0.5);
    float artifact = step(0.85, grid.x) * step(0.85, grid.y);
    celestial += vec3(artifact) * 0.25;
    
    // Combine all emergent structures with a subtle radial vignette.
    vec3 color = mix(celestial, vec3(0.0), smoothstep(0.9, 1.2, radius));
    color *= pattern;
    
    gl_FragColor = vec4(color, 1.0);
}