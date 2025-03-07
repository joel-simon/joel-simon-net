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
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

float polarSwirl(vec2 p, float strength) {
    vec2 center = vec2(0.5);
    vec2 diff = p - center;
    float angle = atan(diff.y, diff.x) + strength * fbm(diff * 4.0 + time * 0.3);
    float radius = length(diff);
    return angle + radius;
}

float musicBars(vec2 p) {
    // Create vertical bars that oscillate in height like a digital equalizer.
    float barWidth = 0.04;
    float pos = mod(p.x, barWidth * 2.0);
    float bar = smoothstep(0.0, barWidth, pos) - smoothstep(barWidth, barWidth * 1.1, pos);
    // Oscillate bar height across time.
    float heightOsc = 0.3 + 0.2 * sin(time * 3.0 + p.x * 20.0);
    float bars = step(1.0 - heightOsc, p.y) * bar;
    return bars;
}

void main() {
    vec2 p = uv;
    
    // Domain 1: Cosmic Nebula (fractal and swirling cosmic background)
    vec2 swirlUV = p;
    float swirl = polarSwirl(swirlUV, 1.5);
    float nebula = fbm(p * 5.0 + swirl);
    vec3 cosmicColor = mix(vec3(0.05, 0.0, 0.1), vec3(0.4, 0.2, 0.5), nebula);
    
    // Domain 2: Musical Equalizer (digital, rhythmic bars)
    float bars = musicBars(p);
    vec3 barsColor = mix(vec3(0.0, 0.1, 0.2), vec3(0.0, 0.8, 1.0), bars);
    
    // Synthesize: Blend both cosmic and digital musical elements.
    // Use the bars as a dynamic spotlight overlaying the cosmic background.
    vec3 finalColor = cosmicColor;
    finalColor = mix(finalColor, barsColor, bars);
    
    gl_FragColor = vec4(finalColor, 1.0);
}