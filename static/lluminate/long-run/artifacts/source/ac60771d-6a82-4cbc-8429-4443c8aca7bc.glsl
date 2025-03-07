precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(13.0, 37.0))) * 43758.5453);
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

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 errorGlitch(vec2 pos) {
    float glitch = step(0.95, fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453 + time));
    float offset = glitch * (noise(pos * 20.0 + time) - 0.5) * 0.15;
    return pos + vec2(offset, 0.0);
}

vec2 reverseGlitch(vec2 pos, float seed) {
    float t = time * 0.5 + seed;
    float shift = (noise(pos * 8.0 + t) - 0.5) * 0.15;
    return pos - vec2(shift, shift);
}

float radialDecay(vec2 pos) {
    float r = length(pos);
    return 1.0 - smoothstep(0.2, 0.5, r);
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce combined glitch effects
    pos = errorGlitch(pos);
    pos = reverseGlitch(pos, 1.23);
    
    // Create polar coordinates for swirling vortex effect
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Build an emergent pattern: swirling vortex modulated by fractal noise
    float vortex = sin(angle * 6.0 + time * 2.0 + fbm(pos * 3.0)) * 0.3;
    float mask = smoothstep(0.7 + vortex, 0.68 + vortex, radius);
    
    // Compute fractal noise for organic texture and digital decay interplay
    float fractal = fbm(pos * 2.0);
    float decay = radialDecay(pos);
    
    // Define two color schemes that blend organic growth with digital glitches
    vec3 organic = vec3(0.1, 0.5, 0.2) + 0.2 * vec3(sin(time), cos(time), sin(time * 0.5));
    vec3 decayColor = vec3(0.9, 0.6, 0.3) * decay;
    
    // Mix color schemes based on fractal modulation
    vec3 colorMix = mix(organic, decayColor, fractal);
    
    // Overlay a digital glitch grid effect using sine waves
    float grid = sin((pos.x + time) * 10.0) * sin((pos.y - time) * 10.0);
    grid = smoothstep(0.2, 0.25, abs(grid));
    vec3 glitch = vec3(0.0, 0.8, 0.5) * abs(sin(time * 3.0 + angle));
    colorMix = mix(colorMix, glitch, grid * 0.5);
    
    // Apply the swirling mask to blend the composition
    colorMix *= mask;
    
    gl_FragColor = vec4(colorMix, 1.0);
}