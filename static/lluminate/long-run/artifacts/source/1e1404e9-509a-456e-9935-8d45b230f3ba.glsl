precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Function to create a digital glitch effect via sharp noise thresholds
float glitch(vec2 p, float t) {
    float g = noise(p * 10.0 + t);
    g = step(0.8, g);
    return g;
}

// Function to generate swirling organic patterns using sine waves on polar coordinates
float swirl(vec2 p, float t) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float twist = sin(radius * 12.0 - t * 2.0 + angle * 4.0);
    return smoothstep(0.3 + twist * 0.05, 0.31 + twist * 0.05, radius);
}

void main(void) {
    // Normalize and center uv coordinates to range [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a slow rotation on the coordinate space for dynamic movement
    float angle = time * 0.4;
    mat2 rotate = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rotate * pos;
    
    // Compute the digital glitch effect
    float glitchComponent = glitch(pos, time);
    
    // Compute the swirling organic pattern effect
    float swirlComponent = swirl(pos, time);
    
    // Blend the digital glitch and the swirling pattern with a bias
    float blendFactor = mix(swirlComponent, glitchComponent, 0.6);
    
    // Create a background gradient based on uv coordinates
    vec3 bgColor = mix(vec3(0.05, 0.1, 0.15), vec3(0.25, 0.3, 0.35), uv.y);
    
    // Define colors for the glitch (neon cyan) and the swirling pattern (warm earthy tone)
    vec3 glitchColor = vec3(0.0, 1.0, 1.0) * glitchComponent;
    vec3 swirlColor = vec3(0.8, 0.5, 0.3) * swirlComponent;
    
    // Mix the two color looks based on the blend factor
    vec3 emergentColor = mix(swirlColor, glitchColor, blendFactor);
    
    // Introduce subtle time-based pulsation for a dynamic final color
    vec3 finalColor = mix(bgColor, emergentColor, smoothstep(0.2, 0.8, blendFactor) + 0.1 * sin(time));
    
    gl_FragColor = vec4(finalColor, 1.0);
}