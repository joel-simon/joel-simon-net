precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
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
    for (int i = 0; i < 6; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 distort(vec2 p, float strength) {
    float n = fbm(p * 3.0 + time);
    float angle = n * 6.2831;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return p + rot * vec2(n, n) * strength;
}

vec3 glitchLayer(vec2 p) {
    // Introduce "error" as intended: a broken grid with shifting stripes.
    vec2 grid = fract(p * 10.0 + vec2(time * 0.3));
    float stripe = step(0.5, abs(grid.x - 0.5));
    float randomShift = step(0.9, hash(p * 5.0 + time));
    float glitch = mix(stripe, randomShift, 0.5);
    return vec3(glitch * 0.8, glitch * 0.3, glitch);
}

vec3 organicLayer(vec2 p) {
    // Natural organic swirling inspired by hidden error as beauty.
    vec2 center = p - 0.5;
    float r = length(center);
    float angle = atan(center.y, center.x);
    float pattern = sin(10.0 * r - time * 2.0 + angle);
    float mask = smoothstep(0.3, 0.5, r) * abs(pattern);
    return mix(vec3(0.1, 0.3, 0.2), vec3(0.7, 0.9, 0.4), mask);
}

vec3 digitalMist(vec2 p) {
    // Layer of digital mist from random noise.
    float n = fbm(p * 8.0 - time);
    float mist = smoothstep(0.4, 0.6, n);
    return vec3(mist * 0.2, mist * 0.4, mist * 0.8);
}

void main(void) {
    vec2 p = uv;

    // Cryptic directive: "Honor thy error as a hidden intention"
    // Distort the coordinates in a chaotic yet intentional way.
    p = distort(p, 0.04);

    // Create base layers: organic swirl and digital glitch grid.
    vec3 organic = organicLayer(p);
    vec3 glitch = glitchLayer(p);
    vec3 mist = digitalMist(uv);

    // Blend layers with a time influenced fbm mask.
    float blendMask = smoothstep(0.3, 0.7, fbm(uv * 5.0 + time));
    vec3 mixLayer = mix(organic, glitch, blendMask);

    // Overlay the mist for a subtle digital haze.
    vec3 finalColor = mix(mixLayer, mist, 0.3);

    gl_FragColor = vec4(finalColor, 1.0);
}