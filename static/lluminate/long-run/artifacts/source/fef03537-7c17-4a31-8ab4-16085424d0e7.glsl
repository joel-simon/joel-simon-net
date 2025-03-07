precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return f;
}

// Reversal & Combination Concept:
// Instead of natural upward tree branches, we transform the idea to digital vines that descend from the top.
// Additionally, we combine a glitch effect in the head of the vine using fbm noise and reverse the usual
// shape generation by applying an edgy cutoff.
float descendingVine(vec2 p) {
    // Reverse vertical coordinate to simulate growth from the top.
    p.y = 1.0 - p.y;
    
    // Apply a horizontal drift modulated by sine functions.
    float drift = sin(p.y * 12.0 + time * 1.2) * 0.12;
    
    // Base vine path computed from centered x coordinate and drift.
    float path = smoothstep(0.035, 0.0, abs(p.x - 0.5 - drift - sin(p.y * 4.0 + time * 1.8) * 0.06));

    // Introduce glitch artifacts with fbm noise and a secondary modulation.
    float glitch = smoothstep(0.3, 0.4, abs(fbm(p * 20.0 + time * 3.0) - 0.5));
    
    // Combine the base vine with glitch patches.
    float vine = path * (1.0 - glitch);
    
    // Gradually fade the vine as it extends downward.
    vine *= smoothstep(0.0, 0.4, p.y);
    
    return vine;
}

void main() {
    vec2 p = uv;
    
    // Background: A gradient shifting from deep space indigo to a digital cyan.
    vec3 bgColor = mix(vec3(0.03, 0.04, 0.1), vec3(0.0, 0.35, 0.35), p.y);
    // Overlay subtle digital noise.
    bgColor += 0.065 * vec3(fbm(p * 10.0 + time * 1.1));
    
    // Foreground: Compute descendant digital vines.
    float vineIntensity = descendingVine(p);
    
    // Color blending: Glowing neon shade with glitchy RGB flicker.
    vec3 vineColor = mix(vec3(0.0, 0.18, 0.25), vec3(0.0, 0.85, 0.95), vineIntensity);
    vineColor += 0.11 * vec3(
        sin(p.y * 55.0 + time * 3.2),
        sin(p.x * 55.0 - time * 2.7),
        cos(p.y * 55.0 + time)
    );
    
    // Final composite effect.
    vec3 color = mix(bgColor, vineColor, vineIntensity);
    
    gl_FragColor = vec4(color, 1.0);
}