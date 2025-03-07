precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for randomness
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
    return mix(mix(a,b,u.x), mix(c,d,u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float total = 0.0;
    float amp = 0.5;
    for (int j = 0; j < 6; j++) {
        total += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

// Swirl transformation based on polar coordinates
vec2 polarSwirl(vec2 p, float factor) {
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += factor * exp(-r*2.0);
    return vec2(r * cos(theta), r * sin(theta));
}

// Glitch displacement using discrete stepping in the y coordinate
vec2 glitchDisplace(vec2 p) {
    float g = step(0.5, fract(p.y * 10.0 + time));
    p.x += (g - 0.5) * 0.1;
    return p;
}

void main(void) {
    // Map uv to [-1, 1] domain
    vec2 pos = uv * 2.0 - 1.0;
    
    // First conceptual space: organic fractal noise space
    float organic = fbm(pos * 3.0 + time * 0.3);
    
    // Second conceptual space: a structured polar swirl with glitch artifacts
    vec2 glitchPos = glitchDisplace(pos * 2.0);
    glitchPos = polarSwirl(glitchPos, 3.0 + sin(time) * 1.5);
    float structured = smoothstep(0.2, 0.5, length(glitchPos));
    
    // Map cross-space: blend organic and structured based on distance and noise modulator
    float blendFactor = smoothstep(0.3, 0.7, organic) * (1.0 - structured);
    
    // Emergent pattern: combine a radial gradient with time modulated sine waves
    float radius = length(pos);
    float radial = cos(radius * 10.0 - time * 3.0);
    float emergent = mix(organic, radial, blendFactor);
    
    // Color modulation: mix two contrasting color schemes
    vec3 colorOrganic = vec3(0.2, 0.5, 0.8) * organic;
    vec3 colorGlitch = vec3(0.9, 0.4, 0.6) * structured;
    
    // Final blend yields emergent properties not present in either conceptual space alone
    vec3 finalColor = mix(colorOrganic, colorGlitch, emergent);
    
    gl_FragColor = vec4(finalColor, 1.0);
}