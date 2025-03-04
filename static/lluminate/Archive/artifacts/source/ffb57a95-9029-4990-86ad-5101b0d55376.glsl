precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(){
    vec2 p = uv * 2.0 - 1.0;
    
    // Rotate coordinates with time for dynamic twisting effect
    float angle = time * 0.3;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle), cos(angle));
    p = rot * p;
    
    // Create polar coordinates
    float r = length(p);
    float theta = atan(p.y,p.x);
    
    // Apply multiple layers of swirling distortion using noise and polar warping
    float layers = 5.0;
    float intensity = 0.0;
    vec2 q = p;
    for (float i = 1.0; i <= layers; i++){
        float scale = i * 1.5;
        float n = noise(q * scale - time * 0.5);
        intensity += sin(theta * scale + n * 6.28318 + time) / i;
        // Distort coordinates recursively
        q = p + vec2(sin(q.y * 3.0 + time * 0.8), cos(q.x * 3.0 - time * 0.8)) * 0.2;
    }
    
    // Create radial distortions and kaleidoscopic mirror effect
    float segments = 8.0;
    float k = mod(theta * segments, 6.28318 / segments);
    float mask = smoothstep(0.0, 0.15, abs(k - (3.14159/segments)));
    
    // Combine radial and swirling effects
    float composite = smoothstep(0.4, 0.0, r) + intensity * mask;
    
    // Evolving palette over time with fractal modulation
    vec3 color = palette(composite + time * 0.2, 
                         vec3(0.5), 
                         vec3(0.5), 
                         vec3(1.0, 0.7, 0.3), 
                         vec3(0.2, 0.3, 0.4));
    
    // Add an outer vignette for a polished look
    color *= smoothstep(1.2, 0.3, r);
    
    gl_FragColor = vec4(color, 1.0);
}