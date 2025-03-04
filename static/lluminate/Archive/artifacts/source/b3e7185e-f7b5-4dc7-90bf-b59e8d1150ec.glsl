precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec3 palette(float t) {
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 0.9, 0.7);
    vec3 d = vec3(0.15, 0.20, 0.25);
    return a + b * cos(6.28318*(c*t+d));
}

void main(){
    // Center uv coordinates and add a dynamic offset with time
    vec2 p = uv * 2.0 - 1.0;
    p += 0.2 * vec2(cos(time*0.7), sin(time*1.3));
    
    // Apply a spiral distortion based on polar coordinates
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += sin(r * 12.0 - time * 2.0) * 0.5;
    
    // Convert back to cartesian coordinates after distortion
    vec2 sp = r * vec2(cos(theta), sin(theta));
    
    // Create layered noise modulated fractal pattern
    float intensity = 0.0;
    vec2 pos = sp;
    for (int i = 0; i < 6; i++){
        float n = noise(pos * 3.0 + time);
        intensity += (sin(n * 6.28318 + time) * 0.5 + 0.5) / float(i+1);
        pos = abs(pos)*1.8 - 0.9;
    }
    
    // Create a kaleidoscopic effect using modular repetition on the angle
    float kaleido = mod(theta * 5.0, 6.28318/5.0);
    float mask = smoothstep(0.0, 0.1, abs(kaleido - (3.14159/5.0)));
    
    // Mix the fractal intensity with noise induced kaleido mask
    float mixFactor = smoothstep(0.0, 1.0, r + intensity * 0.6) * mask;
    
    // Dynamic color palette evolving with time and fractal mix
    vec3 color = palette(mixFactor + time*0.1);
    
    // Apply a soft vignette effect
    color *= smoothstep(1.2, 0.4, r);
    
    gl_FragColor = vec4(color, 1.0);
}