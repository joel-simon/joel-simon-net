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
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
    float f = 0.0;
    f += 0.5 * noise(p); p *= 2.0;
    f += 0.25 * noise(p); p *= 2.0;
    f += 0.125 * noise(p); p *= 2.0;
    f += 0.0625 * noise(p);
    return f;
}

vec2 gridDisturb(vec2 pos) {
    // Create abrupt digital grid artifacts.
    float grid = step(0.95, abs(sin(pos.y * 30.0 + time * 5.0)) * abs(sin(pos.x * 30.0 + time * 3.0)));
    return vec2(grid * 0.08, grid * 0.08);
}

void main(void) {
    // Map uv to space centered at 0
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Conceptual Space A: Organic, fluid patterns (using fbm and swirling)
    vec2 organicPos = pos;
    float swirl = sin(organicPos.x * 3.0 + time) * 0.5;
    organicPos.y += swirl;
    float organic = fbm(organicPos * 2.0 + time * 0.3);
    
    // Conceptual Space B: Digital grid and glitch artifacts
    vec2 digitalPos = pos;
    digitalPos += gridDisturb(digitalPos);
    float digital = noise(digitalPos * 10.0 + time);
    
    // Map cross-space correspondences (blend characteristics)
    float blended = mix(organic, digital, 0.5 + 0.5 * sin(time));
    
    // Develop emergent structure: create a central form with layered shapes
    float rad = length(pos);
    float emergentShape = smoothstep(0.5 + 0.1 * blended, 0.48 + 0.1 * blended, rad);
    
    // Colors: organic greens and digital blues merged to give a new emergent cyan tone
    vec3 organicColor = vec3(0.1, 0.8, 0.3) * organic;
    vec3 digitalColor = vec3(0.2, 0.4, 1.0) * digital;
    vec3 blendedColor = mix(organicColor, digitalColor, 0.5 + 0.5 * sin(time * 1.3));
    
    // Additional emergent detail: filament glitches modulated by fbm in the blend space
    float filament = smoothstep(0.4, 0.38, rad + 0.3 * fbm(pos * 15.0 + time));
    vec3 finalColor = mix(blendedColor, vec3(1.0, 0.9, 0.3), filament * 0.7);
    
    // Mask by emergent shape for structure
    finalColor *= emergentShape;
    
    gl_FragColor = vec4(finalColor, 1.0);
}