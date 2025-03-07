precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on uv coordinates
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Simple 2D noise
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Convert Cartesian to polar coordinates
vec2 toPolar(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    return vec2(r, a);
}

// Convert polar to Cartesian coordinates
vec2 toCartesian(vec2 polar) {
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

// Swirl distortion function for an organic twisting effect
vec2 swirl(vec2 p, float strength) {
    vec2 polar = toPolar(p);
    polar.y += strength / (polar.x + 0.5);
    return toCartesian(polar);
}

// Glitch effect: distort x coordinate based on noise function
vec2 glitch(vec2 p, float seed) {
    float offset = sin(p.y * 50.0 + seed) * 0.005 + noise(p * 20.0 + seed) * 0.01;
    p.x += offset;
    return p;
}

// Organic pattern combining fbm and smoothstep for cell-like structures
vec3 organicPattern(vec2 pos, float t) {
    float n = fbm(pos * 3.0 + t * 0.3);
    float radius = length(pos);
    float cell = smoothstep(0.4, 0.38, abs(n - radius));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

// Digital radar-like scan lines
vec3 digitalRadar(vec2 pos, float t) {
    vec2 grid = fract(pos * 30.0 + t);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float burst = step(0.95, random(pos * 1.3 + t)) * 0.3;
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + burst;
}

void main(){
    // Center UV coordinates to [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply an organic swirl distortion that oscillates with time
    float swirlStrength = sin(time * 0.8) * 0.5;
    vec2 distortedPos = swirl(pos, swirlStrength);
    
    // Apply a mild rotational and glitch disturbance for digital effect
    float angle = fbm(distortedPos * 3.0 + time) * 6.2831 * 0.2;
    float ca = cos(angle);
    float sa = sin(angle);
    vec2 rotatedPos = vec2(distortedPos.x * ca - distortedPos.y * sa,
                           distortedPos.x * sa + distortedPos.y * ca);
    vec2 glitchedPos = glitch(rotatedPos + 0.5, time);
    
    // Generate organic texture from swirling noise and fbm
    vec3 organic = organicPattern(pos, time);
    
    // Generate digital radar scans using glitched coordinates
    vec3 radar = digitalRadar(glitchedPos, time);
    
    // Mix organic and digital elements based on distance from the center
    float mixFactor = smoothstep(0.6, 0.2, length(pos));
    vec3 colorMix = mix(organic, radar, mixFactor);
    
    // Add subtle random bursts to emphasize digital artifacts
    float burst = step(0.98, random(glitchedPos * (time * 2.0))) * 0.25;
    vec3 finalColor = colorMix + burst;
    
    // Apply vignette effect to darken edges
    float vignette = smoothstep(1.0, 0.2, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}