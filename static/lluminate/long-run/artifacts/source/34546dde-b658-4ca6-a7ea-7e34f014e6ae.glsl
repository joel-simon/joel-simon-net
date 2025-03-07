precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 239.345);
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

vec2 askew(vec2 p) {
    float n = noise(p * 4.0 + time);
    return p + vec2(n * 0.1, -n * 0.1);
}

vec3 reversedLandscape(vec2 p) {
    // Reverse typical coordinate assumptions: imagine the bottom is now the top.
    float n = noise(p * 8.0 - time * 0.5);
    float wave = sin((p.x + n) * 20.0 + time);
    float mask = smoothstep(0.48, 0.52, p.y + wave * 0.1);
    vec3 organic = vec3(0.1, 0.6, 0.2) * (0.5 + 0.5 * sin(time + p.xyx * 5.0));
    vec3 digital = vec3(0.2, 0.1, 0.5) * (0.5 + 0.5 * cos(time + p.yyx * 7.0));
    return mix(digital, organic, mask);
}

void main(void) {
    vec2 p = uv;
    // Reverse assumption: treat vertical axis inverted and apply a skew
    p.y = 1.0 - p.y;
    p = askew(p);
    
    vec3 color = reversedLandscape(p * 2.0);
    
    // Introduce glitch artifacts by modulating fragments based on noise
    float glitch = step(0.95, noise(p * 50.0 + time * 10.0));
    color += glitch * vec3(0.3, 0.1, 0.4);
    
    gl_FragColor = vec4(color, 1.0);
}