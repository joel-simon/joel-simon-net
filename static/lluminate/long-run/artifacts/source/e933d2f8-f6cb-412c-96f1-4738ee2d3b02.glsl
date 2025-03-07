precision mediump float;
varying vec2 uv;
uniform float time;

// Random function based on coordinate input
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

// Rotate a 2D vector by an angle
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Heart shape function using modified polar coordinates
float heartShape(vec2 p, vec2 center, float scale) {
    vec2 pos = (p - center) * 2.0;
    pos.x *= 1.2;
    float a = atan(pos.x, pos.y);
    float r = length(pos);
    // Heart implicit function with slight oscillation via time
    float h = pow(r, 0.5) - 0.5 * sin(a * 3.0 + time);
    return smoothstep(scale, scale - 0.01, h);
}

// Glitch pattern function introducing digital artifacts
float glitchPattern(vec2 p) {
    vec2 gp = p * 10.0;
    float wave = sin(gp.x + time) * cos(gp.y - time);
    float glitch = step(0.0, fract(sin(dot(gp, vec2(12.9898,78.233)))*43758.5453) - 0.5);
    return abs(wave) * glitch;
}

// Dynamic swirling background using polar coordinates and radial distortions
float dynamicSpiral(vec2 p, float t) {
    vec2 centered = p - 0.5;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float spiral = sin(angle * 6.0 + t + radius * 20.0);
    return smoothstep(0.4, 0.41, abs(spiral) * radius);
}

void main() {
    vec2 p = uv;
    vec2 center = vec2(0.5, 0.5);
    
    // Base dynamic background with swirling spiral for conceptual transformation of a classic symbol
    float spiralEffect = dynamicSpiral(p, time);
    vec3 bgColor = mix(vec3(0.05, 0.02, 0.1), vec3(0.2, 0.1, 0.35), spiralEffect);
    
    // Create an impression of a sturdy tree (symbol for growth) replacing the traditional heart
    // The heart shape function here is repurposed to evoke a branching organic structure.
    float heartMask = heartShape(p + 0.02 * vec2(cos(time), sin(time)), center, 0.45);
    
    // Add glitch effects to emphasize the dynamic, digital reinterpretation
    float glitch = glitchPattern(p + vec2(sin(time), cos(time)) * 0.02);
    
    // Mix the heart mask with glitch elements to generate a layered effect
    float mask = clamp(heartMask + 0.3 * glitch, 0.0, 1.0);
    
    // Replace the traditional heart representation with an abstract tree-like form;
    // dynamic colors reflect nurturing growth and organic complexity.
    vec3 treeColor = mix(vec3(0.2, 0.5, 0.3), vec3(0.1, 0.7, 0.4), uv.y + 0.2 * sin(time * 2.0));
    
    // Combine the background with the layered abstract structure
    vec3 finalColor = mix(bgColor, treeColor, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}