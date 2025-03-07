precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(27.619, 57.583))) * 43758.5453);
}

vec3 palette(float t) {
    return vec3(sin(t + 6.2831 * 0.0),
                sin(t + 6.2831 * 0.33),
                sin(t + 6.2831 * 0.66)) * 0.5 + 0.5;
}

void main() {
    vec2 pos = uv;
    
    // Reverse a common assumption: rather than blending smoothly, enforce hard boundaries.
    // Mirror the lower half vertically, challenging the idea of uniformity.
    if (pos.y < 0.5) {
        pos.y = 1.0 - pos.y;
    }
    
    // Apply a rotation that dynamically reverses direction to distort expectations of stability.
    float angle = sin(time) * 3.1415;
    float s = sin(angle);
    float c = cos(angle);
    vec2 centered = pos - vec2(0.5);
    vec2 rotated = vec2(centered.x * c - centered.y * s, centered.x * s + centered.y * c) + vec2(0.5);
    
    // Introduce a digital glitch texture using grid pattern thresholds.
    vec2 grid = fract(rotated * 10.0);
    float cellEdge = step(0.5, grid.x) * step(0.5, grid.y);
    
    // Generate a dynamic color palette based on pseudo randomness and time.
    float h = hash(floor(rotated * 10.0));
    vec3 color = palette(h + time * 0.5);
    
    // Mix the base color with a prominent digital glitch patterned overlay.
    color = mix(color, vec3(0.1, 0.9, 0.6), cellEdge * 0.7);
    
    gl_FragColor = vec4(color, 1.0);
}