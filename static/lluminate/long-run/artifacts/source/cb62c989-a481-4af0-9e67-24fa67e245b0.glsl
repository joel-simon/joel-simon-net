precision mediump float;
varying vec2 uv;
uniform float time;

// Basic random function
float random (in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion function
float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Organic cell pattern resembling growth
float organicCell(in vec2 p) {
    // Using polar coordinates to create radial cells
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float cells = 5.0;
    float pattern = abs(sin(cells * angle)) / (1.0 + 10.0 * abs(radius - 0.5));
    return pattern;
}

// Digital glitch distortion by blending two spaces
vec2 digitalGlitch(in vec2 p) {
    float n = fbm(p * 8.0 + time * 0.5);
    // Modulate position with digital grid offsets
    p.x += smoothstep(0.2, 0.8, n) * 0.05 * sin(time * 12.0);
    p.y += smoothstep(0.2, 0.8, n) * 0.05 * cos(time * 12.0);
    return p;
}

// Emergent blend that fuses organic growth and digital glitch structures
vec3 emergentScene(in vec2 uv) {
    // Space 1: organic cellular growth
    vec2 organicCoord = (uv - 0.5) * 2.0;
    float organic = organicCell(organicCoord);
    
    // Space 2: digital grid influenced fractal noise space
    vec2 glitchCoord = digitalGlitch(uv * 4.0);
    float grid = step(0.5, fbm(glitchCoord + time * 0.3));
    
    // Blend the two conceptual spaces
    float blend = mix(organic, grid, 0.4);
    
    // Create color palettes: organic: greenish-teal, digital: magenta glitch
    vec3 organicColor = vec3(0.2, 0.7, 0.6);
    vec3 digitalColor = vec3(0.8, 0.2, 0.8);
    
    // Create emergent color
    vec3 color = mix(organicColor, digitalColor, blend);
    
    // Add subtle pulsation for emergent dynamic texture
    float pulse = 0.5 + 0.5*sin(time*3.0);
    return color * pulse;
}

void main() {
    vec2 pos = uv;
    vec3 color = emergentScene(pos);
    gl_FragColor = vec4(color, 1.0);
}