precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// Classic noise by interpolation
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

// Fractal Brownian Motion for textural complexity
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

// Organic swirling distortion
vec2 organicSwirl(vec2 p, float strength) {
    p -= 0.5;
    float r = length(p);
    float angle = atan(p.y, p.x) + strength * exp(-r * 3.0);
    vec2 rotated = vec2(cos(angle), sin(angle)) * r;
    return rotated + 0.5;
}

// Digital glitch distortion
vec2 digitalGlitch(vec2 p) {
    float glitch = noise(vec2(p.y * 20.0 + time, p.x * 20.0 - time));
    p.x += glitch * 0.05;
    p.y += noise(vec2(p.x * 30.0, time * 2.0)) * 0.05;
    return p;
}

// Organic growth pattern resembling branches or veins
float organicGrowth(vec2 p) {
    p = p * 2.0 - 1.0;
    float r = length(p);
    float angle = atan(p.y, p.x);
    float wave = sin(10.0 * r - angle * 5.0 + time * 2.0);
    float branch = exp(-3.0 * r);
    return smoothstep(0.3, 0.5, abs(wave) * branch);
}

// Digital stripes for glitchy interference effects
float digitalStripes(vec2 p) {
    return smoothstep(0.48, 0.5, abs(sin(p.y * 80.0 + time * 12.0)));
}

void main(void) {
    // Base UV coordinates
    vec2 pos = uv;
    
    // Apply digital glitch to introduce synthetic distortion
    vec2 glitchUV = digitalGlitch(pos);
    
    // Apply organic swirl for lifelike distortion
    vec2 swirlUV = organicSwirl(pos, 2.5 * sin(time * 0.7));
    
    // Compute organic branch-like pattern using two approaches and blend them
    float organicA = organicGrowth(pos);
    float organicB = organicGrowth(swirlUV);
    float organicPattern = mix(organicA, organicB, 0.5);
    
    // Compute cosmic background texture using FBM noise
    float cosmic = fbm(uv * 6.0 + time * 0.3);
    
    // Compute digital artifacts such as glitch stripes
    float glitchLines = digitalStripes(glitchUV);
    
    // Color palette: organic warmth contrasted with digital cools
    vec3 backgroundColor = mix(vec3(0.05, 0.05, 0.1), vec3(0.02, 0.02, 0.1), uv.y);
    vec3 organicColor = mix(vec3(0.8, 0.6, 0.2), vec3(0.1, 0.5, 0.2), organicPattern);
    vec3 digitalColor = mix(vec3(0.0, 0.2, 0.4), vec3(0.1, 0.6, 0.7), cosmic);
    
    // Merge organic and digital domains
    float blendFactor = smoothstep(0.3, 0.7, sin(time) * 0.5 + 0.5);
    vec3 mergedColor = mix(organicColor, digitalColor, blendFactor);
    
    // Final mix with subtle glitch highlights
    vec3 color = mix(backgroundColor, mergedColor, 0.7);
    color = mix(color, vec3(1.0), glitchLines * 0.15);
    
    gl_FragColor = vec4(color, 1.0);
}