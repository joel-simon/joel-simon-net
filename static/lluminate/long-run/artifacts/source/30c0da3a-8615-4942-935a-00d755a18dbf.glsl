precision mediump float;
varying vec2 uv;
uniform float time;

// Random function based on input vector
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Swirl transformation based on distance from center and time modulation
vec2 swirl(vec2 coord) {
    vec2 centered = coord - vec2(0.5);
    float angle = length(centered) * 6.2831;
    angle += time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(
        centered.x * c - centered.y * s,
        centered.x * s + centered.y * c
    );
    return rotated + vec2(0.5);
}

// Implicit crystal shape using a modulated circle function
float crystalShape(vec2 p) {
    vec2 pos = (p - vec2(0.5)) * 2.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    // Create modulation to form a pseudo-crystal outline (6-fold symmetry)
    float modulation = sin(6.0 * angle + fbm(pos * 3.0 + time)) * 0.15;
    return radius - (0.3 + modulation);
}

// Digital glitch effect using fbm noise for offset distortion
vec2 digitalGlitch(vec2 p) {
    float shift = fbm(p * 8.0 + time);
    p.x += sin(p.y * 20.0 + time * 2.0) * 0.02 * shift;
    p.y += cos(p.x * 20.0 - time * 2.0) * 0.02 * shift;
    return p;
}

void main() {
    // Apply swirl effect then digital glitch for blended distortion
    vec2 pos = swirl(uv);
    pos = digitalGlitch(pos);
    
    // Evaluate the crystal shape function
    float shape = crystalShape(pos);
    
    // Smooth boundaries for the shape
    float edge = smoothstep(0.02, -0.02, shape);
    
    // Create internal texture using fbm noise
    float textureLayer = fbm(pos * 6.0 + time * 0.7);
    
    // Base colors: deep blue with digital cyan highlights
    vec3 baseColor = vec3(0.1, 0.1, 0.4);
    vec3 highlight = vec3(0.0, 0.8, 0.8);
    
    // Mix based on the texture intensity modulated by a sin wave pulse
    float pulse = abs(sin(time * 0.8)) * 0.5 + 0.5;
    vec3 colorMix = mix(baseColor, highlight, textureLayer * pulse);
    
    // Background gradient
    vec3 bgColor = mix(vec3(0.0, 0.0, 0.1), vec3(0.0, 0.0, 0.2), uv.y);
    
    // Final composition: crystal shape emerges from digital background
    vec3 finalColor = mix(bgColor, colorMix, edge);
    
    gl_FragColor = vec4(finalColor, 1.0);
}