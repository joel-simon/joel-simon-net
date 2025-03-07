precision mediump float;
varying vec2 uv;
uniform float time;

//
// A new hash function based on dot product distortion
//
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233)))*43758.5453);
}

//
// New noise function with improved interpolation
//
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

//
// Fractal Brownian Motion with varied octave weightings for emergent structure
//
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

//
// Organic field: simulate growth and branching using warped noise
//
float organicField(vec2 p) {
    vec2 center = vec2(0.5);
    vec2 delta = p - center;
    float angle = atan(delta.y, delta.x);
    float dist = length(delta);
    
    // Use time and fbm to create evolving branches
    float branch = fbm(p * 8.0 + vec2(sin(time), cos(time)));
    float curve = sin(angle * 4.0 + branch * 6.28);
    
    return smoothstep(0.35, 0.4, abs(dist - 0.25 - 0.05 * curve));
}

//
// Digital grid: simulate a pixelated digital structure with jitter
//
float digitalGrid(vec2 p) {
    vec2 grid = fract(p * 20.0);
    float line = step(0.85, grid.x) + step(0.85, grid.y);
    return clamp(line, 0.0, 1.0);
}

//
// Digital perturbation: add a glitchy digital distortion using noise
//
vec2 digitalPerturb(vec2 p) {
    float shift = noise(p * 30.0 + time) * 0.04;
    return p + vec2(shift, -shift);
}

//
// Main emergent blending: combine a warped organic field with digital grid glitches,
// then use a sharp threshold to reveal emergent patterns
//
void main(void) {
    // Distort UVs for digital effect
    vec2 perturbedUV = digitalPerturb(uv);
    
    // Organic layer: twisted, branching growth
    float organic = organicField(uv);
    organic += 0.2 * fbm(uv * 15.0 - time * 0.5);
    
    // Digital layer: crisp grid with dynamic jitter
    float digital = digitalGrid(perturbedUV);
    digital += 0.1 * noise(perturbedUV * 40.0 + time);
    
    // Blend spaces selectively: emergent structure appears when both are present
    float emergent = organic * digital;
    emergent = smoothstep(0.4, 0.6, emergent);
    
    // Define color schemes: organic warm tones vs digital cool tones
    vec3 organicColor = vec3(0.95, 0.65, 0.3);
    vec3 digitalColor = vec3(0.15, 0.7, 0.8);
    vec3 baseColor = vec3(0.05, 0.05, 0.1);
    
    // Interpolate colors based on emergent feature strength
    vec3 color = mix(baseColor, organicColor, organic);
    color = mix(color, digitalColor, digital);
    color = mix(color, vec3(1.0) * 0.9, emergent);
    
    gl_FragColor = vec4(color, 1.0);
}