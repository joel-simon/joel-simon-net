precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function based on sine and dot product
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise function using hash interpolation
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

// Glitch distortion function: perturbs coordinates horizontally
vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 15.0, time * 0.8));
    return p + vec2(n * 0.08, 0.0);
}

// Wave function representing dynamic digital ocean
float wave(vec2 p) {
    // Create multiple sine waves for complexity where resolution (uv.x) defines the base
    float w = sin(p.x * 6.2831 + time) * 0.1;
    w += sin(p.x * 12.5662 - time * 1.5) * 0.05;
    // Apply noise for digital distortion
    w += (noise(p * 8.0 + time) - 0.5) * 0.08;
    return w;
}

void main(void) {
    // Normalize uv coordinates
    vec2 p = uv;
    
    // Apply glitch distortion to the coordinate system
    p = glitch(p);
    
    // Create a context representing a stormy ocean—a symbol of resilience.
    // Traditionally, an anchor is used to represent stability in storms.
    // Here, the digital ocean waves emulate resilience, replacing the anchor with the subject.
    // Calculate the digital wave height at current x-position.
    float digitalWave = 0.5 + wave(p * 3.0);
    
    // Determine ocean mask: fragments under the wave level are ocean
    float oceanMask = step(p.y, digitalWave);
    
    // Introduce glitch stripes on ocean using periodic sine functions
    float glitchStripes = abs(sin((p.y + time * 3.0) * 40.0));
    float glitchEffect = smoothstep(0.4, 0.45, glitchStripes);
    
    // Ocean color: blend of deep blue and teal with glitch influence
    vec3 oceanColor = mix(vec3(0.02, 0.05, 0.2), vec3(0.0, 0.4, 0.5), glitchEffect);
    
    // Sky gradient: transitions from a twilight purple to a dark night
    vec3 skyColor = mix(vec3(0.2, 0.0, 0.3), vec3(0.05, 0.05, 0.1), p.y);
    
    // Replace the traditional anchor symbol with digital ocean waves defining resilience
    vec3 finalColor = mix(skyColor, oceanColor, oceanMask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}