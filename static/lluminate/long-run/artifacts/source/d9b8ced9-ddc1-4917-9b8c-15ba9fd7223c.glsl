precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

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

float cosmicSwirl(vec2 p) {
    // Center the coordinates and add swirling rotation
    vec2 centered = p - vec2(0.5);
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    // Reverse swirl: higher radii spin oppositely
    float swirl = sin(angle * 4.0 - time) * smoothstep(0.4, 0.0, radius);
    // Combine with FBM for organic texture
    float organic = fbm(centered * 8.0 + time);
    return smoothstep(0.2, 0.5, radius + 0.2 * organic + 0.1 * swirl);
}

float branchPattern(vec2 p) {
    // Modify coordinate system to simulate upward branch growth
    vec2 pos = (p - vec2(0.5, 0.2)) * vec2(1.0, 1.8);
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    // Reverse the branch amplitude and adapt frequency
    float branch = abs(sin(theta * 6.0 - time + fbm(pos * 10.0)));
    return smoothstep(0.6, 0.2, r) * branch;
}

void main() {
    vec2 p = uv;
    
    // Base background using a cosmic vortex effect with digital glitch overlays.
    vec3 cosmicBase = mix(vec3(0.0, 0.0, 0.1), vec3(0.2, 0.0, 0.4), p.y);
    float swirlMask = cosmicSwirl(p);
    vec3 cosmicColor = mix(cosmicBase, vec3(0.4, 0.1, 0.6), swirlMask);
    
    // Integrate branch patterns that simulate organic growth with reversed emphasis.
    float branchMask = branchPattern(p);
    vec3 branchColor = mix(cosmicColor, vec3(0.0, 0.5, 0.2), branchMask);
    
    // Add spatial glitch distortions using periodic shifts in UV space.
    vec2 glitchUV = p;
    glitchUV.x += 0.03 * sin(time * 5.0 + p.y * 35.0);
    glitchUV.y += 0.03 * cos(time * 4.0 + p.x * 30.0);
    float glitch = fbm(glitchUV * 15.0 + time);
    float glitchMask = smoothstep(0.45, 0.5, glitch);
    vec3 glitchColor = vec3(0.9, 0.9, 1.0) * glitchMask;
    
    // Final mix: cosmic base, reversed branch pattern, and digital glitch.
    vec3 finalColor = mix(branchColor, glitchColor, 0.25);
    
    gl_FragColor = vec4(finalColor, 1.0);
}