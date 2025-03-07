precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 239.345);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 1.8;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitch(vec2 p, float seed) {
    float t = time - seed; // Reverse time effect for a flipped glitch
    float shift = (noise(p * 10.0 + t) - 0.5) * 0.1;
    return p + vec2(shift, -shift); // Combine directional shifts to create asymmetry
}

float radialWave(vec2 pos) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float wave = sin(angle * 6.0 - time * 2.5);
    float pattern = smoothstep(0.02, 0.04, abs(radius - wave));
    return pattern;
}

float digitalOrganic(vec2 pos) {
    float r = length(pos);
    float wave = sin(r * 10.0 + time * 3.0);
    return smoothstep(0.28, 0.32, abs(wave));
}

void main() {
    // Base transformation: center and scale uv coordinates
    vec2 st = uv * 2.0 - 1.0;
    st *= 1.1;
    
    // Reverse horizontal coordinates to adapt and reverse the pattern generation
    st.x = -st.x;
    
    // Apply a reverse glitch distortion using modified glitch function
    vec2 distorted = glitch(st, 2.71);
    
    // Synthesize two layers: a radial wave and a digital-organic pulse
    float waveLayer = fbm(distorted * 2.2) + radialWave(distorted);
    float organicLayer = digitalOrganic(st);
    
    // Create a blended background mixing cosmic digital hues with organic warmth
    vec3 cosmic = mix(vec3(0.05, 0.0, 0.15), vec3(0.0, 0.3, 0.5), waveLayer);
    vec3 organic = mix(vec3(0.7, 0.2, 0.3), vec3(0.2, 0.7, 0.5), organicLayer);
    
    // Combine layers with a modulation based on sine functions for dynamic evolution
    vec3 color = mix(cosmic, organic, 0.5 + 0.5 * sin(time * 0.9));
    
    // Final subtle overlay of glitch stripes for digital texture
    float stripe = step(0.5, fract(uv.y * 15.0 - time));
    color = mix(color, vec3(0.0), stripe * 0.2);
    
    gl_FragColor = vec4(color, 1.0);
}