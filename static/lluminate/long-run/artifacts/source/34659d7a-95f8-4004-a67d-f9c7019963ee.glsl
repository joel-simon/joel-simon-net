precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 swirl(vec2 pos, float strength) {
    float angle = strength * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

float glitchOffset(vec2 pos, float t) {
    return sin(pos.y * 50.0 + t * 10.0) * 0.01;
}

float treeShape(vec2 p) {
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    float branches = 0.0;
    for (int i = 1; i <= 3; i++){
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    return max(trunk, max(branches, canopy));
}

vec3 bubbleField(vec2 pos) {
    float d = length(pos);
    float n = fbm(pos * 2.0 - time * 0.5);
    float bubbles = smoothstep(0.3, 0.31, abs(n - d));
    vec3 col = mix(vec3(0.2, 0.05, 0.4), vec3(0.7, 0.2, 0.9), n);
    return col * bubbles;
}

vec3 digitalSparks(vec2 pos) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float sparks = smoothstep(0.01, 0.005, abs(sin(10.0 * angle + time * 3.0) * 0.1 - radius));
    return vec3(0.9, 0.8, 0.5) * sparks;
}

void main(void) {
    // Center uv coordinates for multiple effects.
    vec2 pos = uv;
    
    // Apply glitch offset to create digital artifacts.
    vec2 glitchPos = pos;
    glitchPos.x += glitchOffset(pos, time);
    
    // Swirl effect for organic movement.
    vec2 centered = (uv - 0.5) * 2.0;
    vec2 swirledPos = swirl(centered, 2.5);
    
    // Organic bubble field based on swirling coordinates.
    vec3 bubbles = bubbleField(swirledPos);
    
    // Digital sparks overlay.
    vec3 sparks = digitalSparks(centered);
    
    // Tree silhouette shape representing organic growth.
    float tree = treeShape(uv);
    
    // FBM based cosmic texture.
    float cosmic = fbm(uv * 3.0 + time);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (length(centered) - cosmic))));
    
    // Blend digital and organic layers.
    vec3 digitalColor = mix(vec3(0.1, 0.8, 0.7), vec3(0.9, 0.2, 0.3), fbm(glitchPos * 10.0 + time));
    vec3 organicColor = mix(bubbles, sparks, vortex);
    vec3 mixedColor = mix(digitalColor, organicColor, 0.5);
    
    // Integrate tree silhouette as a spatial modulator.
    vec3 finalColor = mix(mixedColor, vec3(0.2, 0.7, 0.3), tree);
    
    gl_FragColor = vec4(finalColor, 1.0);
}