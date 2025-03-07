precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    vec2 p = uv;
    
    // Cryptic directive: "Honor thy error as a hidden intention"
    // Introduce intentional "errors" by using random variations and glitches.
    float glitchThreshold = 0.98;
    float glitchFactor = random(vec2(time, p.y)) + 0.1 * sin(time + p.x * 50.0);
    float glitchMask = step(glitchThreshold, glitchFactor);
    
    // Create a polar coordinate base with a swirling distortion.
    vec2 center = vec2(0.5);
    vec2 rel = p - center;
    float angle = atan(rel.y, rel.x);
    float radius = length(rel);
    
    // Apply a swirl based on angle, frequency from error, and time.
    float swirl = sin(angle * 5.0 + time * 2.0) * 0.1;
    radius += swirl;
    
    // Generate a shifted UV coordinate based on polar transformation.
    vec2 newUV = center + radius * vec2(cos(angle), sin(angle));
    
    // Base color is a dynamic gradient modulated by the functional swirl.
    vec3 baseColor = vec3(newUV, 0.5 + 0.5 * sin(time));
    
    // Introduce color "errors": Where the glitch mask is active, overlay an unexpected red tint.
    vec3 errorColor = vec3(1.0, 0.0, 0.0);
    vec3 finalColor = mix(baseColor, errorColor, glitchMask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}