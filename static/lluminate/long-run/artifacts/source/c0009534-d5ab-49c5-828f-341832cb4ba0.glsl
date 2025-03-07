precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), 
                   hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), 
                   hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float flameShape(vec2 p) {
    // Transform coordinate system for the flame.
    // Normalize the coordinates to center at bottom.
    p.y += 0.5;
    // Apply a vertical stretch to elongate the flame.
    p.y *= 1.8;
    
    // Base flame using an implicit heart-like shape formula, inverted
    float base = 1.0 - length(p);
    
    // Introduce flickering distortions with noise.
    float n = noise(p * 4.0 - time * 2.0);
    n = smoothstep(0.3, 0.7, n);
    
    // Combine the base shape with noise for dynamic boundaries.
    float flame = smoothstep(0.0, 0.05, base + 0.3 * n);
    return flame;
}

void main() {
    // Map uv coords from 0 to 1 to -1 to 1.
    vec2 st = uv * 2.0 - 1.0;
    
    // Background: create a stormy, cool context with swirling patterns.
    float angle = atan(st.y, st.x);
    float radius = length(st);
    float storm = sin(10.0 * radius - time*1.5 + angle);
    float backgroundNoise = noise(st * 3.0 + time);
    float bgMix = mix(storm, backgroundNoise, 0.6);
    vec3 bgColor = mix(vec3(0.0, 0.0, 0.1), vec3(0.05, 0.1, 0.2), bgMix);
    
    // Creative Strategy:
    // Trait: Passion
    // Symbol traditionally used: Heart
    // Context: In a cold, stormy environment, passion is essential to provide warmth.
    // Here, we replace the heart with a flame shape that dynamically flickers.
    vec2 flameCoord = st;
    // Slight vertical offset to position the flame lower.
    flameCoord.y -= 0.2;
    float flame = flameShape(flameCoord);
    
    // Color for the flame: warm gradient from deep red to bright yellow.
    vec3 flameColor = mix(vec3(0.8, 0.2, 0.1), vec3(1.0, 0.9, 0.3), flame);
    
    // Merge the flame with the background according to its silhouette.
    vec3 finalColor = mix(bgColor, flameColor, flame);
    
    gl_FragColor = vec4(finalColor, 1.0);
}