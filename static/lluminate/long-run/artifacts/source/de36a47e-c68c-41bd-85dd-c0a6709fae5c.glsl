precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Organic waveform that mimics electric pulses merging with digital noise
float organicPulse(vec2 p) {
    p *= 3.0;
    float pulse = sin(p.x + sin(p.y + time) * 3.0);
    float distort = fbm(p + time * 0.5);
    return smoothstep(0.4, 0.5, abs(pulse)) * distort;
}

// Digital wormhole effect using reverse radial distortion
float digitalWormhole(vec2 p) {
    vec2 centered = p - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    float spiral = abs(sin(10.0 * r - time * 2.0 + angle * 5.0));
    float warp = smoothstep(0.4, 0.0, r);
    return spiral * warp;
}

// Glitch effect by warping UV coordinates with high frequency noise
vec2 applyGlitch(vec2 p) {
    float shift = 0.02 * sin(time * 5.0 + p.y * 50.0);
    p.x += shift;
    shift = 0.02 * cos(time * 4.0 + p.x * 50.0);
    p.y += shift;
    return p;
}

void main() {
    vec2 p = uv;
    vec3 bgDigital = vec3(0.05, 0.1, 0.2);
    vec3 bgOrganic = vec3(0.1, 0.35, 0.15);
    vec3 background = mix(bgDigital, bgOrganic, p.y);
    
    // Apply glitch to UV coordinates
    vec2 glitchCoord = applyGlitch(p);
    float glitchNoise = fbm(glitchCoord * 10.0 + time);
    
    // Create an organic pulse layer with digital distortions
    float pulseLayer = organicPulse(p);
    
    // Create a digital wormhole that seems to pull in the organic pulse
    float wormholeLayer = digitalWormhole(p);
    
    // Combine the layers with reverse blending: wormhole bosses organic pulse
    float combinedLayer = mix(pulseLayer, wormholeLayer, 0.6);
    
    // Synthesize colors: warm organic and cool digital split based on combined layer
    vec3 warmColor = vec3(1.0, 0.5, 0.3);
    vec3 coolColor = vec3(0.3, 0.6, 1.0);
    vec3 layerColor = mix(warmColor, coolColor, combinedLayer);
    
    // Overlay glitch flashes on high glitch noise areas
    float flash = smoothstep(0.75, 0.80, glitchNoise);
    vec3 flashColor = vec3(0.9, 0.9, 1.0) * flash;
    
    vec3 finalColor = mix(background, layerColor, 0.7) + flashColor;
    
    gl_FragColor = vec4(finalColor, 1.0);
}