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

// Fractional Brownian motion
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

// Glitch effect which offsets the x coordinate slightly
vec2 glitch(vec2 pos, float seed) {
    float offset = sin(pos.y * 50.0 + seed) * 0.005 + noise(pos * 20.0 + seed) * 0.01;
    pos.x += offset;
    return pos;
}

// Polar transform for rotation of coordinates
vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

// Error band pattern for digital glitches
float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

// Cosmic field with stars and nebulous gradient
vec3 cosmicField(vec2 pos, float t) {
    pos *= 3.0;
    float stars = fbm(pos + t * 0.2);
    stars = smoothstep(0.6, 1.0, stars);
    return mix(vec3(0.05, 0.0, 0.1), vec3(0.4, 0.0, 0.7), stars);
}

// Organic texture representing natural growth with glitch pulsation
vec3 organicTexture(vec2 pos, float t) {
    float n = fbm(pos * 3.0 + t * 0.4);
    float edge = smoothstep(0.35, 0.38, abs(n - length(pos)));
    return mix(vec3(0.0, 0.3, 0.2), vec3(0.8, 0.7, 0.4), n) * edge;
}

void main(void) {
    // Start with centered UV coordinates
    vec2 pos = uv - 0.5;
    
    // Apply a random polar rotation based on fbm noise (interpreting "Honor thy error as a hidden intention")
    float angle = fbm(pos * 2.0 + time) * 6.2831 * 0.2;
    pos = polarTransform(pos, angle);
    
    // Introduce a glitch that distorts the coordinates
    vec2 glitchedPos = glitch(pos + 0.5, time);
    
    // Generate cosmic patterns and organic textures
    vec3 cosmic = cosmicField(glitchedPos, time);
    vec3 organic = organicTexture(pos, time);
    
    // Additional subtle error bands add digital aesthetic
    float bands = errorBand(pos);
    
    // Blend the cosmic and organic domains based on radial distance
    float blendFactor = smoothstep(0.3, 0.7, length(pos));
    vec3 color = mix(organic, cosmic, blendFactor);
    
    // Integrate digital glitch color disruption using error bands
    color = mix(color, vec3(1.0, 0.9, 0.4), bands);
    
    // Introduce a random burst for creative disruption
    float burst = step(0.98, random(glitchedPos * (time * 2.0))) * 0.25;
    color += burst;
    
    gl_FragColor = vec4(color, 1.0);
}