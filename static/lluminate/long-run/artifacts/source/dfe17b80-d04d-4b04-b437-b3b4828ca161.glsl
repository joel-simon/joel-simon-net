precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

void main(void) {
    // Map uv to centered coordinates range [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Convert to polar
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Conceptual Space 1: Organic, coral-like growth based on fbm noise
    float organic = fbm(pos * 3.0 + time * 0.3);
    float organicMask = smoothstep(0.3, 0.5, organic);

    // Conceptual Space 2: Digital glitch grid patterns using sine modulation
    float glitch = abs(sin(10.0 * pos.x + time) * cos(10.0 * pos.y - time));
    float glitchMask = smoothstep(0.4, 0.6, glitch);
    
    // Map cross-space: blend structures from both spaces with weight modulation by polar gradient
    float blendFactor = smoothstep(0.2, 0.8, radius) * 0.5 + 0.5 * glitchMask;
    
    // Emergent structure: a hybrid with swirling "data-organic" pattern
    float swirl = sin(angle * 4.0 + organic * 6.2831 + time) * 0.5 + 0.5;
    float emergent = mix(organicMask, glitchMask, blendFactor) * swirl;
    
    // Color evolution: organic warm hues blended with cool digital tones
    vec3 organicColor = mix(vec3(0.8, 0.5, 0.2), vec3(1.0, 0.8, 0.5), organic);
    vec3 digitalColor = mix(vec3(0.1, 0.2, 0.5), vec3(0.4, 0.9, 1.0), glitch);
    
    // Emergent blend: use emergent factor to determine final mix
    vec3 finalColor = mix(organicColor, digitalColor, emergent);
    
    // Additional subtle vignette
    float vignette = smoothstep(1.0, 0.2, radius);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}