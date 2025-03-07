precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453123);
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
    float amp = 0.5;
    for (int i = 0; i < 5; i++){
        total += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

vec2 swirlEffect(vec2 p, float strength) {
    float angle = strength * fbm(p * 5.0 + time);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec2 glitch(vec2 p, float t) {
    float shift = step(0.95, fract(sin(dot(p, vec2(12.345, 67.890)) + t*7.0))) * 0.1;
    return p + vec2(shift, 0.0);
}

vec3 organicLayer(vec2 p) {
    // Remap coordinate for organic swelling effect
    vec2 center = p - 0.5;
    float r = length(center);
    float organic = smoothstep(0.5, 0.3, r + 0.2 * sin(time + 10.0 * fbm(p * 3.0)));
    // Blend earthy tones with pulsating intensity
    return mix(vec3(0.2, 0.5, 0.3), vec3(0.8, 0.6, 0.3), organic);
}

vec3 digitalLayer(vec2 p) {
    // introduce pixel-like glitch and digital ripple effect
    vec2 grid = fract(p * 20.0 + time);
    float line = smoothstep(0.0, 0.03, abs(grid.x - 0.5));
    float glitchProb = step(0.85, hash(p * 10.0 + vec2(time, time)));
    vec3 base = mix(vec3(0.1, 0.1, 0.25), vec3(0.8, 0.9, 1.0), line + glitchProb * 0.3);
    return base;
}

void main(){
    // Normalize uv to [0,1] then apply swirl and glitch effects
    vec2 pos = uv;
    // Domain swap: organic structure (biology) meets digital distortion.
    // Swirl effect simulates natural currents while glitch creates digital interference.
    vec2 swirled = swirlEffect(pos, 5.0);
    vec2 glitched = glitch(swirled, time);
    
    // Organic layer: soft, pulsating natural feel
    vec3 organic = organicLayer(glitched);
    
    // Digital layer: hard-edged, glitchy digital overlay
    vec3 digital = digitalLayer(pos);
    
    // Synthesize: mix domains based on noise generated blend factor.
    float blendFactor = smoothstep(0.3, 0.7, noise(pos * 3.0 + time));
    vec3 composite = mix(organic, digital, blendFactor);
    
    // Outer vignette to enhance focus
    float vignette = smoothstep(1.0, 0.2, length(pos - 0.5));
    gl_FragColor = vec4(composite * vignette, 1.0);
}