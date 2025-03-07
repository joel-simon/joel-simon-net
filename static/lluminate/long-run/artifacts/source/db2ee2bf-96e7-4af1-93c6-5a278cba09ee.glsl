precision mediump float;
varying vec2 uv;
uniform float time;

// Simple 2D hash noise function.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 41.0))) * 103.1);
}

// 2D noise.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion.
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Digital glitch offset.
vec2 digitalGlitch(vec2 pos, float t) {
    float glitch = step(0.8, fract(sin(dot(pos, vec2(23.0, 47.0))) * 98.0 + t));
    pos.x += glitch * 0.07 * sin(t*5.0);
    pos.y += glitch * 0.07 * cos(t*5.0);
    return pos;
}

// Organic vortex effect blending with digital artifact.
// Merges swirling organic distortion and overlaying fractal texture.
vec2 organicVortex(vec2 pos, float t) {
    vec2 centered = pos - 0.5;
    float angle = fbm(centered * 4.0 + t) * 3.1416;
    float s = sin(angle);
    float c = cos(angle);
    centered = vec2(c * centered.x - s * centered.y, s * centered.x + c * centered.y);
    return centered + 0.5;
}

// Emergent blend: Maps two different conceptual spaces, one organic (fbm swirl)
// and one digital (grid noise) into a new emergent structure.
vec3 emergentBlend(vec2 pos, float t) {
    // Organic space: soft swirling gradients and fractal noise.
    float organic = fbm(pos * 3.0 + t * 0.5);
    vec3 organicColor = mix(vec3(0.2, 0.5, 0.3), vec3(0.1, 0.8, 0.4), organic);
    
    // Digital space: grid-like noise with sharp contrast.
    vec2 grid = fract(pos * 20.0 + t);
    float digital = step(0.95, hash(pos*3.0 + vec2(t)));
    vec3 digitalColor = mix(vec3(0.05,0.05,0.2), vec3(0.5,0.9,1.0), digital);
    
    // Blend using a non-linear mix influenced by distance from center.
    float mixFactor = smoothstep(0.2, 0.6, length(pos-0.5));
    return mix(organicColor, digitalColor, mixFactor);
}

void main(void){
    // Step 1: Clean input coordinate.
    vec2 pos = uv;
    
    // Step 2: Apply digital glitch distortions.
    pos = digitalGlitch(pos, time);
    
    // Step 3: Introduce organic vortex transform.
    vec2 vortexPos = organicVortex(pos, time);
    
    // Step 4: Emergent synthesis from blended conceptual spaces.
    vec3 emergent = emergentBlend(vortexPos, time);
    
    // Step 5: Introduce slight radial darkening for depth.
    vec2 centered = uv - 0.5;
    float vignette = smoothstep(0.8, 0.4, length(centered));
    emergent *= vignette;
    
    gl_FragColor = vec4(emergent, 1.0);
}