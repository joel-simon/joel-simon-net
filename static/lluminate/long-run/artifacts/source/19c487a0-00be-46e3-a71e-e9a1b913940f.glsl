precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
}

// Basic random using sine dot product
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function using bilinear interpolation of random values
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractional Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Polar transformation of coordinates
vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

// Glitch effect to disturb x coordinate
vec2 glitch(vec2 pos, float seed) {
    float offset = sin(pos.y * 50.0 + seed) * 0.005 + noise(pos * 20.0 + seed) * 0.01;
    pos.x += offset;
    return pos;
}

void main(void) {
    // Center uv to [-0.5, 0.5]
    vec2 pos = uv - vec2(0.5);
    
    // Convert to polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create wing-like modulation (symbolic digital rebirth) 
    float wing = sin(angle * 4.0 + time * 2.0) * 0.3;
    
    // Apply a polar rotation that blends between cosmic and organic dynamics.
    float fbmAngle = fbm(pos * 2.0 + time) * 6.2831 * 0.2;
    pos = polarTransform(pos, fbmAngle);
    
    // Further glitch the position for digital disruption
    vec2 glitchedPos = glitch(pos, time);
    
    // Generate a cosmic field using fbm noise to simulate stars and nebulous gradients
    vec3 cosmic = vec3(0.05, 0.0, 0.1);
    float stars = fbm(glitchedPos * 3.0 + time * 0.2);
    stars = smoothstep(0.6, 1.0, stars);
    cosmic = mix(cosmic, vec3(0.4, 0.0, 0.7), stars);
    
    // Produce an organic texture representing natural growth
    float organicNoise = fbm(pos * 3.0 + time * 0.4);
    float edge = smoothstep(0.35 + wing, 0.38 + wing, abs(organicNoise - r));
    vec3 organic = mix(vec3(0.0, 0.3, 0.2), vec3(0.8, 0.7, 0.4), organicNoise) * edge;
    
    // Blend the two themes based on radial distance
    float blendFactor = smoothstep(0.3, 0.7, r);
    vec3 color = mix(organic, cosmic, blendFactor);
    
    // Add a digital error band effect to evoke glitches
    float band = sin(pos.y * 50.0 + time * 10.0);
    float error = smoothstep(0.02, 0.03, abs(band));
    color = mix(color, vec3(1.0, 0.9, 0.4), error);
    
    // Integrate a random burst for unexpected creative insight
    float burst = step(0.98, random(glitchedPos * (time * 2.0))) * 0.25;
    color += burst;
    
    gl_FragColor = vec4(color, 1.0);
}