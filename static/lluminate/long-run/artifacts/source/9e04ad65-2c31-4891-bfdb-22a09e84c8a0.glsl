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
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 errorTwist(vec2 pos, float strength) {
    // "Honor thy error as a hidden intention"
    float err = sin(pos.y * 10.0 + time * 5.0) * strength;
    pos.x += err * noise(pos * 3.0 + time);
    return pos;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce a creative "error twist"
    pos = errorTwist(pos, 0.2);
    
    // Distort with time-based oscillations
    pos += sin(pos.yx * 3.0 + time) * 0.1;
    
    // Use fbm for an underlying organic structure
    float n = fbm(pos * 2.5 - time * 0.3);
    
    // Create a crisp radial falloff
    float radial = smoothstep(1.0, 0.3, length(pos));
    
    // Mix colors with a shifting palette
    vec3 colA = vec3(0.1, 0.25, 0.5);
    vec3 colB = vec3(0.7, 0.2, 0.3);
    vec3 colC = vec3(0.9, 0.8, 0.1);
    vec3 colD = vec3(0.0, 0.1, 0.2);
    vec3 color = palette(n + sin(time * 0.5)*0.5, colA, colB, colC, colD);
    
    // Overlay glitch-like horizontal lines
    float glitch = step(0.98, fract(uv.y * 50.0 + time * 10.0)) * 0.5;
    color += glitch;
    
    // Blend with radial falloff and add dynamic contrast
    color = mix(color, vec3(0.0), radial);
    
    gl_FragColor = vec4(color, 1.0);
}