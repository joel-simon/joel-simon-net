precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float starburst(vec2 p, vec2 pos, float intensity) {
    vec2 dir = p - pos;
    float dist = length(dir);
    float angle = atan(dir.y, dir.x);
    float stars = abs(sin(angle * 8.0 + time * 2.0)) / (1.0 + 20.0 * dist);
    return smoothstep(intensity, intensity - 0.01, stars);
}

float bubbleEffect(vec2 p, vec2 center, float scale) {
    vec2 d = p - center;
    float r = length(d);
    float bubble = sin(r * scale - time * 3.0);
    return smoothstep(0.5, 0.49, bubble);
}

float glitchEffect(vec2 p) {
    vec2 grid = floor(p * 15.0);
    float glitch = noise(grid + time);
    return step(0.6, glitch);
}

void main(){
    vec2 center = vec2(0.5, 0.5);
    // Reverse coordinates for a mirrored twist
    vec2 revUV = vec2(1.0 - uv.x, 1.0 - uv.y);
    // Combine both UVs with a dynamic weighted mix
    vec2 mixedUV = mix(uv, revUV, 0.3 + 0.2 * sin(time * 1.5));
    
    // Background gradient: using radial distance from center with a twist of noise.
    float d = length(mixedUV - center);
    vec3 bg = mix(vec3(0.01, 0.04, 0.08), vec3(0.3, 0.15, 0.4), d + 0.1 * noise(mixedUV * 10.0));
    
    // Apply starburst effect at center, modulated with a bubble ripple on top.
    float stars = starburst(mixedUV, center, 0.35);
    float bubbles = bubbleEffect(mixedUV, center + 0.1 * vec2(cos(time), sin(time)), 30.0);
    
    // Glitch overlay using a grid and noise function.
    float glitch = glitchEffect(mixedUV + 0.05 * vec2(sin(time * 2.0), cos(time * 2.0)));
    
    // Synthesize effects using SCAMPER operations: combine starburst with bubbles and reverse patterns.
    float mask = clamp(stars + 0.5 * bubbles + 0.3 * glitch, 0.0, 1.0);
    
    // Dynamic color blend with warm and cool tones.
    vec3 colorA = vec3(0.8, 0.3, 0.5);
    vec3 colorB = vec3(0.2, 0.8, 0.9);
    vec3 finalColor = mix(bg, mix(colorA, colorB, mixedUV.y), mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}