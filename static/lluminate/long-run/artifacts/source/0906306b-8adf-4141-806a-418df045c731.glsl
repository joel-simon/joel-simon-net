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
    float f = 0.0;
    f += 0.5000 * noise(p); p *= 2.02;
    f += 0.2500 * noise(p); p *= 2.03;
    f += 0.1250 * noise(p); p *= 2.01;
    f += 0.0625 * noise(p);
    return f;
}

vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

float mountain(vec2 p) {
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = sin(t * 0.5) * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

void main(void) {
    vec2 pos = (uv - 0.5) * 2.0;
    pos += glitchOffset(pos);
    
    // Organic cosmic swirl by fbm
    float organic = fbm(pos * 3.0 + time * 0.5);
    
    // Mountain silhouette using noise modulation
    float m = mountain(uv);
    float mountainMask = step(uv.y, m);
    
    // Tree branch structure simulating organic growth
    float branch = treeBranch(uv, time);
    
    // Dynamic error bands for glitch aesthetics
    float bands = errorBand(pos);
    
    // Combine directives: honor an old idea of blending error with nature.
    vec3 treeColor = mix(vec3(0.1, 0.5, 0.2), vec3(0.4, 0.25, 0.1), branch);
    vec3 mountainColor = mix(vec3(0.05, 0.05, 0.15), vec3(0.6, 0.4, 0.2), organic);
    vec3 glitchColor = vec3(1.0, 0.9, 0.4) * bands;
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.1, 0.1, 0.2), uv.y);
    
    // Layer elements: base sky, add mountain, overlay tree and glitch error.
    vec3 baseColor = mix(skyColor, mountainColor, mountainMask);
    baseColor = mix(baseColor, treeColor, smoothstep(0.25, 0.35, branch));
    vec3 finalColor = mix(baseColor, glitchColor, 0.5 * bands);
    
    gl_FragColor = vec4(finalColor, 1.0);
}