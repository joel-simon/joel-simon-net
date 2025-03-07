precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 reverseGlitch(vec2 p, float seed) {
    // Instead of adding coherent distortion, we subtract noise to "decay" structure.
    float t = time * 0.5 + seed;
    float shift = (noise(p * 8.0 + t) - 0.5) * 0.15;
    return p - vec2(shift, shift);
}

float radialDecay(vec2 p) {
    // Reverse typical radial growth: start intense in center and decay outwards.
    float r = length(p);
    // Invert the decay to cause sudden drop in brightness instead of smooth growth.
    float decay = 1.0 - smoothstep(0.2, 0.5, r);
    return decay;
}

void main() {
    // Reverse core assumption: Instead of organic, growing structure, see fleeting decay.
    vec2 st = uv * 2.0 - 1.0;
    st *= 1.5;
    
    // Apply a reverse glitch, subtracting displacement instead of adding.
    vec2 pos = reverseGlitch(st, 1.23);
    
    // Compute a fractal noise pattern that decays outward
    float fractal = fbm(pos * 2.0);
    float decay = radialDecay(pos);
    
    // Create a color blend that fades with radial decay and fractal noise interference.
    vec3 baseColor = vec3(0.9, 0.6, 0.3) * decay;
    
    // Introduce digital decay: Dark glitch lines appear at periodic intervals.
    float line = step(0.8, fract(uv.y * 15.0 - time * 1.5));
    vec3 glitch = vec3(0.0, 0.0, 0.0);
    
    // Blend fractal-driven saturation inversion for a decaying effect.
    vec3 decayColor = mix(baseColor, vec3(0.1, 0.05, 0.0), fractal);
    
    vec3 color = mix(decayColor, glitch, line * 0.3);
    
    gl_FragColor = vec4(color, 1.0);
}