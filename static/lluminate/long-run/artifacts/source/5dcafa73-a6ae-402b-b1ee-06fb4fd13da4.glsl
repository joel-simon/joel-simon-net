precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = smoothstep(0.0, 1.0, fract(st));
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main() {
    // Map uv to coordinate space centered at the screen with range [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    // Introduce a swirling storm dynamic with noise and polar coordinates
    float r = length(st);
    float theta = atan(st.y, st.x);
    float swirl = sin(8.0 * r - time * 2.0 + theta);
    float storm = noise(st * 3.0 + time) * swirl;
    
    // Background: a tumultuous night sky with shifting dark tones
    vec3 bgColor = mix(vec3(0.05, 0.05, 0.15), vec3(0.1, 0.05, 0.1), storm);
    
    // Create a silhouette of a mighty oak tree as symbol of resilience replacing a traditional shield.
    // The trunk is defined along the vertical center, curving gently as if swaying in the storm.
    float trunkWidth = 0.03 + 0.01 * sin(time * 3.0);
    float trunkShape = smoothstep(trunkWidth, trunkWidth + 0.005, abs(st.x));
    
    // The trunk extends from bottom center upward; we mask out only the lower half.
    float trunkMask = step(-0.2, st.y) * step(st.y, 0.8);
    // Modulate the trunk's vertical curvature to mimic natural bending.
    float bend = smoothstep(0.0, 1.0, (st.y + 0.2) / 1.0);
    float sway = 0.15 * sin(time * 2.0 + bend * 3.14);
    float treeShape = smoothstep(trunkWidth, trunkWidth + 0.02, abs(st.x - sway));
    float trunk = (1.0 - treeShape) * trunkMask;
    
    // Color for the oak tree, earthy and warm.
    vec3 treeColor = vec3(0.25, 0.15, 0.05);
    
    // Merge the tree silhouette over the stormy background
    vec3 color = mix(bgColor, treeColor, trunk);
    
    gl_FragColor = vec4(color, 1.0);
}