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
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 10.0, time));
    return p + vec2(n * 0.05, 0.0);
}

float organicWave(vec2 p) {
    vec2 center = vec2(0.5, 0.5);
    vec2 d = p - center;
    float dist = length(d);
    float angle = atan(d.y, d.x);
    float wave = smoothstep(0.28, 0.32, abs(dist - 0.3 - 0.05 * sin(angle * 3.0 + time)));
    return wave;
}

float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = sin(t * 0.5) * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - 4.0 * a + t * 2.0);
    float trunk = exp(-10.0 * r);
    float branch = smoothstep(0.2, 0.3, abs(wave) * trunk);
    return branch;
}

void main(){
    vec2 p = uv;
    
    // Background gradient with fbm noise integration
    vec3 sky = mix(vec3(0.0, 0.0, 0.2), vec3(0.05, 0.05, 0.1), p.y);
    float n = fbm(p * 3.0 + time);
    vec3 bg = sky + 0.1 * vec3(n, n * 0.8, n * 0.6);
    
    // Organic swirling wave component
    float organic = organicWave(p);
    vec3 organicColor = mix(vec3(0.0, 0.3, 0.2), vec3(0.1, 0.7, 0.5), organic);
    
    // Apply digital glitch distortion
    vec2 distortedP = glitch(p + vec2(fbm(p * 10.0 + time), 0.0));
    float glitchEffect = step(0.97, fract(distortedP.x * 10.0 + time)) * step(0.97, fract(distortedP.y * 10.0 - time));
    vec3 digitalColor = vec3(0.8, 0.2, 0.3) * glitchEffect;
    
    // Tree branch overlay adding structured growth patterns
    float branch = treeBranch(p, time);
    vec3 branchColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.0, 0.6, 0.2), branch);
    
    // Combine layers: background, organic wave, glitch disruption, and tree branch structure
    vec3 color = mix(bg, organicColor, organic);
    color = mix(color, digitalColor, glitchEffect);
    color = mix(color, branchColor, smoothstep(0.25, 0.35, branch));
    
    gl_FragColor = vec4(color, 1.0);
}