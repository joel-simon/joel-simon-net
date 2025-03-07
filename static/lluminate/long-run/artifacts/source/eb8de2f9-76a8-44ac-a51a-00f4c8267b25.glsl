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
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Reversal Creative Concept:
// Instead of growing organic branches, we simulate an inversion: floating digital "vines" that defy gravity,
// as if the natural order of roots and branches is turned on its head. The vines emerge from the top
// and flow downward with a digital glitch texture.
float invertedVine(vec2 p) {
    // Invert vertical axis: vines sprout from the top.
    p.y = 1.0 - p.y;
    // Add a gentle horizontal drift using a sine function offset by time.
    float drift = sin(p.y * 10.0 + time) * 0.1;
    // Create a curved path for the vine.
    float vine = smoothstep(0.03, 0.0, abs(p.x - 0.5 - drift - sin(p.y * 3.0 + time * 1.5) * 0.05));
    // Introduce digital glitch artifacts by modulating with fbm noise.
    vine *= 1.0 - smoothstep(0.2, 0.3, abs(fbm(p * 15.0 + time * 2.0) - 0.5));
    // Gradually fade the vine towards its tail.
    vine *= smoothstep(0.0, 0.3, p.y);
    return vine;
}

void main() {
    vec2 p = uv;
    
    // Background: a digital twilight that shifts from deep indigo to a circuit board teal.
    vec3 bgColor = mix(vec3(0.02, 0.05, 0.15), vec3(0.0, 0.3, 0.3), p.y);
    // Add a layer of noisy digital interference.
    bgColor += 0.07 * vec3(fbm(p * 8.0 + time * 0.7));
    
    // Foreground: integrate reversed natural order - digital vines descending from the top.
    float vineAccum = invertedVine(p);
    
    // Color the vines in glowing neon for a striking digital effect.
    vec3 vineColor = mix(vec3(0.0, 0.15, 0.2), vec3(0.0, 0.8, 0.9), vineAccum);
    // Introduce subtle glitch color bands.
    vineColor += 0.1 * vec3(sin(p.y * 50.0 + time * 3.0), sin(p.x * 50.0 - time * 2.5), cos(p.y * 50.0 + time));
    
    // Composite using a simple mix.
    vec3 finalColor = mix(bgColor, vineColor, vineAccum);
    
    gl_FragColor = vec4(finalColor, 1.0);
}