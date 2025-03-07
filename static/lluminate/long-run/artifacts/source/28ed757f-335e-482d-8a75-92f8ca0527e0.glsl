precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(random(i), random(i + vec2(1.0, 0.0)), u.x),
               mix(random(i + vec2(0.0, 1.0)), random(i + vec2(1.0, 1.0)), u.x), u.y);
}

vec3 glitchEffect(vec2 pos, float t) {
    // Random card: "Honor thy error as a hidden intention."
    // Interpret: Let errors (glitches) appear as striking digital artifacts.
    // Apply: Create vertical bands with shifted middle that glitch over time.
    float band = step(0.95, abs(sin(pos.y * 50.0 + t * 10.0)));
    float shift = smoothstep(0.4, 0.5, noise(vec2(pos.y * 10.0, t)));
    pos.x += (band * shift) * 0.3 * sin(t * 5.0);
    return vec3(0.1, 0.3, 0.5) + vec3(0.4, 0.2, 0.1) * band;
}

vec3 fractalPulse(vec2 pos, float t) {
    // Use an old idea: fractal noise with pulsing center.
    float scale = 1.0;
    float n = 0.0;
    for (int i = 0; i < 3; i++) {
        n += noise(pos * scale + t) / scale;
        scale *= 2.0;
    }
    float pulse = smoothstep(0.4, 0.0, length(pos)) * abs(sin(t * 2.0));
    return vec3(0.2, 0.5, 0.7) * (n + pulse);
}

vec3 abstractLines(vec2 pos, float t) {
    // What would your closest friend do? Interpret: create unexpected, friendly strokes.
    float lines = abs(sin(10.0 * pos.y + t)) * abs(cos(10.0 * pos.x - t));
    float edge = smoothstep(0.2, 0.21, lines);
    return vec3(0.8, 0.6, 0.2) * edge;
}

void main() {
    // Center uv at 0,0 and scale
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create glitch-based artifact from directive "Honor thy error as a hidden intention."
    vec3 colGlitch = glitchEffect(pos, time);
    
    // Create fractal pulsing background with an old idea
    vec3 colFractal = fractalPulse(pos, time);
    
    // Create unexpected abstract friendly stroke lines
    vec3 colLines = abstractLines(pos, time);
    
    // Blend them with creative weightings
    vec3 color = mix(colFractal, colGlitch, 0.5);
    color = mix(color, colLines, 0.3);
    
    // Add a subtle noise overlay for texture
    float n = noise(pos * 10.0 + time);
    color += 0.05 * vec3(n, n * 0.8, n * 1.2);
    
    gl_FragColor = vec4(color, 1.0);
}