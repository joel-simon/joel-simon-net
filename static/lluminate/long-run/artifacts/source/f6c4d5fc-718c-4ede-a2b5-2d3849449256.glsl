precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
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

// Glitch offset function to create digital artifacts.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = random(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch pattern blending with noise.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float glitchNoise = smoothstep(0.3, 0.7, random(pos * t));
    return mix(stripes, glitchNoise, 0.3);
}

// Tree shape function representing organic element.
float treeShape(vec2 p) {
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    
    // Trunk
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    
    // Branches
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    // Canopy
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    
    return max(trunk, max(branches, canopy));
}

// Color modulation combining digital glitch and organic color palettes.
vec3 colorModulation(vec2 pos, float t, float tree) {
    float glitchFactor = stripedGlitch(pos, t);
    vec3 digitalColor = mix(vec3(0.1, 0.8, 0.7), vec3(0.9, 0.2, 0.3), glitchFactor);
    vec3 organicColor = mix(vec3(0.1, 0.4, 0.15), vec3(0.2, 0.7, 0.3), uv.y);
    return mix(digitalColor, organicColor, tree);
}

void main() {
    // Rotate coordinate space to introduce subtle digital perturbation.
    vec2 pos = uv;
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Apply subtle glitch distortion.
    vec2 glitchPos = uv;
    glitchPos.x += sin(50.0 * uv.y + time * 10.0) * 0.005;
    
    // Compute organic tree mask.
    float tree = treeShape(glitchPos);
    
    // Create swirling cosmic effect using fbm.
    vec2 centered = (uv - 0.5) * 2.0;
    float swirl = fbm(centered * 2.0 + time);
    float radius = length(centered);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (radius - swirl))));
    
    // Digital grid effect with glitch bursts.
    vec3 digitalGrid;
    {
        vec2 gridUV = fract(uv * 20.0);
        float line = smoothstep(0.0, 0.03, gridUV.x) + smoothstep(1.0, 0.97, gridUV.x)
                   + smoothstep(0.0, 0.03, gridUV.y) + smoothstep(1.0, 0.97, gridUV.y);
        float gridGlitch = step(0.98, random(uv + vec2(time)));
        digitalGrid = mix(vec3(0.0), vec3(0.7, 0.3, 0.9), line * 0.5 + gridGlitch * 0.5);
    }
    
    // Combine swirling and digital grid effects.
    vec3 mixedColor = mix(digitalGrid, colorModulation(uv, time, tree), vortex);
    
    // Introduce extra bursts for creative digital glitch.
    float burst = step(0.97, random(uv * time * 0.3)) * 0.2;
    mixedColor += vec3(burst);
    
    gl_FragColor = vec4(mixedColor, 1.0);
}