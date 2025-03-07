precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random noise function.
float rand(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Glitch offset to create digital artifact displacement.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = rand(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch pattern blending noise and sine waves.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float noise = smoothstep(0.3, 0.7, rand(pos * t));
    return mix(stripes, noise, 0.3);
}

// Function to generate a tree silhouette with trunk, branches, and canopy.
float treeShape(vec2 p) {
    // Center at lower half.
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    
    // Trunk: simple vertical soft edge.
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    
    // Branches: simulate organic bifurcation with sine functions.
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    // Canopy: circular blob representing leaves with soft falloff.
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    
    return max(trunk, max(branches, canopy));
}

// Create swirling digital waves inspired by cosmic patterns.
float swirlingWaves(vec2 pos, float t) {
    // Adjust pos for polar conversion.
    vec2 centered = pos * 2.0 - 1.0;
    centered.x *= 1.5;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    
    float wave1 = sin(10.0 * radius - 3.0 * t + 5.0 * angle);
    float wave2 = sin(20.0 * radius - 2.0 * t + 3.0 * angle);
    float wave3 = sin(15.0 * (radius + 0.5 * sin(t)) - 4.0 * angle);
    float combined = (wave1 + wave2 + wave3) / 3.0;
    
    combined += (rand(centered * t) - 0.5) * 0.2;
    return combined;
}

// Color modulation combining organic tree colors with digital glitch hues.
vec3 colorModulation(vec2 pos, float t, float tree) {
    float glitchFactor = stripedGlitch(pos, t);
    vec3 digitalColor = mix(vec3(0.1, 0.8, 0.7), vec3(0.9, 0.2, 0.3), glitchFactor);
    
    vec3 treeColor = mix(vec3(0.1, 0.4, 0.15), vec3(0.2, 0.7, 0.3), uv.y);
    return mix(digitalColor, treeColor, tree);
}

void main() {
    vec2 pos = uv;
    
    // Introduce a subtle rotation based on time for digital perturbations.
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Compute tree shape with additional subtle glitch displacement.
    vec2 p = uv;
    p.x += sin(50.0 * p.y + time * 10.0) * 0.005;
    float tree = treeShape(p);
    
    // Get swirling digital wave intensity.
    float wave = swirlingWaves(uv, time);
    
    // Combine glitch pattern with swirling waves.
    float pattern = mix(stripedGlitch(pos, time), wave, 0.5);
    
    // Determine final color from digital and organic interplay.
    vec3 color = colorModulation(pos, time, tree);
    
    // Apply modulation from the combined pattern for contrast.
    float intensity = smoothstep(0.3, 0.5, pattern) - smoothstep(0.7, 0.8, pattern);
    color *= mix(0.8, 1.2, intensity);
    
    gl_FragColor = vec4(color, 1.0);
}