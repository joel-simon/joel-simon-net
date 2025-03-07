precision mediump float;
varying vec2 uv;
uniform float time;

// Simple 2D random function
float rand(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise based on random
float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
                  mix(rand(ip), rand(ip+vec2(1.0,0.0)), u.x),
                  mix(rand(ip+vec2(0.0,1.0)), rand(ip+vec2(1.0,1.0)), u.x),
                  u.y);
    return res;
}

// Fractal Brownian Motion for texture detail
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

// Apply a swirling transformation to coordinates
vec2 swirl(vec2 p, float strength) {
    vec2 centered = p - 0.5;
    float angle = strength * length(centered) * 8.0;
    float s = sin(angle);
    float c = cos(angle);
    centered = vec2(c * centered.x - s * centered.y, s * centered.x + c * centered.y);
    return centered + 0.5;
}

// A glitch effect using sine distortions and noise
vec2 glitch(vec2 p, float t) {
    float shift = sin(p.y * 50.0 + t * 20.0) * 0.005;
    return vec2(p.x + shift, p.y);
}

// A layered digital grid pattern with glitch bursts
vec3 digitalPattern(vec2 p, float t) {
    vec2 grid = fract(p * 15.0) - 0.5;
    float line = smoothstep(0.45, 0.5, abs(grid.x)) + smoothstep(0.45, 0.5, abs(grid.y));
    float burst = step(0.98, rand(p * t)) * 0.3;
    return mix(vec3(0.1, 0.2, 0.8), vec3(0.9, 0.3, 0.2), line * 0.7 + burst);
}

// Organic fluid color modulation using fbm and time oscillation
vec3 organicColor(vec2 p, float t) {
    float n = fbm(p * 3.0 + t);
    float glow = sin(t + length(p - 0.5)*12.0)*0.5 + 0.5;
    return vec3(0.2 + n * 0.8, 0.3 * glow, 0.6 + 0.4 * n);
}

// Combine digital and organic effects using a mask from fbm swirl.
vec3 combineEffects(vec2 p, float t) {
    // SCAMPER operations: Substitute "swirl" for rotation, Combine glitch and digital grid
    vec2 p_swirl = swirl(p, 0.3);
    vec2 p_glitch = glitch(p_swirl, t);

    // Digital component
    vec3 digital = digitalPattern(p_glitch + vec2(t * 0.05, t * 0.03), t);

    // Organic component
    vec3 organic = organicColor(p, t);

    // Mask using fbm swirl in polar coordinates
    float mask = smoothstep(0.3, 0.6, fbm((p - 0.5)*4.0 + t));

    return mix(digital, organic, mask);
}

void main() {
    vec2 pos = uv;
    
    // Apply extra noise warping for evolving dynamics
    pos += vec2(noise(uv * 10.0 + time), noise(uv * 10.0 - time))*0.005;
    
    // Reverse effect: invert y coordinate dynamically
    pos.y = mix(pos.y, 1.0 - pos.y, sin(time*0.5)*0.3);
    
    vec3 color = combineEffects(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}