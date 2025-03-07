precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 31.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 digitalShift(vec2 pos, float t) {
    float shift = hash(pos + t) * 0.1;
    pos.y += shift;
    return pos;
}

vec2 spiralDistort(vec2 pos, float t) {
    vec2 centered = pos - 0.5;
    float angle = length(centered) * 6.2831 + t;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(c * centered.x - s * centered.y, s * centered.x + c * centered.y);
    return rotated + 0.5;
}

vec3 organicFluid(vec2 pos) {
    float n = fbm(pos * 4.0 + time * 0.5);
    float intensity = smoothstep(0.3, 0.6, n);
    vec3 col = mix(vec3(0.0, 0.3, 0.2), vec3(0.7, 0.9, 0.5), n);
    return col * intensity;
}

vec3 digitalGlitch(vec2 pos) {
    vec2 shifted = digitalShift(pos, time);
    vec2 grid = fract(shifted * 20.0);
    float glitchLine = smoothstep(0.0, 0.03, abs(grid.y - 0.5));
    float staticNoise = step(0.85, hash(shifted * 10.0 + time));
    vec3 col = mix(vec3(0.1, 0.1, 0.2), vec3(0.6, 0.8, 1.0), glitchLine);
    return col + staticNoise * 0.3;
}

void main(void) {
    // Base coordinate transformation with spiral distortion (Reverse & Modify operations)
    vec2 posSpiral = spiralDistort(uv, time * 0.8);
    
    // Organic fluid background (Adapt & Combine operations)
    vec3 organic = organicFluid(uv);
    
    // Digital glitch overlay (Substitute & Reverse operations)
    vec3 glitch = digitalGlitch(posSpiral);
    
    // Blend organic and digital layers with dynamic mix factor (Combine)
    float blendFactor = smoothstep(0.3, 0.7, fbm(uv * 3.0 + time));
    vec3 finalColor = mix(organic, glitch, blendFactor);
    
    gl_FragColor = vec4(finalColor, 1.0);
}