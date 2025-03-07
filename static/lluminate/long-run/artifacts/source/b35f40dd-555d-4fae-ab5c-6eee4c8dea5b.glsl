precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

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

vec2 glitch(vec2 p) {
    float shift = noise(vec2(p.y * 10.0, time)) * 0.2;
    return vec2(p.x + shift, p.y);
}

float distortedSpiral(vec2 p) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    // Intentional error: mix spiral with abrupt jumps using fract
    float spiral = sin(8.0 * (angle + time) + r * 10.0);
    float glitchFactor = smoothstep(0.2, 0.25, fract(r*5.0 + noise(p*5.0)));
    return abs(spiral) * glitchFactor;
}

void main(void) {
    // Reinterpret the directive: Honor thy error as a hidden intention.
    // Begin with a centered coordinate system.
    vec2 pos = uv - 0.5;
    pos *= 2.0;
    
    // Apply intentional glitch offset.
    pos = glitch(pos);
    
    // Create a base background with distorted spiral structures.
    float spiralEffect = distortedSpiral(pos);
    
    // Create an additional noise layer as a nod to unpredictability.
    float layerNoise = noise(pos * 3.0 + time);
    
    // Combine both with intentional contrast.
    float composite = mix(spiralEffect, layerNoise, 0.5);
    composite = smoothstep(0.3, 0.7, composite);
    
    // Align colors with unexpected divergence.
    vec3 baseColor = mix(vec3(0.2, 0.5, 0.8), vec3(0.9, 0.4, 0.3), composite);
    vec3 errorColor = vec3(noise(pos*10.0 - time), noise(pos*10.0 + time), noise(pos*10.0 + 2.0*time));
    
    // The final color combines the smooth spiral with abrupt errors.
    vec3 finalColor = mix(baseColor, errorColor, 0.4);
    
    gl_FragColor = vec4(finalColor, 1.0);
}