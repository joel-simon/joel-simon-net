precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on sine
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
    // Map uv from [0,1] to [-1,1] for center based computations.
    vec2 pos = uv * 2.0 - 1.0;
    
    // Convert Cartesian coordinates to polar coordinates.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a cosmic starburst component.
    float starburst = abs(cos(8.0 * angle + time * 1.5));
    float starShape = smoothstep(0.45, 0.40, radius) * starburst;
    
    // Create glitch interference: introduce stripes and distortions.
    float glitch = smoothstep(0.2, 0.18, abs(sin(pos.y * 10.0 + time * 5.0))) * 0.4;
    
    // Swirling waves component: use sine modulation and polar angle.
    float wave = sin(radius * 20.0 - time * 3.0 + angle * 3.0);
    float waveMask = smoothstep(0.0, 0.02, abs(wave));
    
    // Noise-based background for organic pulsation.
    float n = noise(pos * 3.0 + time);
    float pulsation = smoothstep(0.2, 0.3, n);
    
    // Dynamic color blending:
    // Cosmic core color with warm tones
    vec3 cosmicCore = mix(vec3(0.9, 0.7, 0.3), vec3(1.0, 0.8, 0.5), pulsation);
    // Glitch overlay with cooler blue edge
    vec3 glitchColor = mix(cosmicCore, vec3(0.2, 0.4, 0.8), glitch);
    // Add swirling dynamism with vibrant contrast
    vec3 waveColor = mix(glitchColor, vec3(1.0, 0.3, 0.1), waveMask);
    
    // Experiment: overlay starburst to emphasize radiant pulsation
    vec3 finalColor = mix(waveColor, vec3(1.0, 1.0, 0.8), starShape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}