precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
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

void main(void) {
    // Reverse assumption: Instead of embracing the grid and strict symmetry, we discard rigid layouts.
    // Translate uv to centered coordinates
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce a fluid deformation based on fbm noise
    vec2 deform = vec2(fbm(pos * 3.0 + time), fbm(pos * 3.0 - time));
    pos += (deform - 0.5) * 0.5;
    
    // Compute radial distance from modified position
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Reverse traditional polar mapping by inverting the radius effect:
    // Instead of getting brighter with lower r, we create a void at center and more details in the edges
    float voidCenter = smoothstep(0.0, 0.35, r);
    
    // Use oscillating waves that propagate from outside inward
    float ripple = sin(10.0 * (r - 0.5 * sin(time))) * 0.5 + 0.5;
    
    // Create a glitch-inspired digital artifact by perturbing polar angle with noise
    float digitalNoise = fbm(vec2(a * 2.0, time * 0.5));
    a += (digitalNoise - 0.5) * 1.0;
    
    // Generate a dynamic background that mixes organic waviness with digital interference
    vec3 organicColor = vec3(0.1, 0.6, 0.3);
    vec3 digitalColor = vec3(0.7, 0.2, 0.5);
    float mixFactor = smoothstep(0.3, 0.7, fbm(pos * 5.0 + time));
    vec3 color = mix(organicColor, digitalColor, mixFactor);
    
    // Overlay the ripple and void effect to challenge typical center-out luminance
    color *= mix(ripple, 1.0, voidCenter);
    
    // Add subtle luminescent artifacts at the periphery based on reversed assumptions about glow
    float peripheralGlow = smoothstep(0.5, 0.9, r);
    color += peripheralGlow * 0.15;
    
    gl_FragColor = vec4(color, 1.0);
}