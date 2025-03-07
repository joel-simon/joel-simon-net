precision mediump float;
varying vec2 uv;
uniform float time;

//
// 2D random noise function
//
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

//
// Layered fractal noise function
//
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * rand(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

//
// Emergent digital glitch distortion function using sine modulated noise
//
vec2 glitch(vec2 p, float t) {
    float offset = sin(p.y * 10.0 + t * 3.0) * 0.05;
    p.x += offset;
    p.y += cos(p.x * 10.0 - t * 2.0) * 0.05;
    return p;
}

//
// Blend of organic and digital spaces
// Organic: smooth, curved fbm field
// Digital: crisp glitch distortions applied selectively
//
vec3 emergentScene(vec2 pos, float t) {
    // Map UV coordinates from [0,1] to [-1,1] for organic style
    vec2 p = pos * 2.0 - 1.0;
    
    // Organic component: radial gradient with fbm swirling
    float r = length(p);
    float angle = atan(p.y, p.x);
    float organic = fbm(p * 3.0 + t);
    float radial = smoothstep(1.0, 0.0, r);
    float organicBlend = organic * radial;
    
    // Digital component: apply glitch distortion selectively in a band
    vec2 glitchCoord = glitch(pos, t);
    float digital = fbm(glitchCoord * 20.0 - t * 2.0);
    float band = smoothstep(0.45, 0.5, abs(pos.y - 0.5));
    
    // Blend the two conceptual spaces
    float blendFactor = mix(organicBlend, digital, band);
    
    // Color mapping: organic with warm hues, digital with cool neon tones
    vec3 organicColor = vec3(0.8, 0.5, 0.3) * organicBlend;
    vec3 digitalColor = vec3(0.2, 0.8, 0.9) * digital;
    
    // Emergent structure: selective projection of both inputs
    vec3 color = mix(organicColor, digitalColor, band);
    
    // Enhance with subtle vignette for depth
    color *= smoothstep(1.2, 0.5, r);
    
    return color;
}

void main() {
    vec2 pos = uv;
    vec3 color = emergentScene(pos, time);
    gl_FragColor = vec4(color, 1.0);
}