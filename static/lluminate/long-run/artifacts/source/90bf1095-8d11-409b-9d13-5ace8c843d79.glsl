precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random numbers
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// 2D noise function based on hash
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

// Fractal Brownian Motion: builds complexity over noise
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

// Organic branch structure function: in this creative shader,
// we replace the traditional clock hands with tree branches, symbolizing 
// the essential trait of "growth" in a context where time is usually measured by clock hands.
float treeBranch(vec2 p) {
    // Center the coordinate system
    vec2 pos = (p - 0.5) * vec2(1.0, 1.2);
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Branch oscillations, using time to simulate organic swaying
    float branchOsc = sin(angle * 4.0 + time) * 0.5 + 0.5;
    
    // Use fbm to generate branch texture and complexity
    float branchDetail = fbm(pos * 6.0 + time*0.5);
    
    // Emulate clock hand lengths that now represent tree growth:
    float branch = smoothstep(0.4, 0.38, abs(radius - (branchOsc * 0.35 + branchDetail * 0.1)));
    return branch;
}

// Digital distortion effect: to mix organic features with digital glitch
float digitalGlitch(vec2 p) {
    vec2 glitch = p;
    glitch.x += 0.03 * sin(time * 3.5 + p.y * 25.0);
    glitch.y += 0.03 * cos(time * 4.2 + p.x * 30.0);
    return fbm(glitch * 10.0 + time);
}

void main() {
    vec2 p = uv;
    
    // Base background gradient: blending cool digital tones with warm organic hues.
    vec3 digitalBase = vec3(0.15, 0.25, 0.45);
    vec3 organicBase = vec3(0.2, 0.55, 0.3);
    vec3 bgColor = mix(digitalBase, organicBase, p.y);
    
    // Compute our organic branch structure ("clock hands" replaced by branches)
    float branchStructure = treeBranch(p);
    
    // Compute digital glitch influence
    float glitchEffect = digitalGlitch(p);
    
    // Create a color gradient along the branch structures: from earthy brown to vibrant green.
    vec3 branchColor = mix(vec3(0.3, 0.2, 0.1), vec3(0.1, 0.6, 0.2), branchStructure);
    
    // Digital overlay that subtly distorts the organic branch, enhancing the theme of growth amid digital decay.
    vec3 digitalOverlay = vec3(0.8, 0.85, 1.0) * smoothstep(0.45, 0.48, glitchEffect);
    
    // Combine organic branches with the digital backdrop.
    vec3 combined = mix(bgColor, branchColor, branchStructure);
    combined += digitalOverlay;
    
    gl_FragColor = vec4(combined, 1.0);
}