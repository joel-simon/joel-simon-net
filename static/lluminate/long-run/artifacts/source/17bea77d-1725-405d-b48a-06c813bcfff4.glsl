precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
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

vec2 swirl(vec2 pos, float amt) {
    float len = length(pos);
    float angle = amt * len;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;

    // Apply glitch offset for digital distortion
    pos += glitchOffset(pos);

    // Add a swirl transformation for an organic vortex effect
    pos = swirl(pos, 3.0 + sin(time) * 2.0);

    // Compute polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Synthesize organic noise and digital interference via fbm
    float organic = fbm(pos * 3.0 + time * 0.5);
    float ripple = smoothstep(0.45, 0.5, radius) * abs(sin(10.0 * angle + time * 2.0));
    float bands = errorBand(pos);

    // Map two distinct domains: Organic growth and digital glitch
    vec3 organicColor = mix(vec3(0.1, 0.6, 0.3), vec3(0.9, 0.8, 0.4), organic);
    vec3 digitalColor = mix(vec3(0.2, 0.3, 0.8), vec3(0.9, 0.9, 0.9), noise(pos * 10.0 + time));
    
    // Synthesize final color by combining both domains
    vec3 baseColor = mix(organicColor, digitalColor, 0.5 + 0.5 * sin(time));
    baseColor = mix(baseColor, vec3(1.0, 0.5, 0.0), ripple);
    baseColor = mix(baseColor, vec3(0.8, 0.8, 0.8), bands * 0.5);
    
    // Use shape mask to blend the final effect
    float wingEffect = sin(angle * 4.0 + time * 2.0) * 0.3;
    float shape = smoothstep(0.5 + wingEffect, 0.47 + wingEffect, radius);
    vec3 finalColor = baseColor * shape;
    
    gl_FragColor = vec4(finalColor, 1.0);
}