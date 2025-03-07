precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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

vec2 digitalWarp(vec2 p, float t) {
    // Blend digital glitch with organic distortions:
    float n = noise(p * 3.0 + vec2(t, -t));
    float angle = n * 6.2831;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    return rot * p + vec2(n * 0.3, n * 0.3);
}

float circle(vec2 p, float r) {
    return smoothstep(r, r - 0.01, length(p));
}

void main() {
    // Center the coordinate space
    vec2 st = uv * 2.0 - 1.0;
    
    // Conceptual Space A: Organic, swirling fractal noise (natural growth)
    vec2 organic = st;
    organic += 0.3 * vec2(sin(time + st.y*3.0), cos(time + st.x*3.0));
    float organicNoise = fbm(organic * 2.0 + time * 0.2);
    
    // Conceptual Space B: Digital structure (glitch grid and circular motifs)
    vec2 digital = digitalWarp(st, time * 0.8);
    float grid = step(0.92, abs(fract(digital.x * 10.0) - 0.5)) * step(0.92, abs(fract(digital.y * 10.0) - 0.5));
    float circleShape = circle(digital, 0.3 + 0.1 * sin(time * 1.5));
    
    // Map cross-space: blend between organic and digital spaces using a smooth transition
    float blendFactor = smoothstep(-0.2, 0.2, st.y);
    float emergent = mix(organicNoise, grid + circleShape, blendFactor);
    
    // Develop emergent properties: pulsate and glitch additional digital distortion
    float glitch = smoothstep(0.4, 0.6, noise(st * 15.0 + time));
    emergent = mix(emergent, 1.0 - emergent, glitch * 0.5);
    
    vec3 colorOrganic = vec3(organicNoise * 0.5 + 0.5, organicNoise * 0.3, 0.4);
    vec3 colorDigital = vec3(grid, circleShape, 1.0 - grid);
    
    vec3 finalColor = mix(colorOrganic, colorDigital, blendFactor);
    finalColor = mix(finalColor, vec3(emergent), 0.3);
    
    gl_FragColor = vec4(finalColor, 1.0);
}