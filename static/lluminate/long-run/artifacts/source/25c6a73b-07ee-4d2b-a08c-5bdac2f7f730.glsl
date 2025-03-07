precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(void) {
    // draw_random_card: "Honor thy error as a hidden intention."
    // interpret_directive: Mistakes and randomness reveal unexpected beauty.
    // apply_insight: Introduce controlled randomness as intentional "errors".
    
    // Normalize UV coordinates to range [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create an intentional "glitch" offset based on time and noise
    vec2 glitch = vec2(rand(pos + time), rand(pos - time)) - 0.5;
    pos += glitch * 0.1;
    
    // Convert to polar coordinates
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    
    // Create a dual frequency pattern with intentional "error" interference
    float pattern = sin(8.0 * theta + time) + 0.5 * sin(20.0 * r - time * 1.5);
    
    // Introduce random perturbations as hidden intentions in the color
    float noise = rand(pos * time) * 0.3;
    
    // Build a shifted color palette based on the pattern and noise
    vec3 color;
    color.r = 0.5 + 0.5 * sin(pattern + noise + time);
    color.g = 0.5 + 0.5 * cos(pattern + noise - time * 0.8);
    color.b = 0.5 + 0.5 * sin(pattern * 1.2 + noise + time * 0.6);
    
    // Vignette effect with a twist: allow random variations along the edge
    float vignette = smoothstep(0.75, 0.5, r + rand(pos * 3.0) * 0.1);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}