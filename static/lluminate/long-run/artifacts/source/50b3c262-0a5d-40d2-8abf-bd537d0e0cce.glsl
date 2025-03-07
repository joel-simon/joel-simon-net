precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 43758.5453);
}

void main() {
    // Reverse assumption: Instead of continuously evolving patterns, our shader reveals hidden order within apparent randomness.
    // The design employs static symmetry and repetitive interference, challenging the notion that movement is essential for intrigue.
    
    // Center the UV and create a tiled coordinate system.
    vec2 centered = uv - 0.5;
    vec2 tile = fract(centered * 10.0 + 0.5) - 0.5;
    
    // Compute a symmetric interference pattern by combining sine functions in both dimensions.
    float interference = sin(10.0 * tile.x) * sin(10.0 * tile.y);
    
    // Use pseudo noise to subtly offset the interference pattern.
    float noise = pseudoNoise(tile * 5.0 + time * 0.2);
    
    // Reverse the typical role of time: instead of driving dynamic movement, time here adjusts the balance between order and randomness.
    float blendFactor = smoothstep(0.3, 0.7, interference + noise * 0.5);
    
    // Invert the classical color gradients by swapping calm and vivid hues.
    vec3 calmColor = vec3(0.9, 0.95, 1.0);
    vec3 vividColor = vec3(0.2, 0.3, 0.5);
    
    // Mix colors based on the reversed layout of interference
    vec3 color = mix(vividColor, calmColor, blendFactor);
    
    gl_FragColor = vec4(color, 1.0);
}