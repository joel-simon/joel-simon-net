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
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 p, float strength) {
    float angle = strength * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c) * p;
}

float heartShape(vec2 p) {
    p.y -= 0.2;
    p.x *= 1.2;
    float a = atan(p.x, p.y);
    float r = length(p);
    // Create a heart-like distance field with a sinusoidal modulation
    return pow(r, 2.0) - 0.5 * sin(4.0 * a + time);
}

vec2 glitchOffset(vec2 p, float strength) {
    float offset = noise(p * 10.0 + time) * strength;
    return p + vec2(offset, -offset);
}

void main(){
    // Transform uv to center coordinates in [-1,1]
    vec2 pos = uv * 2.0 - 1.0;

    // Anchor concept: organic growth
    float baseFBM = fbm(pos * 2.5 + time * 0.3);
    
    // Medium association: swirling distortion to mimic organic fluidity
    vec2 swirled = swirl(pos, 1.0 + 0.5 * sin(time));
    
    // Medium association: heart shape, symbolizing emotion
    float heart = heartShape(swirled * 1.5);
    float heartMask = smoothstep(0.01, 0.0, abs(heart));
    
    // Far association: digital glitch effects using noise and pixel displacement
    vec2 glitchPos = glitchOffset(uv, 0.05);
    float glitch = smoothstep(0.8, 1.0, noise(glitchPos * 20.0 + time));
    
    // Combine organic texture with heart and digitized glitch
    vec3 organicColor = mix(vec3(0.1, 0.2, 0.4) + baseFBM * 0.5, vec3(1.0, 0.2, 0.4), heartMask);
    organicColor += glitch * vec3(0.2, 0.1, 0.3);
    
    // Apply vignette effect for depth
    float vignette = smoothstep(1.0, 0.2, length(pos));
    vec3 finalColor = organicColor * vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}