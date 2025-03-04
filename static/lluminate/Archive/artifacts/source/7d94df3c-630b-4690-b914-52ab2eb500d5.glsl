precision mediump float;
varying vec2 uv;
uniform float time;

float hash(in vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
}

void main(){
    // Center and scale coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply a dynamic rotation based on time and distance from center
    float angle = time + length(p) * 3.0;
    float s = sin(angle), c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    p *= rot;
    
    // Create a swirling fractal-like iteration pattern
    vec2 q = p;
    float accum = 0.0;
    float scale = 1.0;
    for(int i = 0; i < 8; i++){
        q = abs(q) / dot(q, q + 0.5) - 0.5;
        accum += exp(-length(q) * scale);
        scale *= 1.5;
    }
    
    // Generate a noise-like effect based on small perturbation of coordinates
    float n = hash(p * 3.0 + time);
    
    // Mix two color palettes to produce vibrant hues
    vec3 color1 = vec3(0.2 + 0.3*sin(time + accum), 0.4 + 0.5*cos(time + accum), 0.7 + 0.3*sin(time*0.5));
    vec3 color2 = vec3(0.9*n, 0.4 + 0.3*n, 0.2 + 0.4*n);
    
    // Blend based on radial distance and fractal accumulation
    float blend = smoothstep(0.0, 1.0, length(p) + accum * 0.2);
    vec3 finalColor = mix(color1, color2, blend);
    
    gl_FragColor = vec4(finalColor, 1.0);
}