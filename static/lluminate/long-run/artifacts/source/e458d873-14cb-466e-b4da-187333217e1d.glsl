precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 radialWarp(vec2 p) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float warp = sin(angle * 3.0 + time) * 0.2;
    float newRadius = radius + warp;
    return vec2(cos(angle)*newRadius, sin(angle)*newRadius);
}

vec2 glitch(vec2 p) {
    float shift = noise(vec2(p.y * 10.0, time)) * 0.1;
    return p + vec2(shift, 0.0);
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    pos = glitch(pos);
    vec2 warped = radialWarp(pos * 1.5);
    
    float pattern = fbm(warped * 2.0 + time * 0.5);
    float mask = smoothstep(0.4, 0.45, length(pos));
    float pulse = sin(time * 3.0 + length(warped)*10.0);
    
    vec3 baseColor = vec3(0.3 + 0.7*pattern, 0.2 + 0.8*abs(pulse), 0.5 + 0.5*sin(time + length(pos)*5.0));
    vec3 glitchTint = vec3(0.8, 0.9, 0.3);
    
    vec3 color = mix(baseColor, glitchTint, 0.3 * abs(sin(time * 5.0)));
    color *= mask;
    
    gl_FragColor = vec4(color, 1.0);
}