precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    // Invert common assumption: Instead of centering patterns at uv.center,
    // create "anti-center" effects by emphasizing edges over the center.
    vec2 pos = uv;
    
    // Strengthening the role of the edges by amplifying distance to center.
    float edgeFactor = 1.0 - length(uv - vec2(0.5));
    
    // Reverse assumption: Instead of swirling coherent waves, use fbm to carve out unexpected digital terrains.
    vec2 fbmPos = pos * 5.0 + vec2(time * 0.3);
    float pattern = fbm(fbmPos);
    
    // Introduce a digital glitch by perturbing the pattern based on pseudorandom noise
    float glitch = (pseudoRandom(pos * time) - 0.5) * 0.4;
    pattern += glitch;
    
    // Create an inverted gradient where center is subdued and edges are vivid.
    float intensity = smoothstep(0.3, 0.0, edgeFactor + pattern * 0.5);
    
    // Use dual color schemes that oppose typical aesthetics.
    vec3 colorA = vec3(0.1, 0.4, 0.8);
    vec3 colorB = vec3(0.8, 0.3, 0.1);
    vec3 color = mix(colorA, colorB, pattern);
    
    // Further modulate with a shifting glitch overlay: reverse traditional static harmony.
    float glitchMask = smoothstep(0.2, 0.5, pattern);
    color = mix(color, vec3(0.9, 0.9, 0.9), glitchMask * 0.3);
    
    gl_FragColor = vec4(color * intensity, 1.0);
}