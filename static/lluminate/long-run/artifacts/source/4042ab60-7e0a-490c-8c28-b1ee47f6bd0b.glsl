precision mediump float;
varying vec2 uv;
uniform float time;

float rand(in vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

vec2 toCartesian(vec2 pa) {
    return vec2(pa.x * cos(pa.y), pa.x * sin(pa.y));
}

vec2 reverseRadial(vec2 p, float t) {
    // Instead of swirling, expand and contract the radial distance
    vec2 polar = toPolar(p);
    // Reverse the assumption: radial distance now modulated by a cosine ripple
    polar.x = mix(polar.x, 1.0 / (polar.x + 0.0001), 0.5 + 0.5 * sin(t + polar.y * 4.0));
    return toCartesian(polar);
}

void main() {
    // Center uv coordinates to [-1,1] with an offset
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Reverse traditional swirl: use reverse radial distortion that inverts and modulates
    vec2 revPos = reverseRadial(pos, time * 0.8);
    
    // Generate a reverse fractal noise pattern by inverting the usual layering
    float accum = 0.0;
    float scale = 1.0;
    vec2 np = revPos * 2.0;
    for (int i = 0; i < 5; i++) {
        accum += (1.0 - noise(np + vec2(time * 0.4))) * scale;
        np *= 1.8;
        scale *= 0.6;
    }
    
    // Generate glitch interruptions that randomly cut through the pattern
    float glitchPattern = step(0.98, rand(uv * (time + 1.0))) * 0.4;
    float linePattern = smoothstep(0.3, 0.31, abs(fract(revPos.x * 15.0 + time * 3.0) - 0.5));
    
    // Dynamic color palette: inverting common dark backgrounds to bright and vice versa.
    vec3 colorBase = vec3(0.7, 0.85, 0.95) - accum * 0.8;
    vec3 glitchColor = vec3(0.9, 0.2, 0.3) * glitchPattern;
    
    // Blend the base with lines and glitch interruptions
    vec3 finalColor = colorBase + linePattern * vec3(0.15, 0.1, 0.05) + glitchColor;
    
    // Reverse vignette: brighten near the edges instead
    float edgeBright = smoothstep(0.0, 0.8, length(pos));
    finalColor += edgeBright * 0.2;
    
    gl_FragColor = vec4(finalColor, 1.0);
}