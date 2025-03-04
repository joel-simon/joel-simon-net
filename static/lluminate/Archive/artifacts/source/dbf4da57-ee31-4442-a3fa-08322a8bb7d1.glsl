precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(){
    // Center uv coordinates to [-1, 1] space.
    vec2 p = uv * 2.0 - 1.0;
    
    // Add a time-varying rotation to the coordinates.
    float angleOffset = time * 0.3;
    float cosA = cos(angleOffset);
    float sinA = sin(angleOffset);
    p = vec2(p.x * cosA - p.y * sinA, p.x * sinA + p.y * cosA);
    
    // Convert to polar space for radial and angular modulation.
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Introduce kaleidoscopic segmentation with a dynamic segment count.
    float segments = 5.0 + 3.0 * sin(time * 0.4);
    a = mod(a, 6.28318 / segments) - (3.14159 / segments);
    
    // Reconstruct from polar, add a controlled swirl distortion.
    p = vec2(cos(a), sin(a)) * r;
    float swirl = sin(r * 12.0 - time * 2.0);
    float s = sin(swirl);
    float c = cos(swirl);
    p = vec2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Layered fractal noise using iterative distortion.
    float fnoise = 0.0;
    vec2 pos = p * 1.5;
    for (int i = 0; i < 7; i++) {
        float n = noise(pos + time);
        fnoise += n / float(i+1);
        pos = abs(pos * 1.8) - 0.7;
    }
    
    // Create a dynamic grid-like pattern by mixing noise with radial modulation.
    float grid = sin(10.0 * p.x + time) * sin(10.0 * p.y + time);
    float mixVal = smoothstep(0.3, 0.7, fnoise + 0.3 * grid);
    
    // Construct an evolving palette.
    vec3 col = palette(fnoise + time * 0.1,
        vec3(0.1, 0.2, 0.3),
        vec3(0.4, 0.3, 0.2),
        vec3(1.0, 0.9, 0.7),
        vec3(0.2, 0.5, 0.6));
        
    // Mix with additional dynamic brightness variation based on grid pattern.
    col *= mixVal * (0.5 + 0.5 * sin(time + r * 8.0));
    
    // Apply a soft vignette.
    float vignette = smoothstep(0.8, 0.2, r);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}