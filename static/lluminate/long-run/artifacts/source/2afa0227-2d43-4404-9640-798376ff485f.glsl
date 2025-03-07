precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = pseudoNoise(i);
    float b = pseudoNoise(i + vec2(1.0, 0.0));
    float c = pseudoNoise(i + vec2(0.0, 1.0));
    float d = pseudoNoise(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float treeShape(vec2 p) {
    // Center and scale coordinates for organic tree representation.
    p = (p - 0.5) * 2.0;
    // Trunk shape.
    float trunk = smoothstep(0.03, 0.0, abs(p.x));
    // Branch oscillations using sine distortion.
    float branch = smoothstep(0.035, 0.0, abs(p.x - 0.35 * sin(10.0 * p.y + time)));
    float shape = max(trunk, branch);
    // Fade top for soft foliage effect.
    shape *= smoothstep(0.1, -0.3, p.y);
    return shape;
}

vec3 glitchColor(vec2 p, float t) {
    float n = pseudoNoise(p * 50.0 + t);
    float r = pseudoNoise(p + vec2(t * 0.1, 0.0));
    float g = pseudoNoise(p + vec2(0.0, t * 0.15));
    float b = pseudoNoise(p + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

void main(){
    vec2 p = uv;
    
    // Organic background: mix of soft sky and ground gradient.
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    vec3 bgColor = mix(vec3(0.9,0.95,1.0), vec3(0.8,0.9,0.7), smoothstep(0.0,0.7,dist));
    
    // Swirling digital glitch effect on UV.
    vec2 centered = uv - 0.5;
    vec2 perturbedUV = centered + 0.1 * sin(10.0 * centered.yx + time);
    float angle = atan(perturbedUV.y, perturbedUV.x);
    float radius = length(perturbedUV);
    float spiral = sin(10.0 * radius - time * 4.0 + angle * 5.0);
    
    // Digital grid overlay.
    vec2 grid = abs(fract(perturbedUV * 10.0) - 0.5);
    float gridLine = smoothstep(0.4, 0.42, min(grid.x, grid.y));
    
    // Combine spiral organic pattern with grid.
    float pattern = smoothstep(0.2, 0.3, radius + 0.1 * spiral) * (1.0 - gridLine);
    
    // Tree organic form representing nature.
    float tree = treeShape(p);
    
    // Determine tree color blending trunk and foliage.
    vec3 trunkColor = vec3(0.4,0.25,0.1);
    vec3 leafColor = vec3(0.2,0.6,0.2);
    float leafBlend = smoothstep(0.0, 0.6, (p.y - 0.5));
    vec3 treeColor = mix(trunkColor, leafColor, leafBlend);
    
    // Glitch component from digital artifact functions.
    vec3 glitch = glitchColor(perturbedUV * 2.0, time);
    
    // Additional noise driven color mix to blend organic and digital.
    float rn = noise(perturbedUV * 15.0 + vec2(1.0,2.0) * time);
    float gn = noise(perturbedUV * 15.0 + vec2(3.0,4.0) * time);
    float bn = noise(perturbedUV * 15.0 + vec2(5.0,6.0) * time);
    vec3 mixedColor = smoothstep(0.3, 0.7, vec3(rn, gn, bn));
    
    // Compose final scene with background, tree, digital glitch and noise mix.
    vec3 color = mix(bgColor, treeColor, tree);
    color = mix(color, glitch, 0.25) + mixedColor * 0.15;
    color *= pattern;
    
    // Apply vignette based on distance from center.
    float vignette = smoothstep(0.7, 0.3, radius);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}