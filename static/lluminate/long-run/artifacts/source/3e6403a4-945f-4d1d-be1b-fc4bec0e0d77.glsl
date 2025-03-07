precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 23.0))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0 - 2.0*f);
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

vec2 swirl(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * (p - 0.5) + 0.5;
}

vec3 organicLayer(vec2 p) {
    // Organic base: gentle fractal noise with flowing, swirly patterns.
    float n = fbm(p * 3.0 - time * 0.2);
    return vec3(n * 0.6, n * 0.4 + 0.2, 0.5 - n * 0.3);
}

vec3 digitalGlitch(vec2 p) {
    // Create digital glitch: quantize and jitter the coordinates.
    vec2 grid = floor(p * 20.0) / 20.0;
    float glitch = step(0.7, noise(grid * 5.0 + time * 2.0));
    return mix(vec3(0.0), vec3(1.0, 0.5, 0.2), glitch * 0.5);
}

vec3 cosmicPulse(vec2 p) {
    // Medium association: Like a cosmic heartbeat that is not centered.
    float d = distance(p, vec2(0.3 + 0.2 * sin(time), 0.7 + 0.2 * cos(time)));
    float pulse = sin(time * 5.0 - d * 15.0);
    pulse = smoothstep(-0.2, 0.2, pulse);
    return vec3(pulse * 0.7, pulse * 0.9, pulse);
}

void main(void) {
    vec2 pos = uv;

    // Apply swirl to create an organic distortion
    pos = swirl(pos, sin(time) * 1.0);

    // Compute the layers
    vec3 layerOrganic = organicLayer(pos);
    vec3 layerCosmic = cosmicPulse(uv);
    vec3 layerGlitch = digitalGlitch(uv);

    // Blend using time-evolving weighting functions
    float blendOrganic = smoothstep(0.3, 0.7, fbm(pos * 4.0 + time));
    float blendCosmic = smoothstep(0.2, 0.8, noise(uv * 10.0 - time));
    
    vec3 color = mix(layerOrganic, layerCosmic, blendCosmic);
    color = mix(color, layerGlitch, 0.3);

    gl_FragColor = vec4(color, 1.0);
}