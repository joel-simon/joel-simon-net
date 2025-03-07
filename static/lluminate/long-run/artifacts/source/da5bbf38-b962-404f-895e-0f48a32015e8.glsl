precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function.
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

// A swirling distortion that "honors error" as hidden intention.
vec2 swirl(vec2 p, float intensity) {
    float angle = intensity * noise(p * 10.0 + time);
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    return rot * (p - 0.5) + 0.5;
}

// Simulate an "error" field to deliberately break patterns.
float errorField(vec2 p) {
    // Inverting noise occasionally to simulate error.
    float n = noise(p * 15.0 - time);
    float glitch = step(0.92, fract(sin(time * 3.0 + p.x * 10.0) * 43758.0));
    return mix(n, 1.0 - n, glitch);
}

void main(void) {
    // Begin with the original UV coordinates.
    vec2 p = uv; 
    
    // Apply swirling distortion to simulate unexpected transformation.
    p = swirl(p, 3.14);
    
    // Create a dynamic "error" band that runs horizontally.
    float errorBand = step(0.3, abs(sin(p.y * 20.0 + time * 2.0)));
    
    // Create a background that shifts with time and error patchwork.
    vec3 bgColor = vec3(0.05, 0.03, 0.08) + vec3(0.1) * errorField(p * 2.0);
    
    // Introduce a digital glitch pattern overlay.
    float glitchLine = smoothstep(0.48, 0.52, fract(p.y * 30.0 + time * 5.0));
    vec3 glitchColor = vec3(0.7, 0.2, 0.5) * glitchLine;
    
    // Combine the background with intentional "error" interventions.
    vec3 finalColor = mix(bgColor, glitchColor, errorBand);
    
    gl_FragColor = vec4(finalColor, 1.0);
}