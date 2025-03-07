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
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 pos, float amt) {
    float len = length(pos);
    float angle = amt * len;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 gridDisturb(vec2 pos) {
    float grid = step(0.95, abs(sin(pos.y * 30.0 + time * 5.0)) * abs(sin(pos.x * 30.0 + time * 3.0)));
    return vec2(grid * 0.08, grid * 0.08);
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Organic space: fluid patterns with swirling and FBM
    vec2 organicPos = pos;
    organicPos = swirl(organicPos, 3.0 + 2.0 * sin(time));
    float organic = fbm(organicPos * 2.0 + time * 0.3);
    
    // Digital space: grid disturbances and noise-based glitches
    vec2 digitalPos = pos + gridDisturb(pos);
    float digital = noise(digitalPos * 10.0 + time);
    
    // Blend the two conceptual spaces with time modulation
    float blendFactor = 0.5 + 0.5 * sin(time);
    float blended = mix(organic, digital, blendFactor);
    
    // Emergent structure: create a central shape using radial distance and FBM perturbations
    float rad = length(pos);
    float shape = smoothstep(0.5 + 0.1 * blended, 0.48 + 0.1 * blended, rad + 0.3 * fbm(pos * 15.0 + time));
    
    // Color mix: Organic greens and digital blues, further altered by emergent filament effects.
    vec3 organicColor = vec3(0.1, 0.8, 0.3) * organic;
    vec3 digitalColor = vec3(0.2, 0.4, 1.0) * digital;
    vec3 baseColor = mix(organicColor, digitalColor, blendFactor);
    
    float filament = smoothstep(0.4, 0.38, rad + 0.3 * fbm(pos * 15.0 + time));
    vec3 emergentColor = mix(baseColor, vec3(1.0, 0.9, 0.3), filament * 0.7);
    
    emergentColor *= shape;
    
    gl_FragColor = vec4(emergentColor, 1.0);
}