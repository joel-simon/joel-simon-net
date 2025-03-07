precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 pos) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += noise(pos) * amp;
        pos *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 polarDistort(vec2 p, float strength) {
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += sin(r * 10.0 - time) * strength;
    return vec2(r * cos(theta), r * sin(theta));
}

vec2 timeGlitch(vec2 p) {
    float shift = step(0.95, fract(fbm(p * 10.0 + time)));
    p.x += shift * 0.1;
    return p;
}

float organicWave(vec2 p) {
    p *= 2.0;
    float wave = sin(p.x * 4.0 + time) * cos(p.y * 4.0 - time);
    return smoothstep(0.4, 0.6, abs(wave));
}

void main(void) {
    vec2 pos = uv;
    pos = timeGlitch(pos);
    
    vec2 centered = pos - 0.5;
    vec2 distorted = polarDistort(centered, 0.5);
    distorted += 0.5;
    
    float patternFBM = fbm(pos * 3.0 + time * 0.3);
    float patternOrganic = organicWave(distorted);
    float combinedPattern = mix(patternFBM, patternOrganic, 0.7);
    
    float glitchEffect = smoothstep(0.45, 0.55, abs(sin(uv.y * 50.0 + time * 8.0)));
    
    vec3 colorOrganic = vec3(0.1, 0.5, 0.3);
    vec3 colorDigital = vec3(0.3, 0.1, 0.5);
    vec3 mixedColor = mix(colorOrganic, colorDigital, combinedPattern);
    mixedColor += glitchEffect * 0.2;
    
    gl_FragColor = vec4(mixedColor, 1.0);
}