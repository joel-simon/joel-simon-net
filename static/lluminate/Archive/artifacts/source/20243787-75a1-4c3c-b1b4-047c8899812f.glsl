precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453123);
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d){
    return a + b * cos(6.28318 * (c * t + d));
}

void main(){
    // Transform uv to centered coordinates in range [-1, 1]
    vec2 p = uv * 2.0 - 1.0;
    
    // Add dynamic kaleidoscopic twist
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float segments = 6.0;
    angle = mod(angle, 6.28318 / segments) * segments - 3.14159;
    p = vec2(cos(angle), sin(angle)) * radius;
    
    // Apply time-dependent swirling distortion
    float swirl = sin(time + radius * 10.0) * 0.3;
    float s = sin(swirl), c = cos(swirl);
    p = vec2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Introduce fractal iterative pattern with dynamic noise
    float intensity = 0.0;
    vec2 pos = p;
    for (int i = 0; i < 7; i++){
        pos = abs(pos) / dot(pos, pos + 0.5) - 0.7;
        intensity += sin(dot(pos, vec2(1.3, -1.7)) + time) * 0.15;
    }
    
    // Mix polar coordinates, iterative intensity, and noise for final pattern
    float mixFactor = smoothstep(0.0, 1.0, radius + intensity + 0.2 * hash(p * time));
    
    // Evolving color palette based on angle and time
    vec3 col = palette(mixFactor + time * 0.05,
                       vec3(0.4, 0.2, 0.6),
                       vec3(0.6, 0.3, 0.2),
                       vec3(0.9, 0.4, 0.8),
                       vec3(0.2 * (angle/3.14159 + 1.0), 0.5, 0.5));
    
    // Apply vignette effect to focus visuals toward center
    col *= smoothstep(1.0, 0.3, radius);
    
    gl_FragColor = vec4(col, 1.0);
}