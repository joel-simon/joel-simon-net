precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * pseudoRandom(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec3 colorPalette(float t) {
    // Reversed assumptions: Instead of smooth gradients, use abrupt color changes
    float r = step(0.5, mod(t * 6.0, 1.0));
    float g = step(0.5, mod(t * 3.0 + 0.33, 1.0));
    float b = step(0.5, mod(t * 4.0 + 0.66, 1.0));
    return vec3(r, g, b);
}

void main() {
    // Shift uv so that center is at (0,0) and scale it non-uniformly to challenge symmetry.
    vec2 pos = (uv - 0.5) * vec2(2.0, 1.5);
    
    // Reverse the typical smooth noise assumption: use sharp fbm thresholds.
    float noise = fbm(pos * 3.0 + time * 0.5);
    float threshold = step(0.5, noise);
    
    // Create a swirling pattern by warping the coordinates in a non-linear fashion.
    float angle = atan(pos.y, pos.x) + time * 0.8;
    float radius = length(pos);
    
    // Instead of a usual swirl, invert the rotation effect based on radius.
    float swirl = sin(angle * (1.0 / (radius + 0.1)) * 4.0 + time);
    
    // Combine the abrupt noise threshold with the twist.
    float combined = mix(threshold, swirl, 0.5);
    
    // Use the combined value to select a suddenly changing color palette.
    vec3 color = colorPalette(combined + fbm(pos * 10.0 - time));
    
    // Add a border effect that defies the usual smooth vignette.
    float border = step(0.8, radius);
    color = mix(color, vec3(0.1, 0.1, 0.1), border);
    
    gl_FragColor = vec4(color, 1.0);
}