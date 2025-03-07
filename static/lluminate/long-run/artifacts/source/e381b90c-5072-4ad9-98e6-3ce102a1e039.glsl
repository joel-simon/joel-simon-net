precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(73.14, 19.42))) * 43758.5453);
}

// 2D noise.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// SCAMPER applied: 
// Base concept replaced: instead of organic or glitch, we create a cosmic waveform.
// Combine operations: combine swirl and star-like noise field.
// Adapt operations: adapt swirling vortex with star bursts.

// Vortex function.
vec2 vortex(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * pos;
}

// Star burst function using radial noise.
float starBurst(vec2 pos, float t) {
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float burst = smoothstep(0.0, 0.02, abs(sin(10.0 * a + t * 3.0)));
    burst *= smoothstep(0.4, 0.0, r);
    return burst;
}

// Cosmic waveform texture combining vortex distortion and star bursts.
vec3 cosmicTexture(vec2 pos, float t) {
    // Apply vortex distortions.
    pos = vortex(pos, 2.5);
    // Base gradient background.
    vec3 color1 = vec3(0.0, 0.05, 0.15);
    vec3 color2 = vec3(0.1, 0.2, 0.3);
    float grad = smoothstep(0.0, 1.0, length(pos));
    vec3 bg = mix(color1, color2, grad);
    
    // Fractal-like noise overlay.
    float n = 0.0;
    vec2 np = pos * 2.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        n += noise(np + t) * amp;
        np *= 1.7;
        amp *= 0.5;
    }
    
    // Star bursts
    float burst = starBurst(pos, t);
    
    // Color modulation.
    vec3 modColor = vec3(0.6 + 0.4 * sin(n * 3.14 + t),
                         0.3 + 0.7 * cos(n * 2.0 - t),
                         0.5 + 0.5 * sin(n * 4.0 + t));
    
    // Combine background with burst and modulation.
    vec3 finalColor = mix(bg, modColor, 0.5 + 0.5 * burst);
    return finalColor;
}

void main() {
    // Transform uv to centered coordinates [-1,1] and apply aspect as square.
    vec2 st = uv * 2.0 - 1.0;
    
    // Create cosmic texture using transformed coordinates.
    vec3 color = cosmicTexture(st, time);
    
    gl_FragColor = vec4(color, 1.0);
}