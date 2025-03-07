precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
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
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 swirl(vec2 p, float strength) {
    float r = length(p);
    float angle = strength * exp(-r * 2.0) * time;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

vec2 reverseGlitch(vec2 p, float seed) {
    float t = time * 0.7 + seed;
    float disp = (noise(p * 10.0 + t) - 0.5) * 0.25;
    return p - vec2(disp, disp);
}

float radialDecay(vec2 p) {
    float r = length(p);
    float decay = 1.0 - smoothstep(0.3, 0.6, r);
    return decay;
}

void main() {
    vec2 st = uv * 2.0 - 1.0;
    st *= 1.2;
    // Apply swirling transformation (Modified by swirling, SCAMPER: Modify)
    vec2 swirled = swirl(st, 5.0);
    // Reverse glitch effect to subtract structure (SCAMPER: Reverse)
    vec2 glitchPos = reverseGlitch(swirled, 2.34);
    
    // Generate a layered noise pattern with fbm (combining organic and digital)
    float pattern = fbm(glitchPos * 3.0);
    float decay = radialDecay(glitchPos);
    
    // Create a color palette mixing digital cool tones and organic warmth.
    vec3 organic = vec3(0.4, 0.7, 0.3);
    vec3 digital = vec3(0.1, 0.3, 0.8);
    
    // Use pattern to interpolate between the palettes.
    vec3 baseColor = mix(organic, digital, pattern);
    
    // Introduce glitch bands with step function
    float band = step(0.85, fract(uv.y * 20.0 - time * 2.0));
    vec3 glitchColor = vec3(0.0);
    
    // Merge everything together with decay.
    vec3 color = mix(baseColor * decay, glitchColor, band * 0.4);
    
    gl_FragColor = vec4(color, 1.0);
}