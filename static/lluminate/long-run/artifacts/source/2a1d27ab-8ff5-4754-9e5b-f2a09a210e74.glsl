precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

vec3 combineNoise(vec2 p, float t) {
    float n1 = rand(p + t);
    float n2 = rand(p * 2.0 - t);
    float n3 = rand(p * 4.0 + vec2(t, -t));
    return vec3(n1, n2, n3);
}

void main() {
    vec2 centered = uv - 0.5;
    
    // Base concept: a swirling digital vortex.
    // Operation: Reverse view and Modify the swirls.
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    
    // Create a reversed swirl pattern using time and angle.
    float swirl = sin(8.0 * (1.0 - radius) + time * 3.0 + angle * -4.0);
    
    // Operation: Combine organic noise with digital distortions.
    vec3 noise = combineNoise(centered * 5.0, time);
    
    // Blend between a warm color base and a cool digital interference.
    vec3 warmBase = vec3(0.9, 0.6, 0.3) * (1.0 - radius);
    vec3 coolBase = vec3(0.2, 0.5, 1.0) * radius;
    vec3 baseColor = mix(warmBase, coolBase, radius);
    
    // Introduce swirling modulation and blend against digital noise.
    float modulate = smoothstep(0.3, 0.7, swirl * radius);
    vec3 colorMix = mix(baseColor, noise, modulate * 0.35);
    
    // Refine the look with a peripheral darkening effect.
    float vignette = smoothstep(0.6, 0.2, radius);
    vec3 finalColor = colorMix * vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}