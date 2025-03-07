precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float swirl(vec2 pos, float strength) {
    float r = length(pos);
    float angle = strength * r;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return length(rot * pos);
}

float branchPattern(vec2 pos, float t) {
    // Convert to polar coordinates after a subtle rotation
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    // Introduce a twist with time-modulated swirl and noise interference
    float swirlEffect = swirl(pos, 5.0 * sin(time * 0.3));
    float wave = sin(radius * 20.0 - angle * 4.0 + t * 2.0);
    float n = noise(pos * 3.0 + t);
    // Medium-distance association: blend cosmic swirl with organic disturbance
    return smoothstep(0.15, 0.25, abs(wave) * exp(-5.0 * swirlEffect + n));
}

vec3 cosmicBranch(vec2 pos, float t) {
    // Base cosmic background
    vec3 back = vec3(0.05,0.07,0.1);
    // Dynamic branches: mixing deep violets and teal hints
    vec3 branchColor = vec3(0.3, 0.6, 0.5);
    vec3 glow = vec3(0.8, 0.4, 0.9);
    // Calculate branch pattern with a central cosmic twist
    float pattern = branchPattern(pos, t);
    // Medium association: incorporate a pulsating glow modulated by noise and swirl
    float g = smoothstep(0.0, 0.3, noise(pos * 10.0 + t * 1.5));
    vec3 col = mix(branchColor, glow, g);
    return mix(back, col, pattern);
}

void main() {
    // Center and zoom with a subtle pulsation to evoke a cosmic tree essence
    vec2 pos = (uv - 0.5) * (1.0 + 0.2 * sin(time * 0.5)) + 0.5;
    // Rotate coordinate space slightly over time for continuous transformation
    float angle = 0.2 * sin(time * 0.3);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * (pos - 0.5) + 0.5;
    
    vec3 color = cosmicBranch(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}