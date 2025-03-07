precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    // Transform uv to [-1,1] coordinate space.
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create a swirling wave background
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float swirl = sin(10.0 * radius - time * 3.0 + angle * 4.0);
    vec3 waveColor = mix(vec3(0.1, 0.2, 0.4), vec3(0.6, 0.7, 0.9), 0.5 + 0.5 * swirl);
    
    // Create a dynamic grid of pulsating circles overlay
    vec2 grid = (uv * 10.0);
    vec2 id = floor(grid);
    vec2 f = fract(grid);
    
    // Variation per grid cell using pseudo random function.
    float rnd = pseudoRandom(id);
    float pulsate = sin(time + rnd * 6.2831) * 0.3 + 0.7;
    float circleRadius = 0.3 * pulsate;
    
    // Distance from center of cell.
    float dist = length(f - vec2(0.5));
    float circle = smoothstep(circleRadius, circleRadius - 0.01, dist);
    
    // Additional interference lines in each grid cell.
    float cellAngle = atan(f.y - 0.5, f.x - 0.5);
    float interference = sin((cellAngle + time) * 8.0) * 0.5 + 0.5;
    float blendShape = mix(circle, interference, 0.3);
    
    // Mix colors from grid overlay using cell id variation.
    vec3 gridColor = vec3(
        0.5 + 0.5 * cos(time + id.x * 0.5),
        0.5 + 0.5 * sin(time + id.y * 0.5),
        0.5 + 0.5 * cos(time + id.x + id.y)
    );
    
    // Blend the two conceptual spaces: swirling waves and grid pulsations.
    vec3 color = mix(waveColor, gridColor, 0.4) * blendShape;
    
    gl_FragColor = vec4(color, 1.0);
}