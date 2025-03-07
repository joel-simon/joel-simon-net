precision mediump float;
varying vec2 uv;
uniform float time;

// Reversed assumption: Instead of treating errors as anomalies, we celebrate order in randomness

// Revised hash for structured pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(31.7, 17.3))) * 43758.5453);
}

// Structured noise function with layered progression
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

// Layered fractal function that builds order with each octave,
// but subtly introduces a glitch-like contrast between layers.
float fractal(vec2 p) {
    float f = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++) {
        f += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return f;
}

// Produces an ordered glitch effect by inverting certain bands
float orderedGlitch(vec2 p) {
    float bands = abs(sin(p.y * 40.0 + time * 5.0));
    // Reverse the assumption: where glitch appears, order emerges.
    return smoothstep(0.3, 0.35, bands);
}

void main(void) {
    // Center UV coordinates and scale down for ordered structure
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Convert to polar coordinates for radial symmetry
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Instead of chaotic swirls, we use a steady rotating grid-like structure
    float spiral = abs(cos(a * 6.0 + time)) * smoothstep(1.0, 0.2, r);
    
    // Create a layered fractal pattern with an emergent order
    float layer = fractal(pos * 3.0 + time * 0.5);
    
    // Introduce an ordered glitch that appears at regular bands
    float glitch = orderedGlitch(pos);
    
    // Blend vibrant, structured colors that offset the expected digital error aesthetic
    vec3 baseColor = mix(vec3(0.0, 0.4, 0.7), vec3(0.8, 0.3, 0.5), layer);
    vec3 orderColor = vec3(0.9, 0.9, 0.8) * spiral;
    
    // The glitch enhances the contrast between order and seeming disorder
    vec3 finalColor = mix(baseColor, orderColor, glitch);
    
    gl_FragColor = vec4(finalColor, 1.0);
}