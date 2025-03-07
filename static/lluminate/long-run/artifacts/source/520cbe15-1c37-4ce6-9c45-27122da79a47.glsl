precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float labyrinthEffect(vec2 p, float t) {
    // Transform coordinate space to center and scale.
    vec2 centered = p - 0.5;
    float r = length(centered);
    float a = atan(centered.y, centered.x);
    
    // Create a swirling maze pattern: 
    // Instead of a typical brain symbol (S) associated with wisdom,
    // we replace it with a tree (P) concept where growth (wisdom) is essential.
    // Here, the maze acts as the "tree" of life with branching paths.
    float swirl = sin(6.0 * a + t * 1.5) * 0.5 + 0.5;
    float ring = smoothstep(0.3, 0.31, r * 2.0);
    float branches = smoothstep(0.2, 0.21, abs(sin(12.0 * a + t)));
    return mix(swirl, branches, ring);
}

float digitalGrid(vec2 p, float t) {
    vec2 gridUV = fract(p * 10.0);
    float line = step(0.95, length(gridUV - 0.5));
    return line * 0.3;
}

vec3 colorLayer(vec2 p, float t) {
    // Base colors blending inspired by natural shades.
    vec3 colA = vec3(0.1, 0.5, 0.2);
    vec3 colB = vec3(0.8, 0.7, 0.3);
    
    float maze = labyrinthEffect(p, t);
    float grid = digitalGrid(p, t);
    float modMix = 0.5 + 0.5 * sin(t + p.x * 10.0);
    vec3 blend = mix(colA, colB, modMix);
    blend += vec3(maze * 0.6, maze * 0.8, maze * 0.4);
    blend += vec3(grid);
    return blend;
}

void main() {
    vec2 pos = uv;
    
    // Apply a subtle rotation to introduce organic growth motion.
    vec2 centered = pos - 0.5;
    float angle = time * 0.2;
    centered = rotate(centered, angle);
    vec2 transformed = centered + 0.5;
    
    // Synthesize the layers.
    vec3 color = colorLayer(transformed, time);
    
    gl_FragColor = vec4(color, 1.0);
}