precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = fract(sin(dot(i, vec2(127.1, 311.7))) * 43758.5453123);
    float b = fract(sin(dot(i + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453123);
    float c = fract(sin(dot(i + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453123);
    float d = fract(sin(dot(i + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453123);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main() {
    // Scale uv for both grid and organic effects
    vec2 pos = uv * 10.0;
    vec2 id = floor(pos);
    vec2 f = fract(pos);

    // Domain 1: Digital chessboard structure
    float chess = mod(id.x + id.y, 2.0);

    // Domain 2: Organic coral-like flow using sine modulation and noise
    float coral = sin((f.x + f.y + time) * 3.1415) * 0.5 + 0.5;
    float organicNoise = noise(uv * 5.0 + time);

    // Synthesize: blend the rigid chess layout with the organic coral pulse
    float pattern = mix(chess, coral, 0.7) + organicNoise * 0.2;

    // Color synthesis: digital cool purple contrasted with organic teal tones
    vec3 digitalColor = vec3(0.4, 0.0, 0.6);
    vec3 organicColor = vec3(0.0, 0.8, 0.6);
    vec3 color = mix(digitalColor, organicColor, pattern);

    gl_FragColor = vec4(color, 1.0);
}