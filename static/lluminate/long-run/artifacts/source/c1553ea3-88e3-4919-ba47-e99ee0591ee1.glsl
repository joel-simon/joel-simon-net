precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1., 0.));
    float c = random(i + vec2(0., 1.));
    float d = random(i + vec2(1., 1.));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1. - u.x) + (d - b) * u.x * u.y;
}

vec2 rotate(vec2 p, float a){
    float s = sin(a);
    float c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

// Synthesize a morphing circular pattern (like a cosmic bloom)
float cosmicBloom(vec2 p) {
    p = rotate(p, time * 0.3);
    float r = length(p);
    float angle = atan(p.y, p.x);
    float waves = sin(10.0 * r - time * 2.0 + 3.0 * angle);
    float n = noise(p * 3.0 + sin(time));
    return smoothstep(0.4 + 0.2 * n, 0.38, r + 0.1 * waves);
}

// Synthesize an organic jellyfish-like wisp texture
vec3 jellyfish(vec2 p) {
    vec2 pos = p * 1.5;
    float n = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 4; i++){
        n += amplitude * noise(pos * float(i+1) + time);
        amplitude *= 0.5;
    }
    float glow = smoothstep(0.5, 0.3, length(p) - 0.2 * sin(time + n * 5.0));
    vec3 col = vec3(0.1, 0.4, 0.8) + 0.5 * vec3(sin(n + time), cos(n - time), sin(n*2.0));
    return col * glow;
}

void main(){
    // Center uv into coordinate system [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Domain selection: blend a cosmic bloom (celestial fractal) with jellyfish organic wisps.
    float bloomMask = cosmicBloom(pos);
    vec3 colorCosmic = vec3(0.05, 0.02, 0.1) + 0.3 * vec3(sin(time + pos.x * 3.0), cos(time + pos.y * 3.0), sin(time));
    vec3 colorJelly = jellyfish(pos);
    
    // Introduce digital glitches by modulating with random noise bands along uv coordinates.
    float glitch = step(0.98, random(uv * time)) * 0.2;
    
    // Combine both domains in a creative synthesis.
    vec3 result = mix(colorCosmic, colorJelly, bloomMask) + glitch;
    
    gl_FragColor = vec4(result, 1.0);
}