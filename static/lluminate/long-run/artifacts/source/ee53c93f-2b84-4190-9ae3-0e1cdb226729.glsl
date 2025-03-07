precision mediump float;
varying vec2 uv;
uniform float time;

// Modified pseudo-random hash using cosine for substitution
float hash(vec2 p) {
    return fract(cos(dot(p, vec2(17.0, 31.7))) * 43758.5453);
}

// Revised smooth noise function with cosine interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = 0.5 - cos(3.14159 * f) * 0.5;
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Reverse idea: transform to polar coordinates then apply noise distortion
vec2 polarDistort(vec2 p) {
    vec2 center = vec2(0.5, 0.5);
    vec2 offset = p - center;
    float r = length(offset);
    float theta = atan(offset.y, offset.x);
    // Combine operations: modify theta with noise and reverse the radial influence
    theta += (noise(vec2(r * 3.0, time * 0.5)) - 0.5) * 3.14159;
    r = 1.0 - r;
    // Reverse transformation: from polar back to cartesian
    return center + vec2(r * cos(theta), r * sin(theta));
}

// Create a swirling cosmic burst by combining noise and sine distortions
vec3 cosmicBurst(vec2 p) {
    // Use large scale noise for cosmic background
    float n = noise(p * 8.0 + time * 0.3);
    // Synthesize swirling dynamic shift
    float swirl = sin((p.x + p.y + time) * 10.0 + n * 6.2831);
    vec3 base = mix(vec3(0.1, 0.0, 0.2), vec3(0.0, 0.2, 0.5), n);
    // Magnify swirl effect with bright highlight
    vec3 burst = base + vec3(swirl * 0.3, swirl * 0.2, swirl * 0.4);
    return burst;
}

void main(void) {
    // Map uv coordinates through the polar distortion (Reverse operation applied)
    vec2 p = polarDistort(uv);
    
    // Combine base cosmic burst pattern with subtle noise (Combine operation applied)
    vec3 color = cosmicBurst(p);
    
    // Add dynamic glitch-like stripes using substitute operations
    float stripe = abs(sin((p.y + time * 2.5) * 20.0));
    color = mix(color, vec3(0.0, 0.0, 0.0), smoothstep(0.45, 0.5, stripe));
    
    gl_FragColor = vec4(color, 1.0);
}