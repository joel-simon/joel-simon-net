precision mediump float;
varying vec2 uv;
uniform float time;

// 2D random function
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

// Smooth noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Layered fractal noise
float fbm(vec2 st) {
    float v = 0.0, a = 0.5;
    for (int i = 0; i < 5; i++) {
        v += a * noise(st);
        st *= 2.0;
        a *= 0.5;
    }
    return v;
}

// Transform function: polar twist and pulsing disruption
vec2 polarTwist(vec2 st, float amt) {
    st -= 0.5;
    float r = length(st);
    float theta = atan(st.y, st.x);
    // Apply a time driven twist and radial pulse based on medium associations
    theta += amt * sin(3.0 * r - time);
    st = vec2(cos(theta), sin(theta)) * r;
    st += 0.5;
    return st;
}

// Digital glitch displacement using medium-distance association between organic and digital
vec2 glitch(vec2 st) {
    float t = time;
    float glitchAmt = smoothstep(0.4, 0.0, abs(sin(10.0 * st.y + t)));
    st.x += glitchAmt * sin(30.0 * st.y + t);
    st.y += glitchAmt * cos(30.0 * st.x - t);
    return st;
}

// Main artistic blend: Mixing organic fractal growth with disruptive digital artifacts
vec3 artisticBlend(vec2 st) {
    vec2 stPolar = polarTwist(st, 0.8);
    vec2 stGlitch = glitch(st);
    float organic = fbm(stPolar * 8.0 + time);
    float digital = fbm(stGlitch * 15.0 - time);
    float mixVal = smoothstep(0.4, 0.6, fbm(st * 10.0));
    vec3 colOrganic = mix(vec3(0.1, 0.3, 0.05), vec3(0.4, 0.7, 0.4), organic);
    vec3 colDigital = mix(vec3(0.0, 0.0, 0.0), vec3(0.9, 0.2, 0.5), digital);
    return mix(colOrganic, colDigital, mixVal);
}

void main(){
    vec2 st = uv;
    vec3 color = artisticBlend(st);
    gl_FragColor = vec4(color, 1.0);
}