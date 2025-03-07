precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 glitchOffset(vec2 pos) {
    float n = fbm(pos * 8.0 + time * 0.5);
    pos.x += smoothstep(0.3, 0.7, n) * 0.05 * sin(time * 10.0);
    pos.y += smoothstep(0.3, 0.7, n) * 0.05 * cos(time * 10.0);
    return pos;
}

float treeBranch(vec2 p, float t) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    float branch = sin(5.0 * angle + t) * exp(-3.0 * r);
    return branch;
}

void main() {
    // Apply a digital glitch offset to the UV coordinates.
    vec2 pos = glitchOffset(uv);
    
    // Organic tree branch effect centered in the screen
    vec2 centered = (pos - 0.5) * 2.0;
    float branchEffect = treeBranch(centered, time);
    float fractalTexture = fbm(centered * 3.0 + time);
    float organicPattern = smoothstep(0.2, 0.25, abs(branchEffect)) + fractalTexture * 0.3;
    
    // Eye-like swirling vortex effect
    vec2 eyePos = uv * 2.0 - 1.0;
    float radius = length(eyePos);
    float angle = atan(eyePos.y, eyePos.x);
    float vortex = sin(10.0 * radius - time * 2.5 + angle * 2.0);
    float pupil = smoothstep(0.28, 0.26, abs(radius - 0.4 - 0.05 * vortex));
    float irisLayer = smoothstep(0.55, 0.57, radius) - smoothstep(0.6, 0.62, radius);
    float irisNoise = noise(uv * 8.0 + time * 0.5);
    irisLayer *= irisNoise * 1.2;
    vec3 eyeColor = mix(vec3(0.0), vec3(1.0, 0.8, 0.2), pupil);
    vec3 irisColor = mix(vec3(0.2, 0.4, 0.8), vec3(0.8, 0.4, 0.2), irisNoise);
    vec3 combinedEye = mix(eyeColor, irisColor, smoothstep(0.35, 0.5, radius));
    
    // Background dynamic gradient blending organic and digital themes.
    vec3 warmColor = vec3(1.0, 0.4, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(angle + time) + 1.0) * 0.5);
    
    // Radial pulsation effect.
    float pulse = smoothstep(0.3, 0.32, radius + 0.1 * sin(time * 3.0));
    float glitch = noise(vec2(uv.y * 10.0, time)) * 0.2;
    
    vec3 baseColor = mix(colorGradient, vec3(1.0, 0.9, 0.6), organicPattern) * pulse;
    baseColor += glitch * vec3(0.1, 0.1, 0.1);
    
    // Synthesize foreground eye effect with the organic digital background.
    vec3 finalColor = mix(baseColor, combinedEye, smoothstep(0.35, 0.45, radius));
    
    gl_FragColor = vec4(finalColor, 1.0);
}