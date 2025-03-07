precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float circle(vec2 uv, vec2 center, float radius, float width) {
    float dist = length(uv - center);
    return smoothstep(radius + width, radius, dist);
}

void main() {
    // Transform coordinates
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.2;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);

    // Create a pulsing grid by combining circles in a polar arrangement
    float grid = 0.0;
    int rings = 6;
    int segments = 12;
    for (int i = 1; i <= rings; i++) {
        float r = float(i) / float(rings);
        for (int j = 0; j < segments; j++) {
            float a = (2.0 * 3.14159265 * float(j)) / float(segments);
            // Reverse phase over time in a rhythmic pattern
            float offset = sin(time * (1.0 - r) + a);
            vec2 center = vec2(r * cos(a + offset), r * sin(a + offset));
            grid += circle(pos, center, 0.1 * r, 0.01);
        }
    }
    grid = clamp(grid, 0.0, 1.0);

    // Create an overlay of reversing radial gradient with dynamic color inversion
    float radial = smoothstep(0.8, 0.0, radius);
    vec3 color1 = vec3(0.2 + 0.8 * abs(sin(time + 3.1415 * radial)));
    vec3 color2 = vec3(0.8 - 0.8 * abs(cos(time + 3.1415 * radial)));
    vec3 mixedColor = mix(color1, color2, radial);

    // Combine grid and radial pattern using SCAMPER operation: combine and modify
    float mixFactor = smoothstep(0.2, 0.8, grid);
    vec3 finalColor = mix(mixedColor * 0.7, vec3(grid, grid, grid), mixFactor);

    // Apply a glitch-like noise inversion effect occasionally
    float glitch = step(0.98, pseudoRandom(pos * time));
    finalColor = mix(finalColor, vec3(1.0) - finalColor, glitch * 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}