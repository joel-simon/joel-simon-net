precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y*(1.0 - u.x) + (d - b)* u.x*u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

float digitalGlitch(vec2 p) {
    // Reverse the assumption of gradual organic growth:
    // Instead of smooth curves, we generate sharp, pixelated steps
    vec2 grid = floor(p * 20.0);
    float glitch = hash(grid.x + grid.y * 57.0 + time);
    // Create sudden jumps in intensity and dimension by a non-linear mapping:
    glitch = step(0.8, glitch);
    // Introduce breakup lines based on very high frequency noise
    float line = smoothstep(0.3, 0.32, abs(sin(p.y * 80.0 + time * 5.0)));
    return glitch * line;
}

void main() {
    // Invert common assumptions by making the center the glitch origin
    vec2 p = uv - 0.5;
    p.x *= 1.5;
    
    // Background: a digital canvas with warped color channels instead of a natural gradient.
    vec3 colorA = vec3(0.0, 0.2, 0.4);
    vec3 colorB = vec3(0.7, 0.1, 0.2);
    float mixFactor = 0.5 + 0.5*sin(time + length(p)*10.0);
    vec3 baseColor = mix(colorA, colorB, mixFactor);
    
    // Overlay a digital glitch
    float glitch = digitalGlitch(p + fbm(p * 3.0 + time));
    
    // Instead of organic growth patterns, enforce abrupt momentary artifacts
    vec3 glitchColor = vec3(1.0, 0.8, 0.0) * glitch;
    
    // Merge the glitch with the base color in a way that disrupts the digital canvas.
    vec3 finalColor = mix(baseColor, glitchColor, glitch);
    
    gl_FragColor = vec4(finalColor, 1.0);
}