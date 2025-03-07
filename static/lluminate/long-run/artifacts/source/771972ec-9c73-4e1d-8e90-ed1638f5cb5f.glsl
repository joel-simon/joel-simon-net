precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(27.619, 57.583))) * 43758.5453123);
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
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 organicSwirl(vec2 p, float strength) {
    p -= 0.5;
    float r = length(p);
    float angle = atan(p.y, p.x) + strength * exp(-r * 3.0);
    vec2 rotated = vec2(cos(angle), sin(angle)) * r;
    return rotated + 0.5;
}

vec2 digitalGlitch(vec2 p) {
    float glitch = noise(vec2(p.y * 20.0 + time, p.x * 20.0 - time));
    p.x += glitch * 0.05;
    p.y += noise(vec2(p.x * 30.0, time * 2.0)) * 0.05;
    return p;
}

float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - angle * 4.0 + t * 2.0);
    float intensity = exp(-3.0 * r);
    return smoothstep(0.25, 0.4, abs(wave) * intensity);
}

float glitchBands(vec2 p) {
    float band = sin(p.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

void main(void) {
    vec2 pos = uv;
    
    // Apply digital offset based on glitch noise function.
    vec2 glitchUV = digitalGlitch(pos);
    
    // Create an organic swirl effect.
    vec2 swirlUV = organicSwirl(pos, 2.5 * sin(time * 0.7));
    
    // Generate an organic texture using fbm.
    float organicTexture = fbm(uv * 6.0 + time * 0.3);
    
    // Generate a digital cosmic texture by using fbm and glitch manipulation.
    float digitalTexture = fbm(glitchUV * 4.0 - time * 0.5);
    
    // Simulate tree branch elements as organic structures.
    float branchPattern = treeBranch(uv, time);
    float branchSwirl = treeBranch(swirlUV, time);
    float branchFinal = mix(branchPattern, branchSwirl, 0.5);
    
    // Generate glitch bands to overlay digital artifact.
    float bands = glitchBands(glitchUV);
    
    // Color blending: organic warm tones with digital cool glitches.
    vec3 organicColor = mix(vec3(0.8, 0.55, 0.2), vec3(0.2, 0.6, 0.3), branchFinal);
    vec3 digitalColor = mix(vec3(0.0, 0.2, 0.5), vec3(0.1, 0.5, 0.7), digitalTexture);
    vec3 background = mix(vec3(0.05, 0.05, 0.1), vec3(0.02, 0.02, 0.1), uv.y);
    
    float blendFactor = smoothstep(0.3, 0.7, sin(time) * 0.5 + 0.5);
    vec3 mergedColor = mix(organicColor, digitalColor, blendFactor);
    
    // Combine the background with merged organic/digital visuals.
    vec3 color = mix(background, mergedColor, 0.7);
    
    // Overlay subtle glitch highlights.
    color = mix(color, vec3(1.0), bands * 0.15);
    
    gl_FragColor = vec4(color, 1.0);
}