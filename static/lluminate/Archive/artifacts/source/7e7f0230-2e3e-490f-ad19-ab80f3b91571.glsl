precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318*(c*t+d));
}

void main(){
    vec2 p = uv * 2.0 - 1.0;
    
    // Rotate coordinates with a time-dependent twist
    float angle = atan(p.y, p.x) + time * 0.25;
    float radius = length(p);
    p = vec2(cos(angle), sin(angle)) * radius;
    
    // Apply a dynamic kaleidoscopic mirroring effect
    p = abs(p);
    
    // Initialize fractal accumulator
    float accum = 0.0;
    vec2 pos = p;
    
    // Fractal iteration with dynamic folding and twisting
    for (int i = 0; i < 7; i++){
        // Rotate and scale position
        float a = time*0.1 + float(i)*0.5;
        float s = sin(a), c = cos(a);
        pos = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
        pos = abs(pos) / 1.5 - 0.4;
        
        // Add fractal detail based on a noise-like hash
        accum += 1.0 / (length(pos) * 10.0 + 0.1);
    }
    
    accum = clamp(accum, 0.0, 1.0);
    
    // Create an oscillating base pattern using sin waves and polar coordinates
    float base = sin(10.0 * radius - time) * 0.5 + 0.5;
    
    // Combine fractal detail and base oscillation
    float mixValue = smoothstep(0.2, 0.7, accum + base);
    
    // Dynamic color palette blending with time-driven modulation
    vec3 col = palette(mixValue + sin(time*0.5), 
                       vec3(0.3, 0.2, 0.4), 
                       vec3(0.5, 0.6, 0.7), 
                       vec3(0.8, 0.7, 0.5), 
                       vec3(uv.x, uv.y, 0.3));
    
    // Apply soft vignette based on distance from center
    float vignette = smoothstep(1.0, 0.2, radius);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}