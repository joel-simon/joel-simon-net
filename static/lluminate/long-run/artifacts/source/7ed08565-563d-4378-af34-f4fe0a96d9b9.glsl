precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    // Anchor concept: Grid, medium association: pulsating circles.
    // Create a dynamic grid of circles whose radii pulsate with time.
    vec2 grid = uv * 10.0; // Increase grid frequency.
    vec2 id = floor(grid);
    vec2 f = fract(grid);

    // Use pseudo random to generate variation per cell.
    float rnd = pseudoRandom(id);
    
    // Create pulsating effect for circle radii.
    float pulsate = sin(time + rnd * 6.2831) * 0.3 + 0.7;
    float radius = 0.3 * pulsate;

    // Distance from the center of each cell.
    float dist = length(f - vec2(0.5));

    // Use smoothstep to create circle shape.
    float circle = smoothstep(radius, radius - 0.01, dist);

    // Additional medium association: dynamic interference lines.
    float angle = atan(f.y - 0.5, f.x - 0.5);
    float interference = sin((angle + time) * 8.0) * 0.5 + 0.5;
    float blend = mix(circle, interference, 0.3);

    // Color variation based on grid cell id and time evolution.
    vec3 col = vec3(0.5 + 0.5 * cos(time + id.x * 0.5),
                    0.5 + 0.5 * sin(time + id.y * 0.5),
                    0.5 + 0.5 * cos(time + id.x + id.y));
    
    gl_FragColor = vec4(col * blend, 1.0);
}