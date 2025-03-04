precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.141592653589793;
const int ITER = 8;

float kaleido(vec2 p) {
    // Reflect about multiple axes to create kaleidoscopic effect.
    float angle = atan(p.y, p.x);
    float sector = PI / 4.0;
    angle = mod(angle, sector) - sector * 0.5;
    float r = length(p);
    return cos(angle * 8.0 + time * 1.5) * sin(r * 12.0 - time * 2.0);
}

float fractalTwist(vec2 p) {
    float accum = 0.0;
    float scale = 1.0;
    for (int i = 0; i < ITER; i++) {
        float a = atan(p.y, p.x);
        float r = length(p);
        // Use time and scale to twist the coordinate space.
        p = vec2(cos(time * 0.5 + a * scale) * r, sin(time * 0.5 - a * scale) * r) + vec2(0.3);
        accum += sin(p.x * 3.0 + time) * cos(p.y * 3.0 - time);
        scale *= 1.3;
        p *= 1.2;
    }
    return accum;
}

void main(){
    // Shift and scale uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a hyperbolic distortion based on radial distance.
    float r = length(pos);
    float distortion = 0.5 / (r + 0.4);
    pos *= distortion;
    
    // Rotate coordinates in a dynamic fashion.
    float angle = time + r * 3.0;
    float ca = cos(angle);
    float sa = sin(angle);
    pos = vec2(pos.x * ca - pos.y * sa, pos.x * sa + pos.y * ca);
    
    // Generate a kaleidoscopic swirl pattern.
    float basePattern = kaleido(pos * 2.5);
    
    // Layer with a fractal twist for added complexity.
    float fractalPattern = fractalTwist(pos * 1.8);
    
    // Combine patterns and normalize.
    float patternMix = sin(basePattern + fractalPattern);
    patternMix = patternMix * 0.5 + 0.5;
    
    // Color modulation based on the pattern and position.
    vec3 colorA = vec3(0.1, 0.2, 0.7);
    vec3 colorB = vec3(0.8, 0.2, 0.4);
    vec3 colorC = vec3(0.2, 0.9, 0.6);
    vec3 mixedColor = mix(colorA, colorB, patternMix);
    mixedColor = mix(mixedColor, colorC, smoothstep(0.3, 0.7, r));
    
    // Add a vignette effect.
    float vig = smoothstep(0.8, 0.4, r);
    mixedColor *= vig;
    
    gl_FragColor = vec4(mixedColor, 1.0);
}