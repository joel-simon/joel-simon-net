precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random noise function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// 2D noise based on hashing
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    // Smooth interpolation of the noise
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + 
           (c - a)* u.y * (1.0 - u.x) + 
           (d - b) * u.x * u.y;
}

// Domain warping to blend oceanic ripple with cyber glitch patterns.
vec2 warp(vec2 p, float t) {
    float n = noise(p * 3.0 + vec2(t, t));
    float angle = n * 6.2831;
    vec2 offset = vec2(cos(angle), sin(angle)) * 0.1;
    return p + offset;
}

void main(void) {
    // Map uv to range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // First domain: deep ocean waves using sinusoidal functions
    float wave = sin(pos.x * 10.0 + time * 3.0) * cos(pos.y * 10.0 + time * 2.0);
    float oceanic = smoothstep(0.0, 0.05, abs(wave - pos.y));
    
    // Second domain: cyber glitch, use noise and domain warping
    vec2 warpedUV = warp(uv, time * 0.5);
    float glitch = noise(warpedUV * 20.0 + time);
    glitch = smoothstep(0.4, 0.6, glitch);
    
    // Combine by transferring digital glitch elements over natural ocean wave
    float mask = mix(oceanic, glitch, 0.5 + 0.5 * sin(time));
    
    // Create a colorful gradient: deep blue for ocean, neon magenta for cyber elements
    vec3 oceanColor = vec3(0.0, 0.2, 0.5);
    vec3 cyberColor = vec3(0.8, 0.1, 0.7);
    // Use radial gradient from center for extra depth
    float dist = length(pos);
    vec3 gradient = mix(oceanColor, cyberColor, smoothstep(0.0, 1.0, dist));
    
    // Further modulate color with a pulsating digital interference
    float pulse = 0.5 + 0.5 * sin(time * 5.0 + dist * 20.0);
    
    // Final combination to synthesize both domains cohesively 
    vec3 color = gradient * mask * pulse;
    
    // Apply an edge vignette for depth
    float vignette = smoothstep(0.8, 0.2, dist);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}