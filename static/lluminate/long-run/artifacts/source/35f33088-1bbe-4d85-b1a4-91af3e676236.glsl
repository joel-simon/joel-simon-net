precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st){
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 flip(vec2 p){
    return vec2(p.y, p.x);
}

float digitalDecay(vec2 p) {
    // Reverse the expectation of continuous growth: instead of smooth evolution, introduce sudden decays.
    float d = length(p);
    float tDecay = mod(time, 3.0);
    float glitch = step(0.9, random(p * time));
    float wave = sin(12.0 * d - time * 4.0);
    return smoothstep(0.4 + 0.15 * glitch, 0.35, d + 0.08 * wave);
}

vec3 glitchTexture(vec2 p) {
    // Disrupt the normal color evolution by confusing the coordinate system.
    vec2 rp = flip(p) + vec2(sin(time), cos(time));
    float n = noise(rp * 5.0 + time);
    vec3 col = vec3(n * sin(time), n * cos(time), n);
    return col;
}

vec3 decayColor(vec2 p) {
    // Inverse the idea of an organic blossom by emulating digital decay
    float r = digitalDecay(p);
    float n = noise(p * 8.0 + vec2(time));
    vec3 base = vec3(0.2, 0.1, 0.3);
    vec3 pulse = vec3(0.8, 0.4, 0.6) * abs(sin(time + n * 6.2831));
    return mix(base, pulse, r);
}

void main(){
    // Center uv into coordinate system [-1,1] and invert axes for reversed assumption
    vec2 pos = (uv - 0.5) * 2.0;
    // Apply a rotation based on the flipped coordinate system
    float angle = sin(time * 0.5) * 3.1415;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);

    // Synthesize the two components: decayColor and glitchTexture
    vec3 colorDecay = decayColor(pos);
    vec3 colorGlitch = glitchTexture(pos);

    // Blend them using a dynamic mask influenced by digital decay
    float mask = digitalDecay(pos) * 0.7 + 0.3 * noise(pos * 2.0 + time);
    vec3 finalColor = mix(colorGlitch, colorDecay, mask);

    // Introduce abrupt digital artifacts
    float artifact = step(0.97, random(uv * time * 2.0));
    finalColor += artifact * vec3(0.5, 0.2, 0.7);

    gl_FragColor = vec4(finalColor, 1.0);
}