precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233)))*43758.5453123);
}

void main() {
    // Reverse a common assumption: Instead of centering the pattern on (0,0),
    // we use a dynamic perspective from the bottom-left corner.
    vec2 pos = uv;
    
    // Create a grid pattern with a twist: each cell flips based on time and randomness
    vec2 grid = vec2(10.0, 10.0);
    vec2 cell = floor(pos * grid);
    
    // Instead of a simple grid, mix time-based randomness in each cell.
    float flip = step(0.5, random(cell + vec2(time * 0.5, time * 0.5)));
    
    // Compute local coordinate in the cell, center is shifted by flip state.
    vec2 localUV = fract(pos * grid) - 0.5;
    if(flip > 0.5) {
        localUV = -localUV;
    }
    
    // Combine cell effect with a sine modulation that reverses depth assumption:
    // Instead of fading out from the center, we build brightness outward.
    float dist = length(localUV);
    float edge = smoothstep(0.4, 0.45, dist);
    float brightness = mix(1.0, 0.0, edge);
    
    // Introduce an unexpected twist: a time-based glitch overlay using a sine wave
    float glitch = sin((localUV.x + localUV.y + time * 5.0) * 20.0);
    brightness *= smoothstep(0.2, 0.3, abs(glitch));
    
    // Final color by mixing a base color with dynamic tint from cell randomness.
    vec3 baseColor = vec3(0.2, 0.6, 0.8);
    vec3 dynamicTint = vec3(random(cell), random(cell + 1.0), random(cell + 2.0));
    vec3 finalColor = mix(baseColor, dynamicTint, 0.5) * brightness;
    
    gl_FragColor = vec4(finalColor, 1.0);
}