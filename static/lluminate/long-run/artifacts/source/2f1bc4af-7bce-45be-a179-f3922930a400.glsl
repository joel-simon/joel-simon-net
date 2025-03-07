precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random generator
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Simple 2D noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Fractal Brownian Motion for extra complexity
float fbm(vec2 st) {
    float value = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amp * noise(st);
        st *= 2.0;
        amp *= 0.5;
    }
    return value;
}

// Digital distortion: introduce glitch by perturbing coordinates
vec2 digitalDistort(vec2 pos, float t) {
    float err = noise(pos * 10.0 + t * 1.5);
    pos += vec2(sin(err * 6.28), cos(err * 6.28)) * 0.03;
    return pos;
}

// Organic swirling effect: simulating natural curves with noise influence
vec3 organicSwirl(vec2 pos, float t) {
    pos = digitalDistort(pos, t);
    float angle = fbm(pos * 3.0 + t);
    float radius = length(pos);
    float swirl = sin(angle * 6.2831 + radius * 8.0 - t);
    vec3 col = vec3(0.3 + 0.7 * sin(radius * 12.0 + t),
                    0.5 + 0.5 * cos(angle * 3.0 - t),
                    0.4 + 0.6 * sin(swirl * 9.0));
    return col;
}

// Butterfly wing field: combining mirrored elliptical shapes with dynamic modulation
float butterflyField(vec2 pos, float scale) {
    vec2 p = pos * 2.0;
    float leftWing = 1.0 - length(vec2(p.x + 0.5, p.y)) * scale;
    float rightWing = 1.0 - length(vec2(p.x - 0.5, p.y)) * scale;
    float wings = max(leftWing, rightWing);
    wings += 0.2 * sin(time * 3.0 + fbm(pos * 5.0));
    return wings;
}

// Digital grid effect to add structured chaos overlay
vec3 digitalGrid(vec2 pos) {
    vec2 gridUV = fract(pos * 15.0);
    float lines = smoothstep(0.0, 0.05, gridUV.x) + smoothstep(1.0, 0.95, gridUV.x)
                + smoothstep(0.0, 0.05, gridUV.y) + smoothstep(1.0, 0.95, gridUV.y);
    float glitch = step(0.98, random(pos + time));
    return mix(vec3(0.0, 0.0, 0.0), vec3(0.9, 0.6, 0.2), lines * 0.5 + glitch * 0.5);
}

void main() {
    // Center uv coordinates ranging from -1 to 1
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply rotation for dynamic movement
    float angle = time * 0.3;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Generate dynamic fractal background with FBM noise
    float fractal = fbm(rotated * 3.0 + time);
    vec3 background = vec3(0.1, 0.15, 0.25) + vec3(0.2, 0.25, 0.3) * fractal;
    
    // Create organic swirling visuals influenced by digital distortion
    vec3 swirlColor = organicSwirl(pos, time);
    
    // Compute butterfly field to simulate rebirth and organic form
    float wings = butterflyField(pos, 1.5);
    vec3 wingColor = vec3(0.8, 0.3, 0.7) * smoothstep(0.2, 0.5, wings);
    
    // Overlay digital grid to inject a structured glitch aesthetic
    vec3 grid = digitalGrid(uv + vec2(time * 0.05));
    
    // Blend the different domains: organic swirl, digital grid, and butterfly symbols
    vec3 mixColor = mix(background, grid, 0.3);
    mixColor = mix(mixColor, wingColor, smoothstep(0.45, 0.55, wings));
    
    // Further blend with the swirl effect to synthesize both realms
    vec3 finalColor = mix(swirlColor, mixColor, 0.5);
    
    // Add subtle pulsation to simulate life-like behavior in digital-info space
    finalColor += 0.1 * vec3(sin(time + uv.x * 10.0),
                             cos(time + uv.y * 10.0),
                             sin(time * 1.5));
                             
    gl_FragColor = vec4(finalColor, 1.0);
}