precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453123 + t) * amt;
    pos.x += shift;
    return pos;
}

vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

float treeBranch(vec2 pos, float t) {
    vec2 p = pos * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

float heartShape(vec2 pos) {
    pos.x *= 1.2;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0) * (x*x + y*y - 1.0) * (x*x + y*y - 1.0) - x*x*y*y*y;
}

vec3 organicTexture(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float r = length(pos - 0.5);
    float cell = smoothstep(0.4, 0.38, abs(n - r));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

vec3 digitalBurst(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float burst = step(0.95, hash(pos * 1.3 + vec2(time))) * 0.3;
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + burst;
}

vec3 organicPattern(vec2 pos, float t) {
    vec2 center = vec2(0.5);
    vec2 offset = pos - center;
    float angle = atan(offset.y, offset.x);
    float radius = length(offset);
    float swirlVal = sin(angle * 3.0 + t) * 0.1;
    radius += swirlVal;
    float n = fbm(pos * 8.0 + vec2(t * 0.2, t * 0.3));
    float band = smoothstep(0.3, 0.35, abs(sin(10.0 * radius + n * 5.0)));
    vec3 col = mix(vec3(0.05, 0.2, 0.1), vec3(0.15, 0.8, 0.4), band);
    return col;
}

vec3 digitalGlitch(vec2 pos, float t) {
    float glitch = step(0.95, hash(vec2(floor(pos.y * 50.0), t)));
    vec2 offset = vec2(glitch * 0.05, 0.0);
    pos += offset;
    float grid = smoothstep(0.45, 0.55, fract(pos.x * 20.0)) *
                 smoothstep(0.45, 0.55, fract(pos.y * 20.0));
    vec3 col = mix(vec3(0.8, 0.8, 0.8), vec3(0.2, 0.2, 0.2), grid);
    return col;
}

void main(void) {
    vec2 pos = uv;
    
    // Apply digital glitch offset
    pos = glitchOffset(pos, time);
    
    // Organic swirling transformation
    vec2 centered = pos - 0.5;
    float polarAngle = fbm(centered * 3.0 + time) * 6.2831 * 0.2;
    vec2 rotated = polarTransform(centered, polarAngle);
    vec2 swirled = swirl(rotated, 3.0 * sin(time * 0.8));
    vec2 finalPos = swirled + 0.5;
    
    // Compute layers
    vec3 organicLayer = organicTexture(uv);
    vec3 digitalLayer = digitalBurst(finalPos);
    vec3 patternLayer = organicPattern(pos, time);
    vec3 glitchLayer = digitalGlitch(pos, time);
    
    // Tree branch organic growth elements
    float branch1 = treeBranch(uv, time);
    float branch2 = treeBranch(finalPos, time * 0.9);
    float branchMix = mix(branch1, branch2, 0.5);
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchMix);
    
    // Implicit heart shape for emotional emphasis
    float heart = heartShape((uv * 2.0 - 1.0) * 1.8);
    float heartMask = smoothstep(0.0, 0.02, -heart);
    
    // Cosmic background gradient
    vec2 centeredUV = (uv - 0.5) * 2.0;
    float radius = length(centeredUV);
    vec3 cosmic = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.1, 0.25), radius);
    
    // Synthesize layers using a blend factor that evolves with time
    float mixFactor = smoothstep(0.6, 0.2, length(uv - 0.5));
    vec3 mixLayer = mix(organicLayer, digitalLayer, mixFactor);
    mixLayer = mix(mixLayer, patternLayer, 0.5);
    mixLayer = mix(mixLayer, glitchLayer, 0.3);
    mixLayer = mix(mixLayer, treeColor, smoothstep(0.15, 0.35, branchMix + noise(uv * 5.0 + time) * 0.2));
    mixLayer = mix(cosmic, mixLayer, 0.5);
    mixLayer = mix(mixLayer, treeColor, heartMask);
    
    gl_FragColor = vec4(mixLayer, 1.0);
}