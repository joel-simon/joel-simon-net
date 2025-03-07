precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
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
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 glitchOffset(vec2 pos) {
    float glitch = noise(vec2(floor(pos.y * 25.0), time));
    return vec2(glitch * 0.08, 0.0);
}

float treeBranch(vec2 pos, float t) {
    float angle = atan(pos.y, pos.x);
    float branch = sin(angle * 3.5 + t * 2.0) * 0.25;
    float dist = length(pos);
    return smoothstep(0.45 + branch, 0.43 + branch, dist);
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    pos += glitchOffset(pos);
    
    // Transform to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Medium-distant concept: combine cosmic swirl with subtle tree branch structures.
    float branches = treeBranch(pos, time);
    
    // Organic cosmic background using fbm with polar distortion.
    float fbmValue = fbm(pos * 3.0 + time * 0.3);
    float cosmicSwirl = smoothstep(0.55, 0.53, radius + 0.15 * sin(angle * 5.0 + time));
    
    // Integrate medium association by blending fbm and branches.
    float blend = mix(fbmValue, branches, 0.5);
    
    // Color palettes: deep forest green merging into luminous nebula tones.
    vec3 forest = vec3(0.1, 0.5, 0.2);
    vec3 nebula = vec3(0.8, 0.4, 1.0);
    vec3 baseColor = mix(forest, nebula, blend);
    
    // Add ripple effect along the radial direction to enhance glitch aesthetic.
    float ripple = abs(sin(10.0 * (radius - time)));
    vec3 glitchColor = mix(baseColor, vec3(1.0, 0.9, 0.3), ripple * 0.5);
    
    // Final composition with smooth cosmic swirl influence.
    vec3 finalColor = mix(glitchColor, vec3(0.05, 0.05, 0.1), cosmicSwirl);
    
    gl_FragColor = vec4(finalColor, 1.0);
}