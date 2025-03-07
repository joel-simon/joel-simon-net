precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float heartShape(vec2 p, vec2 center, float scale) {
    vec2 pos = (p - center) * 2.0;
    pos.x *= 1.2;
    float a = atan(pos.x, pos.y);
    float r = length(pos);
    float h = pow(r, 0.5) - 0.5 * sin(a * 3.0 + time);
    return smoothstep(scale, scale - 0.01, h);
}

float glitchPattern(vec2 p) {
    vec2 gp = p * 10.0;
    float wave = sin(gp.x + time) * cos(gp.y - time);
    float glitch = step(0.0, fract(sin(dot(gp, vec2(12.9898,78.233))) * 43758.5453) - 0.5);
    return abs(wave) * glitch;
}

void main() {
    vec2 center = vec2(0.5, 0.5);
    
    // Step 1: Anchor concept is the heart
    // Create a dynamic coordinate space blending original and mirrored uv for rhythmic effects.
    vec2 revUV = vec2(1.0 - uv.x, 1.0 - uv.y);
    vec2 mixUV = mix(uv, revUV, 0.5 + 0.5 * sin(time * 0.8));
    
    // Step 2: Generate associations between heart and digital glitch patterns (medium distance).
    // Background radial gradient with subtle color shifts.
    float dist = length(mixUV - center);
    vec3 bgColor = mix(vec3(0.05, 0.02, 0.1), vec3(0.2,0.1,0.35), 0.5 + 0.5 * sin(time + dist * 12.0));
    
    // Medium association: create swirling distortion and overlay digital grid patterns.
    float angle = atan(mixUV.y - center.y, mixUV.x - center.x);
    float radius = length(mixUV - center);
    float spiral = sin(radius * 15.0 - time * 3.0 + angle * 4.0);
    
    // Step 3: Anchor the heart within the swirl distortion.
    float heart = heartShape(mixUV + 0.02 * vec2(cos(time), sin(time)) * spiral, center, 0.45);
    
    // Additional noise layers layered for "brain-like" texture within heart boundaries.
    vec2 noisePos = (mixUV - center) * 5.0;
    float n = noise(noisePos - time * 0.3);
    
    // Digital glitch overlay with grid-like artifact.
    float glitch = glitchPattern(mixUV + vec2(sin(time), cos(time)) * 0.02);
    
    // Generate a subtle digital grid using uv fract.
    vec2 grid = fract(mixUV * 10.0) - 0.5;
    float gridLines = smoothstep(0.48, 0.5, abs(grid.x)) + smoothstep(0.48, 0.5, abs(grid.y));
    float digital = gridLines * 0.15 + glitch;
    
    // Combine the inner heart details with glitch patterns
    float mask = clamp(heart + 0.3 * digital - 0.1 * n, 0.0, 1.0);
    
    // Step 4: Develop association; blend warm heart colors with cool digital shades.
    vec3 heartColor = mix(vec3(0.8, 0.2, 0.5), vec3(0.1,0.95,0.85), mixUV.y + 0.2 * sin(time * 2.0));
    vec3 finalColor = mix(bgColor, heartColor, mask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}