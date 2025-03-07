precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453);
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
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 swirlEffect(vec2 p, float strength) {
    float angle = strength * fbm(p * 5.0 + time);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec3 galaxyLayer(vec2 p) {
    vec2 center = p - 0.5;
    float r = length(center);
    float angle = atan(center.y, center.x);
    float spiral = sin(10.0 * r - angle + time);
    float intensity = smoothstep(0.5, 0.2, r) * abs(spiral);
    vec3 col = mix(vec3(0.0, 0.0, 0.1), vec3(0.6, 0.2, 0.8), intensity);
    return col;
}

vec3 coralLayer(vec2 p) {
    vec2 pos = p * 3.0;
    float coral = abs(sin(pos.x + time) * cos(pos.y + time));
    float detail = fbm(pos + time);
    float mask = smoothstep(0.4, 0.5, coral + detail);
    vec3 col = mix(vec3(0.0, 0.2, 0.1), vec3(0.9, 0.4, 0.2), mask);
    return col;
}

vec3 digitalRipple(vec2 p) {
    vec2 grid = fract(p * 20.0 + time);
    float line = smoothstep(0.0, 0.03, abs(grid.x - 0.5));
    float glitch = step(0.85, hash(p * 10.0 + vec2(time, time)));
    return mix(vec3(0.1, 0.1, 0.25), vec3(0.8, 0.9, 1.0), line + glitch * 0.3);
}

void main(void) {
    vec2 pos = uv;
    
    // Apply a swirl effect to mimic underwater currents meeting cosmic vortex dynamics
    pos = swirlEffect(pos - 0.5, 5.0) + 0.5;
    
    // Generate the cosmic galactic texture
    vec3 galaxy = galaxyLayer(pos);
    
    // Generate the vibrant coral texture with organic wave forms
    vec3 coral = coralLayer(pos);
    
    // Add digital ripple effects for an unexpected glitch quality
    vec3 ripple = digitalRipple(uv);
    
    // Synthesize by blending cosmic and coral domains with a mix influenced by time evolving noise
    float mixRatio = fbm(uv * 3.0 + time * 0.5);
    vec3 mixLayer = mix(galaxy, coral, mixRatio);
    
    // Overlay subtle digital glitches on the composite
    vec3 finalColor = mix(mixLayer, ripple, 0.2);
    
    gl_FragColor = vec4(finalColor, 1.0);
}