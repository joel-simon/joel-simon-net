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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec3 palette(float t) {
    return 0.5 + 0.5 * cos(6.28318 * (vec3(1.0, 0.5, 0.2) * t + vec3(0.0, 0.33, 0.67)));
}

void main(void) {
    vec2 p = uv * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Apply a swirling distortion based on fractal noise and time
    float swirl = fbm(p * 3.0 + time);
    a += swirl * 1.5;
    
    // Remap back to Cartesian coordinates with distortion
    vec2 warped = vec2(cos(a), sin(a)) * r;
    float pattern = fbm(warped * 4.0 - time);
    
    // Create a pulsating ring pattern with a time-dependent offset
    float ring = smoothstep(0.2, 0.0, abs(r - 0.5 - 0.3 * sin(time * 0.5)));
    
    // Combine the fractal pattern and the ring
    float mixVal = mix(pattern, ring, 0.5);
    
    // Generate a dynamic, evolving color palette
    vec3 color = palette(mixVal + time * 0.1);
    
    // Apply a vignette effect to focus towards the center
    float vignette = smoothstep(1.0, 0.5, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}