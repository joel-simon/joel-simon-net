precision mediump float;
varying vec2 uv;
uniform float time;

// Random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Glitch offset function
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = random(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch pattern
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float nval = smoothstep(0.3, 0.7, random(pos * t));
    return mix(stripes, nval, 0.3);
}

// Digital grid with glitch bursts
vec3 digitalGrid(vec2 pos) {
    vec2 gridUV = fract(pos * 20.0);
    float line = smoothstep(0.0, 0.03, gridUV.x) + smoothstep(1.0, 0.97, gridUV.x)
               + smoothstep(0.0, 0.03, gridUV.y) + smoothstep(1.0, 0.97, gridUV.y);
    float glitch = step(0.98, random(pos + time));
    return mix(vec3(0.0), vec3(0.7, 0.3, 0.9), line * 0.5 + glitch * 0.5);
}

// Tree shape function - organic silhouette
float treeShape(vec2 p) {
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0,pos.y) * step(pos.y,0.35);
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    return max(trunk, max(branches, canopy));
}

// Organic color modulation combining fbm and sine oscillation.
vec3 organicColor(vec2 pos, float t) {
    float n = fbm(pos * 3.0 + t);
    float swirl = fbm((uv - 0.5) * 2.0 * 2.0 + t);
    return vec3(0.3 + 0.7 * n,
                0.4 + 0.6 * swirl,
                0.5 + 0.5 * sin(t + length(pos)*3.14));
}

// Combined digital and organic color modulation using tree shape mask.
vec3 colorModulation(vec2 pos, float t, float tree) {
    float glitchFactor = stripedGlitch(pos, t);
    vec3 digitalColor = mix(vec3(0.1, 0.8, 0.7), vec3(0.9, 0.2, 0.3), glitchFactor);
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.2, 0.7, 0.3), smoothstep(0.45, 0.8, uv.y));
    return mix(digitalColor, treeColor, tree);
}

void main() {
    // Rotate to introduce digital perturbation.
    vec2 pos = uv;
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Distort position slightly for glitch effect.
    vec2 glitchPos = uv;
    glitchPos.x += sin(50.0 * uv.y + time * 10.0) * 0.005;
    
    // Compute tree shape mask.
    float tree = treeShape(glitchPos);
    
    // Create swirling effect with fbm.
    vec2 centered = (uv - 0.5) * 2.0;
    float swirl = fbm(centered * 2.0 + time);
    float radius = length(centered);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (radius - swirl))));
    
    // Digital grid and glitch bursts.
    vec3 gridColor = digitalGrid(uv + vec2(time * 0.1));
    
    // Organic shader color.
    vec3 organic = organicColor(uv, time);
    
    // Mix digital and organic based on vortex.
    vec3 mixedColor = mix(gridColor, organic, vortex);
    
    // Apply combined modulation with tree shape emergent.
    vec3 finalColor = mix(mixedColor, colorModulation(uv, time, tree), tree);
    
    // Extra glitch bursts overlay.
    float burst = step(0.97, random(uv * time * 0.3)) * 0.2;
    finalColor += vec3(burst);
    
    gl_FragColor = vec4(finalColor, 1.0);
}