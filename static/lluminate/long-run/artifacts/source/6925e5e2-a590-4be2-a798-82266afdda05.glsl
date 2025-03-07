precision mediump float;
varying vec2 uv;
uniform float time;

//
// Hash function for noise generation
//
float hash(float n) {
    return fract(sin(n)*43758.5453123);
}

//
// 2D noise function using smooth interpolation
//
float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

//
// Fractal Brownian Motion (FBM)
//
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++){
        f += amp*noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

//
// Organic branch pattern using polar coordinates and sinusoidal modulation
//
float organicBranch(vec2 p, float t) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    float branches = sin(6.0 * angle + t) * exp(-2.0 * r);
    return branches;
}

//
// Glitch effect by offsetting the UV coordinates based on fbm noise and time
//
vec2 glitchUV(vec2 p) {
    float n = fbm(p * 8.0 + time * 0.5);
    p.x += smoothstep(0.3, 0.7, n) * 0.1 * sin(time * 10.0);
    p.y += smoothstep(0.3, 0.7, n) * 0.1 * cos(time * 10.0);
    return p;
}

//
// Digital glitch stripes: abrupt discontinuities based on UV slicing
//
float digitalGlitch(vec2 p) {
    float t = time * 2.0;
    float stripe = step(0.98, fract(p.x * 10.0 + t)) * step(0.98, fract(p.y * 10.0 - t));
    return stripe;
}

//
// Main shader combining organic growth with digital glitch effects
//
void main() {
    // Apply glitch offset
    vec2 pos = glitchUV(uv);
    
    // Center the coordinates for more natural radial effects
    vec2 centered = (pos - 0.5) * 2.0;
    
    // Generate the organic branch pattern based on polar transformation
    float branch = organicBranch(centered, time);
    
    // Generate fractal texture to add organic complexity
    float textureFBM = fbm(centered * 2.0 + time);
    
    // Digital glitch element with abrupt, random banding
    float glitch = digitalGlitch(uv + vec2(fbm(uv*10.0), fbm(uv*10.0)));
    
    // Combine organic and digital components with a pulsating factor
    float pattern = smoothstep(0.2, 0.3, abs(branch)) + textureFBM * 0.3;
    pattern = mix(pattern, glitch, 0.5);
    
    // Create a dynamic, evolving color gradient using polar angle
    float angle = atan(centered.y, centered.x);
    vec3 colorA = vec3(0.1, 0.3, 0.5);
    vec3 colorB = vec3(0.8, 0.5, 0.2);
    vec3 grad = mix(colorA, colorB, (sin(angle + time) + 1.0) * 0.5);
    
    // Further enhance with a radial pulsation effect
    float radial = length(centered);
    float pulse = smoothstep(0.4, 0.42, radial + 0.1 * sin(time * 4.0));
    
    // Combine color gradient with pattern and pulsating effect
    vec3 finalColor = mix(grad, vec3(1.0, 0.9, 0.7), pattern) * pulse;
    
    gl_FragColor = vec4(finalColor, 1.0);
}