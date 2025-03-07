precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Glitch offset function to create intentional digital artifacts.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = pseudoRandom(vec2(floor(pos.y * 10.0), t)) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch pattern blending with noise.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float noise = smoothstep(0.3, 0.7, pseudoRandom(pos * t));
    return mix(stripes, noise, 0.3);
}

// Create a tree silhouette shape: trunk, branches and canopy.
float treeShape(vec2 p) {
    // Move the tree to the lower center.
    vec2 pos = p - vec2(0.5, 0.0);
    pos.y *= 2.0;
    
    // Trunk: a vertical strip with soft edges.
    float trunk = smoothstep(0.03, 0.0, abs(pos.x)) * step(0.0, pos.y) * step(pos.y, 0.35);
    
    // Branches: use sine functions to create wavy shapes.
    float branches = 0.0;
    for (int i = 1; i <= 3; i++) {
        float fi = float(i);
        float offset = 0.1 * sin(10.0 * pos.y + time + fi);
        float branch = smoothstep(0.025, 0.015, abs(pos.x - offset)) * smoothstep(0.0, 0.35 - 0.1 * fi, pos.y);
        branches = max(branches, branch);
    }
    
    // Canopy: a circular soft blob representing leaves.
    float canopy = smoothstep(0.35, 0.33, length(vec2(pos.x, pos.y - 0.7)));
    
    return max(trunk, max(branches, canopy));
}
  
// Combined cosmic and organic modulation by mixing digital glitch with natural gradient.
vec3 colorModulation(vec2 pos, float t, float tree) {
    // Digital grid color modulation.
    float glitchFactor = stripedGlitch(pos, t);
    vec3 digitalColor = mix(vec3(0.1, 0.8, 0.7), vec3(0.9, 0.2, 0.3), glitchFactor);
    
    // Organic tree color modulation.
    vec3 treeColor = mix(vec3(0.1, 0.4, 0.15), vec3(0.2, 0.7, 0.3), uv.y);
    
    // Blend them: allow tree silhouette to emerge through the digital glitch overlay.
    return mix(digitalColor, treeColor, tree);
}

void main() {
    vec2 pos = uv;
    // Slight rotation for unexpected digital perturbation.
    float angle = sin(time) * 0.1;
    mat2 rot = mat2(cos(angle), -sin(angle),
                    sin(angle), cos(angle));
    pos = rot * pos;
    
    // Evaluate tree shape with a subtle glitch on x coordinate.
    vec2 p = uv;
    float glitch = sin(50.0 * p.y + time * 10.0) * 0.005;
    p.x += glitch;
    float tree = treeShape(p);
    
    // Combine glitch patterns for digital aesthetics.
    float pattern = stripedGlitch(pos, time);
    
    // Get final color by mixing digital and organic aspects.
    vec3 color = colorModulation(pos, time, tree);
    
    // Modulate brightness with the digital glitch pattern.
    color *= mix(0.8, 1.2, pattern);
    
    gl_FragColor = vec4(color, 1.0);
}