precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random generator using sine and dot product
float random (in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Digital glitch function that disrupts expected smooth gradients, reversing organic norms.
vec3 glitchScene(vec2 pos, float t) {
    // Begin with a base of vibrant digital colors.
    vec3 colorA = vec3(0.0, 0.8, 0.9);
    vec3 colorB = vec3(0.9, 0.2, 0.4);
    vec3 colorC = vec3(0.2, 0.4, 0.9);
    
    // Introduce digital noise that disrupts continuous organic forms.
    float noise = random(pos * 20.0 + t);
    
    // Reverse expectation: instead of smooth transition, use abrupt glitch lines.
    float glitch = step(0.92, fract(sin(dot(pos.xy, vec2(31.7, 47.3)) * 100.0 + t)));
    
    // Create swirling interference by distorting positional coordinates.
    float angle = t * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    vec2 distorted = rot * (pos - 0.5);
    float swirl = sin(10.0 * length(distorted) - t * 5.0);
    
    // Mix colors based on strange digital interference
    vec3 mixedColor = mix(colorA, colorB, abs(swirl));
    mixedColor = mix(mixedColor, colorC, noise);
    
    // Apply glitch effect: parts will randomly invert colors.
    mixedColor = mix(mixedColor, vec3(1.0) - mixedColor, glitch);
    
    // Enhance overall digital feel with additional noise-based contrast.
    mixedColor *= smoothstep(0.3, 0.7, noise);
    
    return mixedColor;
}

void main() {
    // Reverse assumption of organic, gentle growth: instead, an unpredictable digital flux dominates.
    vec2 pos = uv;
    
    // Introduce mild zoom and pan to emphasize disorientation.
    pos = (pos - 0.5) * (1.0 + 0.4 * sin(time)) + 0.5;
    
    vec3 color = glitchScene(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}