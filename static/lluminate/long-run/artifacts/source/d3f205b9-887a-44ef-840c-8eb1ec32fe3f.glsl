precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i+vec2(0.0,0.0)), hash(i+vec2(1.0,0.0)), u.x),
               mix(hash(i+vec2(0.0,1.0)), hash(i+vec2(1.0,1.0)), u.x), u.y);
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

vec2 swirl(vec2 p, float strength) {
    float angle = strength * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float heartShape(vec2 p) {
    // transform coordinate to center and scale
    p = (p - 0.5) * 2.0;
    float a = atan(p.x, p.y) / 3.1416;
    float r = length(p);
    float h = abs(a);
    // heart equation approximation
    return smoothstep(0.5, 0.48, r + 0.3 * h);
}

float glitch(vec2 p, float t) {
    float g1 = step(0.5, fract(p.y * 20.0 + t));
    float g2 = noise(p * 10.0 + t) * 0.3;
    return mix(g1, g2, 0.5);
}

void main() {
    // Re-map uv from [0,1] to [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Organic swirling background (using fbm and swirl)
    vec2 pos = st;
    pos = swirl(pos, 3.0 * sin(time * 0.5));
    float n = fbm(pos * 1.5 + time * 0.3);
    vec3 bg = mix(vec3(0.05,0.1,0.15), vec3(0.1,0.05,0.2), n);
    
    // Digital glitch grid overlay
    vec2 glitchUV = uv;
    float angleRot = time * 0.4;
    float s = sin(angleRot);
    float c = cos(angleRot);
    mat2 rotation = mat2(c, -s, s, c);
    glitchUV = rotation * (glitchUV - 0.5) + 0.5;
    float grid = smoothstep(0.45, 0.47, min(abs(fract(glitchUV.x * 10.0)-0.5), abs(fract(glitchUV.y * 10.0)-0.5)));
    float glitchPattern = glitch(glitchUV, time);
    
    // Symbolic heart element
    float heart = heartShape(uv);
    vec3 heartColor = mix(vec3(0.1,0.0,0.0), vec3(1.0,0.2,0.3), heart);
    
    // Combine background with glitch and heart elements
    vec3 color = mix(bg, vec3(0.3,0.8,0.9)*glitchPattern, 0.4);
    color = mix(color, heartColor, 0.5 * heart);
    
    gl_FragColor = vec4(color, 1.0);
}