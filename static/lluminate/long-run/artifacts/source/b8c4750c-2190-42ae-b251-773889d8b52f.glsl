precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float f = 0.0;
    f += 0.5000 * noise(p); p *= 2.02;
    f += 0.2500 * noise(p); p *= 2.03;
    f += 0.1250 * noise(p); p *= 2.01;
    f += 0.0625 * noise(p);
    return f;
}

vec2 glitchDistort(vec2 p) {
    float offset = noise(vec2(p.y * 15.0, time * 2.0));
    return p + vec2(offset * 0.1, 0.0);
}

float radialPattern(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    // Reverse swirling: invert angle progression over time.
    float swirl = sin(a * 5.0 - time * 2.0);
    return smoothstep(0.4 + 0.1 * swirl, 0.38 + 0.1 * swirl, r);
}

float branchFractal(vec2 p) {
    // Organic branching using fbm and reversed polar coordinates
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float branch = fbm(p * 3.0 + vec2(cos(time), sin(time))*2.0);
    float pattern = sin(branch * 10.0 + angle * 3.0);
    return smoothstep(0.4, 0.5, abs(pattern) + radius);
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    pos = glitchDistort(pos);
    
    float radial = radialPattern(pos);
    float branch = branchFractal(pos);
    
    // Organic base with digital twist: blend earth tone with neon glow.
    vec3 organicColor = vec3(0.2, 0.6, 0.3) * (0.5 + 0.5 * fbm(pos * 2.0 + time));
    vec3 glitchColor = vec3(0.1, 0.8, 0.9) * (0.5 + 0.5 * cos(time + pos.x * 5.0));
    
    // Combine using reverse weighting over distance.
    vec3 baseColor = mix(glitchColor, organicColor, radial);
    
    // Imprint branching pattern as digital glitches
    baseColor += branch * vec3(0.4, 0.4, 0.2);
    
    gl_FragColor = vec4(baseColor, 1.0);
}