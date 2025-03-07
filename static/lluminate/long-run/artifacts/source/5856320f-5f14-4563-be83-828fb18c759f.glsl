precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(13.98, 27.34))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Reverse assumption: instead of smooth continuous evolution, we simulate sudden digital collapse.
vec2 digitalShift(vec2 p, float t) {
    float shift = step(0.97, fract(sin(dot(p, vec2(21.17, 31.13)) + t*15.0))) * 0.15;
    return p + vec2(shift, shift);
}

void main(){
    // Transform uv such that (0,0) is center and preserve aspect
    vec2 st = uv * 2.0 - 1.0;
    
    // Instead of organic continuous growth, we make abrupt, pixelated areas
    vec2 cell = floor((st + 1.0) * 8.0) / 8.0;
    
    // Use fbm with digitalShift to simulate sudden decay zones in a digital world
    vec2 shifted = digitalShift(cell, time);
    float pattern = fbm(shifted * 4.0 + time * 0.7);
    
    // Create an inversion effect to challenge smooth contrasts
    float inverted = 1.0 - smoothstep(0.3, 0.6, pattern);
    
    // Add a harsh glitch line effect across the scene
    float glitchLine = step(0.92, abs(sin((st.x + time*1.5)*25.0)));
    
    // Mix two color palettes: one for the digital decay, another for residual brightness
    vec3 decayColor = vec3(0.05, 0.15, 0.25);
    vec3 brightColor = vec3(0.85, 0.65, 0.4);
    vec3 col = mix(decayColor, brightColor, inverted);
    
    // Overlay glitch line to punctuate sudden collapse
    col = mix(col, vec3(0.0), glitchLine);
    
    // Apply a vignette effect to focus viewer's attention
    float vignette = smoothstep(1.2, 0.0, length(st));
    gl_FragColor = vec4(col * vignette, 1.0);
}