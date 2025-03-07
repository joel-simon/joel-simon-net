precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(){
    // Map UV from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Reverse assumption: Instead of smooth gradients, use hard geometric quantization.
    // Apply a swirling (counter-clockwise) transformation that intensifies towards the center.
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    // Reverse the usual swirl: a swirl that de-rotates the scene with time based on distance.
    angle -= 2.0 * sin(time + r * 6.2831);
    pos = vec2(r * cos(angle), r * sin(angle));
    
    // Create a grid pattern with discrete cells.
    // Instead of continuous smooth patterns, use step functions to define "pixels".
    float cellSize = 0.1;
    vec2 gridPos = floor((pos + 1.0) / cellSize);
    vec2 cellCenter = (gridPos + 0.5) * cellSize - 1.0;
    
    // Calculate a hard-edged circular mask for each cell to break the symmetry.
    float distToCenter = length(pos - cellCenter);
    // Use a threshold to generate a "pixelated" circle.
    float circle = step(distToCenter, cellSize * 0.45);
    
    // Use the cell coordinates as a seed for a disjoint random variation.
    float cellRand = random(gridPos + sin(time));
    
    // Color modulation: assign unexpected colors by reversing typical color expectations.
    // Use cellRand not as a smooth gradient but as a binary toggle between two schemes.
    vec3 colorA = vec3(0.9 * abs(sin(time + gridPos.x)), 0.1, 0.7 * abs(cos(time + gridPos.y)));
    vec3 colorB = vec3(0.2, 0.8 * abs(cos(time + gridPos.x)), 0.9 * abs(sin(time + gridPos.y)));
    
    // Switch color based on random value.
    vec3 cellColor = mix(colorA, colorB, step(0.5, cellRand));
    
    // Introduce digital distortion by adding a glitch-like factor to non-cell areas.
    float glitch = step(0.98, random(uv * time + pos)) * 0.2;
    
    // The final color is a combination of the cell pattern and the glitch effect, 
    // where area inside a cell gets the vibrant cellColor.
    vec3 finalColor = mix(vec3(0.05, 0.02, 0.1), cellColor, circle) + glitch;
    
    gl_FragColor = vec4(finalColor, 1.0);
}