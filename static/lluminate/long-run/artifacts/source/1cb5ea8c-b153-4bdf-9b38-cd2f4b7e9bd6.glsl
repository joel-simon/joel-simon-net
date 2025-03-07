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

// Glitch offset function to create digital artifacts.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.03;
    float shift = step(0.95, random(vec2(pos.y, t))) * amt;
    pos.x += shift;
    return pos;
}

// Create an organic tree silhouette shape.
float treeShape(vec2 p) {
    // Translate and scale coordinates for tree base
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    
    // Trunk: vertical stripe with soft edges.
    float trunk = smoothstep(0.04, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    
    // Branches: using sine waves to spread branches.
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.08 * sin(12.0 * pos.y + time * fi);
        float branch = smoothstep(0.03, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.08 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    // Canopy: circular blob to represent leaves.
    float canopy = smoothstep(0.32, 0.30, length(vec2(pos.x, pos.y - 0.7)));
    
    return max(trunk, max(branches, canopy));
}

// Create a swirling cosmic wave pattern.
float cosmicWave(vec2 pos) {
    // Convert to polar coordinates.
    vec2 centered = pos * 2.0 - 1.0;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    float wave = sin(8.0 * r - 4.0 * time + 5.0 * angle);
    return wave;
}

// Color modulation blending organic tree and cosmic glitch
vec3 colorModulation(vec2 pos, float treeVal, float waveVal) {
    // Digital glitch grid from noise.
    float glitch = noise(pos * 10.0 + time) * 0.3;
    // Cosmic color from wave pattern.
    vec3 cosmic = mix(vec3(0.1, 0.0, 0.3), vec3(0.7, 0.2, 0.9), smoothstep(-1.0, 1.0, waveVal));
    // Organic tree color.
    vec3 treeColor = mix(vec3(0.0, 0.2, 0.0), vec3(0.0, 0.6, 0.2), treeVal);
    return mix(cosmic, treeColor, treeVal) + glitch;
}

void main() {
    vec2 pos = uv;
    pos = glitchOffset(pos, time);
    
    // Apply slight rotation to enhance digital distortion.
    float angle = sin(time * 0.3) * 0.2;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle),  cos(angle));
    pos = rot * pos;
    
    // Evaluate tree shape with minor additional glitch distortion.
    float treeVal = treeShape(uv + vec2(sin(time*3.0)*0.005, 0.0));
    
    // Evaluate cosmic swirling wave.
    float waveVal = cosmicWave(uv);
    
    // Combine color modulations.
    vec3 color = colorModulation(uv, treeVal, waveVal);
    
    // Final intensity and vignette
    float vignette = smoothstep(1.0, 0.2, length(uv - vec2(0.5)));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}