precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random function
float random (in vec2 st) { 
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D Noise based on random function
float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation
    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void main() {
    // Domain: Bioluminescent organism (organic patterns) 
    // Mixed with a Mechanical digital distortion (glitch grid)
    
    // Transform uv to polar coordinates
    vec2 p = uv - 0.5;
    float r = length(p);
    float theta = atan(p.y, p.x);
    
    // Map mechanical grid noise using polar coordinates
    float gridNoise = noise(vec2(10.0 * r, 10.0 * theta));
    
    // Create organic flame-like patterns via sine waves
    float organic = sin(10.0 * r - time*2.0 + gridNoise * 6.2831);
    
    // Mix in glitchy digital artifact: small shifting offsets
    float glitch = step(0.95, fract(sin(time * 6.0 + r * 20.0) * 43758.0));
    
    // Synthesize: combine organic sin wave and digital glitch grid
    float pattern = mix(organic, gridNoise, 0.5) + glitch * 0.25;
    
    // Color dynamics: synthesize a neon, bioluminescent look
    vec3 color = vec3(0.1, 0.7, 0.9) * (0.5 + 0.5 * sin(pattern + vec3(0.0, 2.0, 4.0)));
    
    // Vignette effect based on distance from center
    float vignette = smoothstep(0.8, 0.3, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}