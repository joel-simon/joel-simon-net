precision mediump float;
varying vec2 uv;
uniform float time;

//
// Hash and noise functions
//
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

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

//
// Fractal Brownian Motion (FBM) for organic complexity
//
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

//
// Organic growth pattern: swirling, growing fractal
//
float organicGrowth(vec2 p) {
    vec2 center = vec2(0.5);
    vec2 delta = p - center;
    float angle = atan(delta.y, delta.x);
    float dist = length(delta);
    float swirl = sin(angle*3.0 + time + fbm(p*5.0)*6.28);
    return smoothstep(0.4, 0.45, abs(dist - (0.2 + 0.1*swirl)));
}

//
// Digital distortion: glitch lines and pixel scrambling
//
vec2 digitalDistort(vec2 p) {
    float glitch = noise(vec2(p.y * 30.0, time * 2.0));
    p.x += glitch * 0.03;
    p.y += noise(vec2(p.x * 20.0, time)) * 0.03;
    return p;
}

float digitalStripes(vec2 p) {
    return smoothstep(0.48, 0.5, abs(sin(p.y * 80.0 + time * 15.0)));
}

//
// Main blending function: merging organic with digital glitch
//
void main(void) {
    // Apply digital distortion to one copy of the coordinate
    vec2 digitalUV = digitalDistort(uv);
    
    // Organic domain: fractal-based swirling growth
    float organic = organicGrowth(uv);
    organic += 0.3 * fbm(uv * 10.0 + time);
    
    // Digital domain: sharp glitchy stripes with FBM modulation
    float digital = digitalStripes(digitalUV);
    digital += 0.2 * fbm(digitalUV * 50.0 - time);
    
    // Map cross space: blend using a time-influenced weight
    float blendWeight = smoothstep(0.3, 0.7, sin(time) * 0.5 + 0.5);
    float emergent = mix(organic, digital, blendWeight);
    
    // Color mapping: organic yellowish growth contrasted with digital blue-green
    vec3 organicColor = vec3(0.9, 0.7, 0.3);
    vec3 digitalColor = vec3(0.1, 0.6, 0.7);
    vec3 background = vec3(0.05, 0.05, 0.1);
    
    vec3 color = background;
    color = mix(color, organicColor, organic);
    color = mix(color, digitalColor, digital);
    
    gl_FragColor = vec4(color, 1.0);
}