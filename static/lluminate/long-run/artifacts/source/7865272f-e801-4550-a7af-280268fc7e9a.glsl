precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash based on input vector
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y*(1.0 - u.x) + (d - b)* u.x*u.y;
}

// Fractal Brownian Motion function
float fbm(vec2 p) {
    float v = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        v += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return v;
}

// Rotate a 2D vector by given angle
vec2 rotate(vec2 p, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Generates a swirling fractal field that melds rhythmic chaos with gentle decay.
void main(void) {
    // Map uv to centered coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Anchor concept: organic chaos; Medium association: gentle fractal waves
    // Apply a subtle rotation that evolves over time to the position vector
    pos = rotate(pos, time * 0.3);
    
    // Create polar coordinates for swirling effects
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Use fbm to get a textured field that creates fractal wave patterns.
    float fractal = fbm(pos * 3.0 - time * 0.5);
    
    // Modulate swirling effect using sine waves with a fractal boost.
    float swirl = sin(angle * 5.0 + time + fractal * 6.0);
    
    // Combine the radial decay with swirling pattern.
    float pattern = smoothstep(0.8, 0.4, radius + 0.3 * swirl);
    
    // Create a dynamic color gradient influenced by the fractal and swirl.
    vec3 baseColor = vec3(0.2, 0.4, 0.7);
    vec3 accentColor = vec3(0.9, 0.6, 0.3);
    vec3 mixedColor = mix(baseColor, accentColor, fractal);
    
    // Introduce an offset glitch-like modulation using additional noise
    float glitch = noise(pos * 10.0 + time);
    mixedColor += vec3(glitch * 0.1, glitch * 0.05, glitch * 0.08);
    
    // Final composition blends the swirling pattern with the color gradient.
    vec3 finalColor = mix(vec3(0.0), mixedColor, pattern);
    
    gl_FragColor = vec4(finalColor, 1.0);
}