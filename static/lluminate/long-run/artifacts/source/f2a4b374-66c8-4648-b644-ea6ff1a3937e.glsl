precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 glitchColor(vec2 p, float t) {
    float n = pseudoNoise(p * 50.0 + t);
    float r = pseudoNoise(p + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(p + vec2(0.0, t * 0.15));
    float b = pseudoNoise(p + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

float heartShape(vec2 p, float scale) {
    p *= scale;
    p.x *= 1.2;
    float a = atan(p.x, p.y)/3.1416;
    float r = length(p);
    float h = abs(p.x) - sqrt(r) * 0.5;
    return smoothstep(0.01, 0.02, h);
}

void main() {
    vec2 centered = uv - 0.5;
    centered *= 2.0;
    
    // Spiral galaxy dynamics
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    float spiral = sin(10.0 * radius - time * 3.0 + angle * 5.0);
    
    // Digital glitch overlay
    vec3 digital = glitchColor(centered * 2.0, time);
    
    // Create a heart with organic glitch texture
    float heart = heartShape(centered, 2.5);
    heart = 1.0 - heart;
    vec3 organic = mix(vec3(0.8, 0.2, 0.3), vec3(1.0, 0.5, 0.6), heart);
    
    // Blending cosmic and organic elements with glitch perturbation
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.2, 0.8, 1.0), radius);
    vec3 glitchMix = mix(baseColor, digital, 0.3);
    vec3 finalColor = mix(glitchMix, organic, heart * 0.7);
    
    // Apply radial vignette and accentuate spiral dynamics
    float vignette = smoothstep(1.0, 0.2, radius);
    finalColor *= vignette * abs(spiral);
    
    gl_FragColor = vec4(finalColor, 1.0);
}