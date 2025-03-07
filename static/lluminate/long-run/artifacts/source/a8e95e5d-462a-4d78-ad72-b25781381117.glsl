precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function based on sine
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// 2D Noise Function
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

// Fractal Brownian Motion
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Glitch distortion function 
vec2 glitch(vec2 pos) {
    float shift = noise(vec2(pos.y * 8.0, time * 0.3)) - 0.5;
    pos.x += shift * 0.15;
    return pos;
}

void main(void) {
    // Map uv coordinates to a space centered at (0,0)
    vec2 pos = (uv - 0.5) * vec2(2.0, 2.0);
    pos = glitch(pos);
    
    // Creative Strategy:
    // Trait: Adaptability inherent in a chameleon.
    // Symbol: The traditional color palette that signals camouflage.
    // Context: In nature, a chameleon adapts its colors to blend into its surroundings.
    // Replacement: Here, the digital fragments (glitch blocks) dynamically adapt their hues to mimic an organic landscape.
    
    // Create a swirling spiral that radiates a camouflage effect.
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create spiral distortion influenced by time and noise.
    float spiral = sin(angle * 3.0 + time * 1.5 + fbm(pos * 3.0));
    float mask = smoothstep(0.5, 0.4, radius + 0.2 * spiral);
    
    // Color modulation: shifting hues based on angle and noise to mimic adaptive camouflage.
    float hue = mod(angle / 6.283 + 0.5 + fbm(pos * 2.0 + time * 0.5), 1.0);
    vec3 color1 = vec3(0.2, 0.6, 0.3);
    vec3 color2 = vec3(0.8, 0.7, 0.2);
    vec3 color3 = vec3(0.1, 0.1, 0.1);
    
    // Blend colors based on hue and an organic noise factor.
    vec3 camoColor = mix(color1, color2, hue);
    camoColor = mix(camoColor, color3, noise(pos * 4.0) * 0.3);
    
    // Add subtle digital interference lines
    float line = smoothstep(0.03, 0.0, abs(sin(pos.y * 20.0 + time * 3.0)));
    camoColor += vec3(line * 0.15);
    
    // Final blending with spiral mask to enhance the adaptive motif.
    vec3 finalColor = mix(vec3(0.05), camoColor, mask);
    gl_FragColor = vec4(finalColor, 1.0);
}