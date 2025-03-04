precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.141592653589793;
const int ITER = 10;

// Hash function for pseudo randomness.
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// 2D noise based on Hutchinson's method.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    // smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

// Kaleidoscopic reflection
vec2 kaleido(vec2 p, float n) {
    float angle = atan(p.y, p.x);
    float r = length(p);
    angle = mod(angle, PI/n) - PI/n*0.5;
    return vec2(cos(angle), sin(angle)) * r;
}

// Fractal space twist function
float fractalTwist(vec2 p) {
    float accum = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < ITER; i++) {
        float a = atan(p.y, p.x);
        float r = length(p);
        p = kaleido(p, 6.0) * 1.4 + vec2(sin(time * 0.3), cos(time * 0.2));
        accum += sin(p.x * 3.0 + time * 0.8) * cos(p.y * 3.0 - time * 0.6) * amplitude;
        amplitude *= 0.7;
        p *= 1.2;
    }
    return accum;
}

void main(){
    // Map uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
  
    // Apply radial warp
    float r = length(pos);
    float warp = 0.8 / (r + 0.4);
    pos *= warp;
    
    // Time-varying rotation
    float angle = time * 0.75 + r * 2.0;
    float ca = cos(angle);
    float sa = sin(angle);
    pos = vec2(pos.x * ca - pos.y * sa, pos.x * sa + pos.y * ca);
    
    // Add a subtle animated noise distortion
    vec2 noisePos = pos * 2.0 + vec2(time * 0.5);
    float n = noise(noisePos);
    pos += vec2(n * 0.2, n * 0.2);
    
    // Create a dynamic kaleidoscopic pattern
    vec2 kaleidoPos = kaleido(pos * 2.5, 8.0);
    float basePattern = sin(kaleidoPos.x * 3.0 + time) * cos(kaleidoPos.y * 3.0 - time);
    
    // Fractal twist component
    float fractalPattern = fractalTwist(pos * 1.8);
    
    // Combine patterns with sine modulation
    float patternMix = sin(basePattern + fractalPattern);
    patternMix = patternMix * 0.5 + 0.5;
    
    // Define a dynamic color palette
    vec3 colorA = vec3(0.2, 0.3, 0.7);
    vec3 colorB = vec3(0.9, 0.4, 0.3);
    vec3 colorC = vec3(0.3, 0.8, 0.5);
    vec3 mixedColor = mix(colorA, colorB, patternMix);
    mixedColor = mix(mixedColor, colorC, smoothstep(0.2, 0.8, r));
    
    // Add a vignette effect
    float vig = smoothstep(0.8, 0.3, r);
    mixedColor *= vig;
    
    gl_FragColor = vec4(mixedColor, 1.0);
}