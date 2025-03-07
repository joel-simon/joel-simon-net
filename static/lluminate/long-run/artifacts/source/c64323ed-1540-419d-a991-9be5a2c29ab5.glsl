precision mediump float;
varying vec2 uv;
uniform float time;

// Basic pseudo-random generation
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Fractal noise using a simple FBM implementation
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * random(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Reverse assumption: Instead of converging to a central growth pattern, allow the pattern to diverge
// and break expected symmetry, creating a glitch/digital decay aesthetic.
vec3 reversedDivergence(vec2 pos, float t) {
    // Create radial coordinates but invert the expected center-oriented decay.
    vec2 centered = (pos - 0.5) * 2.0;
    float r = length(centered);
    float a = atan(centered.y, centered.x);
    
    // Reverse the conventional smooth decay: use a growth function that increases with radius.
    float explosion = smoothstep(0.0, 1.0, r);
    
    // Create glitch offsets by perturbing the angle non-linearly.
    float glitch = sin(20.0 * r + t * 3.0 + fbm(pos * 10.0) * 6.28);
    float distortedAngle = a + glitch * 0.5;
    
    // Reconstruct coordinates from polar with the inverted behavior.
    vec2 glitchPos = vec2(cos(distortedAngle), sin(distortedAngle)) * r;
    
    // Introduce fractal noise and digital artifacts.
    float noise = fbm(glitchPos * 4.0 + t);
    float artifact = step(0.95, fract(noise * 10.0 + t));
    
    // Define a color scheme that contrasts digital glitch (neon cyan) with organic decay (deep magenta)
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.0, 0.8, 0.9), explosion);
    
    // Enhance with modulated artifact effects.
    baseColor += artifact * vec3(0.9, 0.2, 0.9);
    
    // Darken areas where noise is low, furthering a decayed feel.
    baseColor *= smoothstep(0.3, 1.0, noise);
    
    return baseColor;
}

void main(void) {
    // Provide a gentle pan/zoom that further disrupts expectation
    vec2 pos = uv;
    pos = (pos - 0.5) * (1.0 + 0.3 * sin(time * 1.3)) + 0.5;
    
    vec3 color = reversedDivergence(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}