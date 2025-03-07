precision mediump float;
varying vec2 uv;
uniform float time;

// 2D hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Smooth noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Swirl effect function for dynamic distortion
vec2 swirl(vec2 p, float strength) {
    float angle = strength * length(p);
    float s = sin(angle);
    float c = cos(angle);
    mat2 m = mat2(c, -s, s, c);
    return m * p;
}

// Heart shape signed distance function
float heartShape(vec2 p) {
    p.y -= 0.25;
    float a = atan(p.x, p.y);
    float r = length(p);
    float h = abs(p.x) - 0.5 * r;
    // Modify heart curve using a sinusoidal modulation influenced by time
    float heart = pow(r, 2.0) - 0.5 * sin(time + a*4.0);
    return h;
}

void main() {
    // Center and scale coordinates to [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;

    // Apply swirl distortion to simulate organic flow
    float strength = sin(time * 0.5) * 1.0;
    vec2 distortedPos = swirl(pos, strength);

    // Create a dynamic organic background with fbm noise
    float background = fbm(distortedPos * 2.5 + time * 0.3);
    
    // Create a heart shape influenced by noise, symbolizing love
    float heart = heartShape(distortedPos * 1.2);
    float heartMask = smoothstep(0.03, 0.0, abs(heart));
    
    // Emphasize the heart with a pulsating effect based on time
    float pulse = 0.5 + 0.5 * sin(time * 2.0);
    vec3 heartColor = vec3(1.0, 0.2, 0.4) * pulse;
    
    // Combine background and heart shape
    vec3 baseColor = mix(vec3(0.05, 0.02, 0.1) + background * 0.3, heartColor, heartMask);
    
    // Add subtle digital glitch artifacts using high frequency noise
    float glitch = step(0.98, noise(uv * time * 15.0)) * 0.2;
    baseColor += glitch;
    
    // Dark vignette effect
    float vignette = smoothstep(1.2, 0.3, length(pos));
    baseColor *= vignette;
    
    gl_FragColor = vec4(baseColor, 1.0);
}