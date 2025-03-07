precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

vec2 hash2(vec2 p) {
    return vec2(hash(p + vec2(0.0, 0.0)), hash(p + vec2(5.2, 1.3)));
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec3 glitchLines(vec2 p) {
    float line = step(0.95, fract(p.y * 10.0 + time * 5.0));
    return vec3(line * 0.3, line * 0.1, line * 0.4);
}

vec3 errorIntent(vec2 p) {
    // "Honor thy error as a hidden intention"
    // Warp coordinates in a chaotic but rhythmic manner.
    float n = noise(p * 3.0 + time);
    vec2 warped = p + 0.2 * vec2(sin(time + n * 6.2831), cos(time - n * 6.2831));
    float radial = length(warped);
    float intensity = smoothstep(0.6, 0.4, radial + 0.5 * sin(n * 10.0 + time));
    vec3 baseColor = vec3(0.2, 0.05, 0.3);
    vec3 pulse = vec3(sin(n*5.0 + time), cos(n*5.0 - time), sin(n*3.0));
    return baseColor + intensity * pulse;
}

vec3 vintageGlitch(vec2 p) {
    // "Use an old idea": Layers of fading, pixelated texture.
    float grid = step(0.8, fract(p.x * 20.0 + p.y * 20.0 - time * 2.0));
    float vignetting = smoothstep(1.0, 0.4, length(p));
    vec3 color = mix(vec3(0.1, 0.0, 0.15), vec3(0.9, 0.8, 0.7), vignetting);
    return mix(color, vec3(0.0, 0.0, 0.0), grid * 0.5);
}

void main(){
    // Remap uv to center coordinates [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a subtle rotation based on time
    pos = rotate(pos, time * 0.2);
    
    // Choose between two creative domains using paradox: digital error and vintage glitch.
    vec3 errorDomain = errorIntent(pos);
    vec3 vintageDomain = vintageGlitch(pos);
    
    // Mix the domains based on radial blend
    float blendFactor = smoothstep(0.2, 0.6, length(pos));
    vec3 color = mix(errorDomain, vintageDomain, blendFactor);
    
    // Overlay additional glitch lines
    color += glitchLines(pos);
    
    gl_FragColor = vec4(color, 1.0);
}