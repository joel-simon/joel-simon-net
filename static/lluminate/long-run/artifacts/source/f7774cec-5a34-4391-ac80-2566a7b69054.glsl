precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main(void) {
    // "Honor thy error as a hidden intention"
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce an "error" offset based on pseudo-noise
    vec2 errorOffset = vec2(
        pseudoNoise(pos + time),
        pseudoNoise(pos - time)
    ) * 0.2;
    pos += errorOffset;
    
    // Apply rotation and warp using time and error inversion
    float angle = time * 0.8 + pseudoNoise(pos * 3.0) * 6.2831;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Radial distance and modified swirl incorporating error signals
    float d = length(pos);
    float a = atan(pos.y, pos.x);
    float swirl = sin(12.0 * d - time * 1.2 + a * 7.0 + pseudoNoise(vec2(d, a)) * 3.1415);
    
    // Color palette dynamically influenced by the glitchy swirl
    vec3 col = vec3(
        sin(swirl + time * 0.9) * 0.5 + 0.5,
        cos(swirl + time * 0.6) * 0.5 + 0.5,
        sin(swirl + time * 0.3) * cos(swirl + time * 0.5) * 0.5 + 0.5
    );
    
    // Introduce intentional glitch artifacts as banding across the scene
    float glitch = step(0.5, fract(time * 0.7 + pos.y * 10.0 + pseudoNoise(pos * 5.0)));
    col = mix(col, vec3(0.1, 0.1, 0.1), glitch);
    
    // Apply fading outside a noisy radial mask
    float mask = smoothstep(0.7 + pseudoNoise(pos*10.0)*0.3, 0.65, d);
    col *= mask;
    
    gl_FragColor = vec4(col, 1.0);
}