precision mediump float;
varying vec2 uv;
uniform float time;

// Basic hash function for pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(27.619, 57.583))) * 43758.5453);
}

// 2D noise function using bilinear interpolation
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

// Fractal Brownian Motion using the noise function
float fbm(vec2 p) {
    float f = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return f;
}

// Apply a swirling polar distortion based on time and noise
vec2 polarSwirl(vec2 p) {
    // Shift coordinate origin to center
    vec2 centered = p - 0.5;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    
    // Apply sinusoidal offset to the angle to create swirling branches
    float offset = sin(radius * 10.0 - time * 2.0 + fbm(p * 5.0)) * 0.5;
    angle += offset;
    
    // Convert back to cartesian coordinates
    vec2 distorted = vec2(cos(angle), sin(angle)) * radius;
    return distorted + 0.5;
}

// Main function rendering organic growth with digital glitches
void main(void) {
    vec2 p = uv;
    
    // Use polar swirl to create organic growth warping
    p = polarSwirl(p);
    
    // Create layered noise with fbm for textured branches
    float branchTexture = fbm(p * 8.0 + time * 0.3);
    
    // Create dynamic digital glitches using sine waves and noise
    float glitch = step(0.8, abs(sin((p.y + time * 4.0) * 20.0 + noise(p * 15.0))));
    
    // Create two layers: organic layer based on branch texture and digital glitch layer
    vec3 organicColor = mix(vec3(0.0, 0.2, 0.0), vec3(0.1, 0.5, 0.1), branchTexture);
    vec3 digitalColor = mix(vec3(0.0, 0.0, 0.0), vec3(0.8, 0.2, 0.8), glitch);
    
    // Combine the organic branch layer with digital glitches; glitches appear sporadically.
    vec3 finalColor = mix(organicColor, digitalColor, glitch * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}