precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec3 organicAurora(vec2 p) {
    // Create a flowing aurora effect with fractal noise and swirling distortions.
    vec2 pos = p * 3.0 - vec2(1.5);
    pos = rotate(pos, time * 0.3);
    
    float n = fbm(pos + time * 0.5);
    float intensity = smoothstep(0.3, 0.7, n);
    
    // Emulate organic color gradients shifting over time.
    vec3 col = vec3(0.5 + 0.5 * sin(time + n * 6.2831),
                    0.5 + 0.5 * sin(time + n * 6.2831 + 2.094),
                    0.5 + 0.5 * sin(time + n * 6.2831 + 4.188));
                    
    return col * intensity;
}

vec3 digitalGlitch(vec2 p) {
    // Introduce a surprising glitch effect with grid distortions and sine modulations.
    vec2 grid = floor(p * 20.0) / 20.0;
    float glitchNoise = fbm(grid * 15.0 + time * 2.0);
    float glitch = step(0.8, glitchNoise);
    vec3 glitchColor = vec3(glitch * 0.4, glitch * 0.1, glitch * 0.6);
    return glitchColor;
}

vec3 mergeLayers(vec2 p) {
    // Use medium-distance associations between organic aurora and digital glitch
    vec3 aurora = organicAurora(p);
    vec3 glitch = digitalGlitch(uv);
    
    // Introduce a swirling distortion mixing the two layers based on time and radial distance.
    float r = length(p - 0.5);
    float swirl = sin(6.2831 * r - time * 2.0) * 0.5 + 0.5;
    return mix(aurora, glitch, swirl * 0.35);
}

void main(void) {
    vec2 pos = uv;
    
    // Apply a flexible distortion to the UVs, shifting the apparent center.
    vec2 offset = vec2(sin(time * 0.5), cos(time * 0.5)) * 0.1;
    pos = uv + offset;
    
    vec3 color = mergeLayers(pos);
    
    gl_FragColor = vec4(color, 1.0);
}