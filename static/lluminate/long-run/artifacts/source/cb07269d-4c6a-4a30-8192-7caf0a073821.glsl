precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for randomness
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// 2D noise from hash
float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion based on noise
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

// Organic tree vein-like structure inspired function
float treeVein(vec2 p) {
    p = (p - vec2(0.5, 0.2)) * vec2(1.0, 1.5);
    float r = length(p);
    float angle = atan(p.y, p.x);
    float growth = smoothstep(0.0, 0.5, p.y);
    float branch = abs(sin(angle * 5.0 + time + fbm(p * 8.0)*3.0));
    float taper = smoothstep(0.5, 0.2, r);
    return growth * branch * taper;
}

// Vortex / eye effect function
float vortexEffect(vec2 p) {
    vec2 pos = p * 2.0 - 1.0; // remap uv to [-1,1]
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float vortex = sin(10.0 * radius - time * 2.5 + angle * 2.0);
    float pupil = smoothstep(0.28, 0.26, abs(radius - 0.4 - 0.05 * vortex));
    return pupil;
}

void main() {
    vec2 p = uv;
    
    // Background gradient merging digital and organic tones.
    vec3 digitalColor = vec3(0.1, 0.3, 0.5);
    vec3 organicColor = vec3(0.1, 0.5, 0.2);
    vec3 bgColor = mix(digitalColor, organicColor, p.y);

    // Add digital glitch distortion to UV coordinates.
    vec2 glitchUV = p;
    glitchUV.x += 0.02 * sin(time * 3.0 + p.y * 20.0);
    glitchUV.y += 0.02 * cos(time * 4.0 + p.x * 25.0);
    float glitch = fbm(glitchUV * 12.0 + time);

    // Compute tree vein structure.
    float treeStructure = treeVein(p);
    
    // Compute vortex effect for central eye-like feature.
    float eye = vortexEffect(p);
    
    // Blend the background with the tree structure.
    vec3 treeColor = mix(bgColor, vec3(0.0, 0.4, 0.1), treeStructure);
    
    // Create dynamic color gradient with digital distortion.
    vec3 warmColor = vec3(1.0, 0.4, 0.2);
    vec3 coolColor = vec3(0.2, 0.5, 1.0);
    float angle = atan(p.y - 0.5, p.x - 0.5);
    vec3 colorGradient = mix(warmColor, coolColor, (sin(angle + time) + 1.0) * 0.5);

    // Merge vortex 'eye' effect in the center with organic tree veins.
    vec3 combined = mix(treeColor, colorGradient, eye);
    
    // Overlay glitch flashes.
    float flash = smoothstep(0.4, 0.42, glitch);
    vec3 flashColor = vec3(0.8, 0.8, 1.0) * flash;
    
    vec3 finalColor = combined + flashColor;
    
    gl_FragColor = vec4(finalColor, 1.0);
}