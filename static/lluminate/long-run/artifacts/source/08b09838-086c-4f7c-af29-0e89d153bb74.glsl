precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(13.0, 37.0))) * 43758.5453);
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

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitch(vec2 pos) {
    float offset = noise(vec2(pos.y * 10.0, time * 0.5));
    return pos + vec2(offset * 0.1, 0.0);
}

void main(void) {
    // Map uv to a coordinate system centered at origin.
    vec2 pos = (uv - 0.5) * 2.0;
    pos = glitch(pos);
    
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Creative Strategy Implementation:
    // Trait: Vitality which is inherent in a beat (heartbeat).
    // Symbol: The traditional resilient "heart" motif.
    // Context: A pulsing heart is essential to life.
    // Replacement: Here, the “heart” is simulated by rhythmic, pulsating circular patterns.
    float beat = sin(time * 4.0 - radius * 12.0);
    float pulse = smoothstep(0.1, 0.13, abs(beat));
    
    // Organic texture via fractal noise and modulation; simulates organic blood flow.
    float organic = fbm(pos * 3.0 + time);
    
    // Overlay an organic radial gradient that pulses like a heart.
    float heartShape = smoothstep(0.5 + pulse * 0.2, 0.48 + pulse * 0.2, radius);
    
    // Dynamic color gradient resembling a beating heart’s glow.
    vec3 coreColor = vec3(1.0, 0.0, 0.0);
    vec3 glowColor = vec3(1.0, 0.6, 0.2);
    vec3 background = vec3(0.05, 0.0, 0.0);
    
    // Mix colors based on organic noise and pulsating beat.
    vec3 colorMix = mix(coreColor, glowColor, organic);
    colorMix = mix(colorMix, background, radius * 0.7);
    
    // Enhanced by pulsating overlay that defines the heart's resilience.
    vec3 finalColor = mix(colorMix, vec3(1.0, 1.0, 1.0), pulse * 0.5);
    finalColor *= heartShape;
    
    gl_FragColor = vec4(finalColor, 1.0);
}