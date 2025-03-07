precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random numbers based on input seed 
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// A variant of noise that emphasizes error-driven disruption
float errorNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Directive: "Honor thy error as a hidden intention" 
// Interpretation: allow defects to guide pattern development.
// This function introduces intermittent glitches as intentional errors.
float glitch(vec2 pos) {
    float pulse = smoothstep(0.3, 0.31, fract(time * 0.5));
    float glitchNoise = step(0.98, fract(errorNoise(pos * 15.0 + time)));
    return pulse * glitchNoise;
}

// Generate an organic shape by mapping polar coordinates with errors.
float organicShape(vec2 pos) {
    // Convert to polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a flowing petal-like pattern with time modulated phase shifts.
    float petals = abs(sin(6.0 * angle + time * 1.3));
    // Introduce error within the organic growth by offsetting the radius.
    float errorFactor = errorNoise(pos * 3.0 + vec2(time)) * 0.4;
    float shape = smoothstep(0.45 + errorFactor, 0.4, r * (1.0 + 0.5 * petals));
    return shape;
}

void main() {
    // Center uv coordinates
    vec2 pos = (uv - 0.5) * 2.0;

    // Apply a slow orbital rotation to the whole scene
    float angleRot = time * 0.2;
    float s = sin(angleRot);
    float c = cos(angleRot);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);

    // Create a background with layered fluctuating error noise
    vec2 noisePos = pos * 2.5;
    float layeredNoise = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        layeredNoise += amp * errorNoise(noisePos + time * 0.3);
        noisePos *= 1.8;
        amp *= 0.5;
    }
    
    // Build the organic error-inspired structure
    float shapeMask = organicShape(pos);
    // Introduce deliberate glitches to honor the error directive
    float deliberateGlitch = glitch(pos * 5.0);
    
    // Compose colors from two palettes
    vec3 organicColor = vec3(0.6 + 0.4 * sin(time + pos.xyx * 2.0));
    vec3 errorColor = vec3(0.1, 0.05, 0.2) + 0.3 * vec3(layeredNoise);
    
    // Mix the organic structure with background error 
    vec3 finalColor = mix(errorColor, organicColor, shapeMask);
    // Overlay glitches
    finalColor += deliberateGlitch * vec3(1.0, 0.4, 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}