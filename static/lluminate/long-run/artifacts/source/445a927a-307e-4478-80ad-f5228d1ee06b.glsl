precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 13758.5453);
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
    float total = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++){
        total += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return total;
}

vec2 glitchDisplace(vec2 pos, float t) {
    float shift = hash(pos + t) * 0.1;
    return pos + vec2(shift, -shift);
}

vec2 spiralTransform(vec2 pos, float strength) {
    vec2 centered = pos - 0.5;
    float angle = atan(centered.y, centered.x) + strength * length(centered);
    float radius = length(centered);
    return vec2(cos(angle), sin(angle)) * radius + 0.5;
}

float organicGrowth(vec2 pos) {
    vec2 p = pos * 6.0 - vec2(3.0);
    float d = length(p);
    float branch = sin(p.x * 4.0 + time) * cos(p.y * 4.0 + time);
    float mask = smoothstep(1.5, 2.0, d);
    return branch * (1.0 - mask);
}

vec3 starField(vec2 pos) {
    float stars = step(0.98, fract(sin(dot(pos.xy, vec2(12.9898,78.233))) * 43758.5453));
    return vec3(stars);
}

void main(void) {
    vec2 pos = uv;
    
    // Apply glitch displacement intermittently
    pos = glitchDisplace(pos, time);
    
    // Use spiral transformation for galactic-like swirling
    vec2 spiralPos = spiralTransform(pos, sin(time * 0.5) * 0.8);
    
    // Organic branch-like growth layer via fbm and sine modulation
    float growth = fbm(pos * 3.0 + time * 0.7);
    float branchEffect = organicGrowth(pos);
    
    // Create contrasting star field digital overlay
    vec3 stars = starField(uv * 40.0 + vec2(time * 0.1));
    
    // Mix organic texture with swirling digital glitch artifact
    vec3 organicColor = mix(vec3(0.1, 0.6, 0.3), vec3(0.4, 0.8, 0.5), growth);
    vec3 glitchColor = mix(vec3(0.2, 0.1, 0.3), vec3(0.7, 0.9, 1.0), fbm(spiralPos * 5.0 - time));
    vec3 mixedLayer = mix(organicColor, glitchColor, 0.5 + 0.5 * branchEffect);
    
    // Blend with star field for subtle digital sparkle
    vec3 finalColor = mix(mixedLayer, stars, 0.2);
    
    gl_FragColor = vec4(finalColor, 1.0);
}