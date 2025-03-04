precision mediump float;
varying vec2 uv;
uniform float time;

float hash( vec2 p ) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318*(c*t+d));
}

void main(){
    // Center uv coordinates around (0,0) and scale to [-1,1]
    vec2 p = uv * 2.0 - 1.0;
    
    // Create a swirl effect shifting center over time
    float angle = time * 0.5;
    float s = sin(angle), c = cos(angle);
    p = vec2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Polar coordinates: radius and angle
    float r = length(p);
    float theta = atan(p.y, p.x);
    
    // Create a fractal-like iterative pattern with twisting layers
    float intensity = 0.0;
    vec2 pos = p;
    for (int i = 0; i < 5; i++){
        pos = abs(pos*2.0) - 1.0;
        intensity += 0.5/float(i+1) * sin(time + length(pos)*10.0);
    }
    
    // Use both polar coordinate and iteration intensity to mix colors
    float mixFactor = smoothstep(0.0, 1.0, r + intensity * 0.4);
    
    // Dynamic color palette evolving with time and angle
    vec3 col = palette(mixFactor + time*0.1, vec3(0.5), vec3(0.5), vec3(1.0,0.8,0.6), vec3(theta/6.28318, 0.4, 0.7));
    
    // Apply a vignette effect to center the visual focus
    col *= smoothstep(1.0, 0.2, r);
    
    gl_FragColor = vec4(col, 1.0);
}