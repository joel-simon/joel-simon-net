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
    float b = random(i + vec2(1.0,0.0));
    float c = random(i + vec2(0.0,1.0));
    float d = random(i + vec2(1.0,1.0));
    vec2 u = f * f * (3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec3 cosmicAlgae(vec2 pos) {
    // Domain blending: cosmic energy meets organic algae.
    float n = fbm(pos * 3.0 + time * 0.7);
    float pulse = sin(time + length(pos)*10.0);
    float intensity = smoothstep(0.2, 0.8, n + pulse * 0.3);
    vec3 algaeColor = vec3(0.1, 0.8, 0.3) * intensity;
    return algaeColor;
}

vec3 harmonicDistortion(vec2 pos) {
    // Simulate harmonic physics with oscillatory wave interference.
    float angle = time * 2.0 + fbm(pos * 6.0);
    float wave = sin(angle + pos.x * 4.0) * cos(angle + pos.y * 4.0);
    float interference = fbm(pos * 8.0 + time);
    float blend = smoothstep(-0.5, 0.5, wave + interference);
    vec3 physicsColor = vec3(0.8, 0.4, 0.1) * blend;
    return physicsColor;
}

void main() {
    vec2 pos = (uv - 0.5) * 2.0;

    // Blend two totally different worlds.
    vec3 colorA = cosmicAlgae(uv * 5.0);
    vec3 colorB = harmonicDistortion(pos * 2.0);

    // Synthesize them using a time oscillation inspired blend.
    float mixFactor = smoothstep(-1.0, 1.0, sin(time + length(pos)*3.0));
    vec3 finalColor = mix(colorA, colorB, mixFactor);
    
    // Introduce a hidden random error as sparkling micro glitches.
    float sparkle = step(0.995, random(uv * time * 1.3));
    finalColor += sparkle * vec3(0.5, 0.2, 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}