precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
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

float treeBranch(vec2 p, float t) {
    // Transform coordinates to center
    p = p * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Base wobble for branch movement
    float wave = sin(10.0 * r - 4.0 * a + t * 2.0);
    // Emphasize central trunk and branch decay outwards
    float branch = smoothstep(0.2, 0.3, abs(wave)) * exp(-10.0 * r);
    
    // Introduce glitch offsets occasionally using a hash-based step
    float glitch = step(0.95, fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123 + t));
    branch *= (1.0 - glitch);
    
    return branch;
}

vec3 background(vec2 p, float t) {
    // Gradient background with organic noise
    vec3 col1 = vec3(0.0, 0.05, 0.1);
    vec3 col2 = vec3(0.2, 0.15, 0.1);
    vec3 color = mix(col1, col2, p.y);
    
    // Layered FBM noise adds digital texture and subtle glitches in the background
    color += 0.1 * fbm(p * 5.0 + t * 0.1);
    return color;
}

void main() {
    vec2 pos = uv;
    
    // Compute background with organic gradient and digital texture
    vec3 bg = background(pos, time);
    
    // Compute dynamic tree branch structure with glitch effects
    float branchPattern = treeBranch(pos, time);
    
    // Earthy to green color transition for tree branch emphasizing organic resilience
    vec3 treeColor = mix(vec3(0.1, 0.05, 0.0), vec3(0.0, 0.5, 0.2), branchPattern);
    
    // Composite branch structure over the textured background
    vec3 finalColor = mix(bg, treeColor, smoothstep(0.1, 0.4, branchPattern));
    
    gl_FragColor = vec4(finalColor, 1.0);
}