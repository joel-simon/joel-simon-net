precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)*u.x*u.y;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318*(c*t + d));
}

void main(void) {
    vec2 p = uv * 2.0 - 1.0;
    float r = length(p);
    
    // Rotate coordinates over time
    float angle = time * 0.25;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rp = vec2(p.x*c - p.y*s, p.x*s + p.y*c);
    
    // Create layered dynamic noise
    vec2 pos = rp * 2.0;
    float n = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 5; i++) {
        n += noise(pos * scale + time * 0.5) / scale;
        scale *= 2.0;
    }
    
    // Combine swirling patterns with radial distortion
    float twist = sin(5.0 * atan(rp.y, rp.x) + time + n * 3.0);
    float intensity = smoothstep(1.0, 0.2, r + 0.5 * twist);
    
    // Generate dynamic color palette
    vec3 col = palette(n + twist, vec3(0.5), vec3(0.5), vec3(1.0,0.75,0.5), vec3(0.0,0.33,0.67));
    col *= intensity;
    
    // Final vignette effect applied
    col *= smoothstep(1.2, 0.3, r);
    
    gl_FragColor = vec4(col, 1.0);
}