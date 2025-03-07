precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 239.345);
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
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitch(vec2 p, float seed) {
    float t = time + seed;
    float shift = (noise(p * 10.0 + t) - 0.5) * 0.08;
    return p + vec2(shift, shift);
}

float starburst(vec2 pos) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float wave = sin(angle * 8.0 + time * 4.0) * 0.1;
    return smoothstep(0.0, 0.02, abs(radius - wave));
}

float organicShape(vec2 p) {
    vec2 center = vec2(0.0, -0.1);
    p -= center;
    vec2 radii = vec2(0.6, 0.4);
    float ell = length(p / radii) - 1.0;
    float angle = atan(p.y, p.x);
    float wave = 0.1 * sin(6.0 * angle + time * 1.5);
    return ell + wave;
}

float organicPulse(vec2 pos) {
    float r = length(pos);
    float pulse = sin(r * 12.0 - time * 3.0);
    return smoothstep(0.3, 0.31, abs(pulse));
}

void main() {
    // Map UV from [0,1] to [-1,1] and scale slightly
    vec2 st = uv * 2.0 - 1.0;
    st *= 1.2;

    // Apply glitch distortion to a copy of st for digital effects
    vec2 distorted = glitch(st, 3.14);

    // Cosmic fractal background with fbm and starburst pattern
    float f = fbm(distorted * 2.0);
    float burst = starburst(distorted);
    vec3 bgColor = mix(vec3(0.1, 0.05, 0.2), vec3(0.0, 0.2, 0.4), f + burst);

    // Organic shape texture using calculus-inspired implicit function
    float shapeVal = organicShape(st);
    float shapeAlpha = smoothstep(0.02, -0.02, shapeVal);
    
    // Color dynamics for the organic part with pulsing effects
    float pulse = organicPulse(st);
    vec3 organicColor1 = vec3(0.2 + 0.3 * sin(time + st.x * 5.0), 0.4 + 0.3 * cos(time + st.y * 7.0), 0.3);
    vec3 organicColor2 = vec3(0.8, 0.4, 0.2);
    float textureMod = fbm(st * 5.0 + time * 0.5);
    vec3 bodyColor = mix(organicColor1, organicColor2, textureMod);
    bodyColor = mix(bodyColor, vec3(0.9, 0.6, 0.5), pulse);

    // Integrate digital glitch artifacts along the organic shape's edge
    float glitchEffect = pseudoRandom(st * 10.0 + time);
    bodyColor += 0.15 * vec3(glitchEffect, glitchEffect * 0.5, 1.0 - glitchEffect);

    // Blend the organic element with the fractal cosmos using the shape alpha as mask
    vec3 finalColor = mix(bgColor, bodyColor, shapeAlpha);

    // Overlay subtle digital stripes based on UV coordinates
    float stripe = step(0.45, fract(uv.y * 20.0 + time));
    finalColor = mix(finalColor, vec3(0.0), stripe * 0.15);

    gl_FragColor = vec4(finalColor, 1.0);
}