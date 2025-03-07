precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float smoothNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = pseudoNoise(i);
    float b = pseudoNoise(i + vec2(1.0, 0.0));
    float c = pseudoNoise(i + vec2(0.0, 1.0));
    float d = pseudoNoise(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0, amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * smoothNoise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 polarTransform(vec2 p) {
    p -= 0.5;
    float radius = length(p);
    float angle = atan(p.y, p.x);
    angle += sin(radius * 10.0 - time * 3.0) * 0.5;
    return vec2(cos(angle), sin(angle)) * radius + 0.5;
}

vec2 glitchOffset(vec2 p) {
    float glitch = smoothNoise(vec2(time * 0.5, p.y * 10.0));
    p.x += glitch * 0.05;
    return p;
}

// In this shader, the chameleon—a symbol of adaptability—is replacing the classic digital glitch.
// Here, adaptability is essential for camouflage. The "chameleon mode" is simulated via
// adaptive color blending informed by evolving organic noise.

void main(void) {
    vec2 pos = uv;
    
    // Apply polar distortion to simulate organic swirling growth.
    vec2 organicPos = polarTransform(pos);
    
    // Digital glitch is simulated by offsetting UV coordinates.
    vec2 glitchPos = glitchOffset(pos);
    
    // Compute organic evolution with FBM noise.
    float organicEvolution = fbm(organicPos * 4.0 + time * 0.2);
    
    // Digital interference from glitch noise.
    float digitalInterference = fbm(glitchPos * 12.0 - time * 0.3);
    
    // Replace the digital indicator with our "chameleon" adaptive pattern:
    // Adaptability is displayed by blending organic evolution with interference.
    float adaptiveBlend = mix(organicEvolution, digitalInterference, 0.4);
    
    // Color palette: earthy tones modulated by adaptive blend simulate a chameleon in camouflage.
    vec3 baseColor = mix(vec3(0.1, 0.25, 0.1), vec3(0.4, 0.6, 0.3), organicEvolution);
    vec3 glitchColor = mix(vec3(0.0, 0.1, 0.2), vec3(0.2, 0.1, 0.3), digitalInterference);
    vec3 finalColor = mix(baseColor, glitchColor, adaptiveBlend);
    
    // Accentuate with light digital interference flashes.
    finalColor += vec3(pseudoNoise(pos * 100.0 + time)) * 0.04;
    
    gl_FragColor = vec4(finalColor, 1.0);
}