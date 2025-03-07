precision mediump float;
varying vec2 uv;
uniform float time;

// Simple random number generator
float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D Noise function based on random numbers and smooth interpolation
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Convert to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a swirling vortex pattern for an "eye" effect.
    float vortex = sin(10.0 * radius - time * 2.5 + angle * 2.0);
    float pupil = smoothstep(0.28, 0.26, abs(radius - 0.4 - 0.05 * vortex));
    
    // Outer iris pattern with organic noise modulation.
    float irisLayer = smoothstep(0.55, 0.57, radius) - smoothstep(0.6, 0.62, radius);
    float irisNoise = noise(uv * 8.0 + time * 0.5);
    irisLayer *= irisNoise * 1.2;
    
    // Generate a radial pulsation pattern in the background.
    float pulse = smoothstep(0.3 + 0.1 * sin(time + radius * 20.0), 0.31 + 0.1 * sin(time + radius * 20.0), radius);
    
    // Digital glitch artifacts from noise in the grid overlay.
    float glitch = noise(vec2(uv.y * 10.0, time)) * 0.2;
    
    // Dynamic gradient that shifts with angle and time.
    vec3 warmColor = vec3(1.0, 0.4, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(angle + time) + 1.0) * 0.5);
    
    // Combine eye components: pupil is the center of creativity.
    vec3 eyeColor = mix(vec3(0.0), vec3(1.0, 0.8, 0.2), pupil);
    
    // Outer iris color with organic noise based modulation.
    vec3 irisColor = mix(vec3(0.2, 0.4, 0.8), vec3(0.8, 0.4, 0.2), irisNoise);
    
    // Merge eye and iris using smooth blending based on radius.
    vec3 combinedEye = mix(eyeColor, irisColor, smoothstep(0.35, 0.5, radius));
    
    // Overlay glitch and pulsation effects to merge digital and organic themes.
    vec3 dynamicBase = colorGradient * pulse + combinedEye;
    dynamicBase += glitch * vec3(0.1, 0.1, 0.1);
    
    // Radial glow to simulate a light pulse from the center.
    float glow = 1.0 - smoothstep(0.3, 0.35 + 0.1 * sin(time), length(uv - vec2(0.5)));
    dynamicBase += glow * vec3(1.0, 0.9, 0.5);
    
    gl_FragColor = vec4(dynamicBase, 1.0);
}