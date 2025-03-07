precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
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

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

void main(void) {
    // Re-map uv to center space [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Conceptual space A: Organic fractal growth (like tree branches)
    float organic = fbm(pos * 3.0 + time * 0.3);
    // Thicken structure through a smoothstep 
    float treeStructure = smoothstep(0.4, 0.42, organic);

    // Conceptual space B: Digital glitch patterns
    float glitchLines = step(0.8, fract(pos.y * 10.0 + time * 4.0));
    float glitchNoise = noise(pos * 20.0 - time * 2.0);
    float digital = mix(glitchLines, glitchNoise, 0.5);

    // Map similarities: both use noise, now blend selectively
    float emergent = mix(treeStructure, digital, 0.5 + 0.5 * sin(time + pos.x * 3.1415));

    // Introduce emergent radial distortion structure: blend polar coordinate info
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float radialWarp = 0.5 + 0.5 * sin(angle * 5.0 + time * 3.0);
    emergent *= smoothstep(0.8, 0.3, r * radialWarp);

    // Create a color gradient combining natural earth tones with neon glitch tints
    vec3 organicColor = vec3(0.2, 0.6, 0.3);
    vec3 digitalColor = vec3(0.8, 0.2, 0.7);
    vec3 blendedColor = mix(organicColor, digitalColor, emergent);

    // Add subtle vignette
    blendedColor *= smoothstep(1.0, 0.3, r);

    gl_FragColor = vec4(blendedColor, 1.0);
}