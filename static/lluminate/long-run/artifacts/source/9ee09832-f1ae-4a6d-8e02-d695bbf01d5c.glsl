precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
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
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

vec2 errorGlitch(vec2 pos) {
    float glitch = step(0.95, fract(sin(dot(pos.xy, vec2(12.9898,78.233))) * 43758.5453 + time));
    float offset = glitch * (noise(pos * 20.0 + time) - 0.5) * 0.15;
    return pos + vec2(offset, 0.0);
}

float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-6.0 * r);
    return smoothstep(0.2, 0.31, abs(wave) * trunk);
}

float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

void main(void) {
    vec2 pos = uv;
    
    // Apply glitch offsets to create digital disturbance.
    pos += glitchOffset(pos);
    pos = errorGlitch(pos);

    // Create a swirled coordinate for organic chaos.
    vec2 swirledPos = swirl(pos - 0.5, 3.0 * sin(time * 0.8)) + 0.5;
    
    // Polar transformation for vortex effect.
    vec2 centered = (uv - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float vortex = sin(angle * 6.0 + time * 2.0 + fbm(centered * 3.0)) * 0.3;
    float mask = smoothstep(0.7 + vortex, 0.68 + vortex, radius);

    // Organic branch patterns from static and swirled coordinates.
    float branch1 = treeBranch(uv, time);
    float branch2 = treeBranch(swirledPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Noise textures for organic irregularity.
    float n1 = noise(uv * 5.0 + time);
    float n2 = noise(swirledPos * 10.0 - time);
    float organicTexture = fbm(uv * 4.0 + time);
    
    // Gridded glitch effect overlay.
    float grid = sin((uv.x + time) * 10.0) * sin((uv.y - time) * 10.0);
    grid = smoothstep(0.2, 0.25, abs(grid));
    
    // Color schemes:
    vec3 cosmic = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.1, 0.25), radius);
    vec3 starColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), n2);
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    vec3 glitchColor = vec3(0.0, 0.8, 0.5) * abs(sin(time * 3.0 + angle));

    // Blend color dynamics from cosmic, glitch, tree, and noise.
    vec3 colorMix = mix(cosmic, glitchColor, organicTexture);
    colorMix = mix(colorMix, starColor, smoothstep(0.15, 0.35, branchPattern + n1 * 0.2));
    colorMix = mix(colorMix, treeColor, 0.3);
    colorMix = mix(colorMix, vec3(0.8, 0.8, 0.8), grid * 0.5);
    
    // Final blend with vortex mask for emergent effect.
    vec3 finalColor = colorMix * mask;

    gl_FragColor = vec4(finalColor, 1.0);
}