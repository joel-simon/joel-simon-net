precision mediump float;
varying vec2 uv;
uniform float time;

// Basic random function
float random(in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Swirl distortion: rotates UV based on distance and time (organic growth element)
vec2 swirl(in vec2 p) {
    vec2 center = vec2(0.5);
    vec2 offset = p - center;
    float angle = 3.1416 * fbm(p * 3.0 + time * 0.5);
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(offset.x * c - offset.y * s, offset.x * s + offset.y * c);
    return rotated + center;
}

// Digital glitch function: warps UV with random horizontal disruptions
vec2 digitalGlitch(in vec2 p) {
    float glitchStrength = smoothstep(0.2, 0.8, fbm(p * 15.0 + time));
    p.x += glitchStrength * 0.05 * sin(time * 20.0 + p.y * 50.0);
    return p;
}

// Emergent fractal branch: creates radial filaments (emergence element)
float fractalBranch(in vec2 p) {
    // Convert to polar coordinates centered at middle.
    vec2 centered = p - vec2(0.5);
    float r = length(centered);
    float a = atan(centered.y, centered.x);
    float branches = abs(sin(5.0 * a + fbm(p*10.0)));
    float mask = smoothstep(0.4, 0.38, r);
    return branches * mask;
}

void main() {
    // Map uv into a blended emergent space:
    vec2 pos = uv;
    pos = swirl(pos);
    pos = digitalGlitch(pos);
    
    // Create two conceptual spaces:
    // Organic ambiance via fractal branch growth and soft noise
    float organic = fbm(pos * 3.0 + time * 0.5);
    float branch = fractalBranch(pos);
    
    // Digital artifacts via high frequency noise glitches
    float digital = noise(pos * 20.0 - time);
    
    // Blend the two spaces selectively to form emergent texture
    float blendA = mix(organic, branch, 0.5);
    float blendB = mix(blendA, digital, 0.3);
    
    // Color mapping: organic space uses earthy greens and browns; digital space uses cool cyans and white
    vec3 organicColor = vec3(0.2, 0.5, 0.3) * (organic + branch);
    vec3 digitalColor = vec3(0.3, 0.7, 0.9) * digital;
    vec3 finalColor = mix(organicColor, digitalColor, clamp(blendB,0.0,1.0));
    
    // Final emergent structure is modulated with time-based pulsation
    finalColor *= (0.7 + 0.3 * sin(time * 2.0));
    
    gl_FragColor = vec4(finalColor, 1.0);
}