precision mediump float;
varying vec2 uv;
uniform float time;

// Core function: hash - a simple random number generator
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 143758.5453);
}

// 2D noise function using bilinear interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
               u.y);
}

// Fractal Brownian Motion function for evolving textures
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Reverse assumption: Instead of organic growth fading into error, digital structure now governs a rigid polar order
// Transform uv coordinates into polar space, then re-map to Cartesian while allowing digital "errors"
vec2 digitalPolar(vec2 p) {
    // Shift origin to center and create polar coordinates
    p = p * 2.0 - 1.0;
    float r = length(p);
    float angle = atan(p.y, p.x);
    
    // Reverse the typical assumption: use a digital quantization of angle
    float steps = 8.0;
    angle = floor(angle / (3.1415*2.0/steps)) * (3.1415*2.0/steps);
    
    // Introduce time-based jitter to the radial dimension
    r += 0.1 * sin(10.0 * r - time * 3.0);
    
    // Map back to Cartesian
    return vec2(r * cos(angle), r * sin(angle)) * 0.5 + 0.5;
}

// Glitch module: inject abrupt transitions where digital rules break the organic mold
vec2 glitch(vec2 p) {
    float glitchFactor = step(0.4, fract(fbm(p * 10.0 + time)));
    p.x += glitchFactor * 0.05 * sin(100.0 * p.y + time * 2.0);
    return p;
}

void main() {
    vec2 p = uv;
    
    // Step 1: Force a digital order using polar quantization
    p = digitalPolar(p);
    
    // Step 2: Apply digital glitch disturbances
    p = glitch(p);
    
    // Create a dynamic digital background using fbm
    float textureField = fbm(p * 6.0 + time * 0.5);
    
    // Combine an abstract digital grid with organic flow lines
    float grid = smoothstep(0.35, 0.36, abs(sin(20.0 * p.x + time) * cos(20.0 * p.y + time)));
    
    // Merge digital order against an underlying organic complexity
    float mixFactor = mix(textureField, grid, 0.4);
    
    // Generate color based on reversed assumptions: rigid digital blue meets erratic organic red
    vec3 digitalColor = vec3(0.1, 0.5, 0.9);
    vec3 organicColor = vec3(0.9, 0.3, 0.2);
    
    // Mix colors and emphasize the hard digital cuts with digital outlines
    vec3 color = mix(organicColor, digitalColor, mixFactor);
    
    // Apply a subtle vignette for focus
    float vignette = smoothstep(0.8, 0.2, length(uv - 0.5));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}