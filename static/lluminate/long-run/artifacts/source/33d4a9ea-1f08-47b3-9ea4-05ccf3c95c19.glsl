precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
    // Remap uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Reverse base swirling movement by inverting the angle calculation
    float angle = -atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a reversed swirl: the swirl amplitude decays from the center
    float swirl = cos(radius * 8.0 + time * 1.5);
    float newAngle = angle + swirl * 0.8;
    
    // Map back to Cartesian coordinates with a twist: new polar coordinates (radius unchanged)
    vec2 newPos = vec2(radius * cos(newAngle), radius * sin(newAngle));
    
    // Introduce glitch elements by combining noise over a reversed grid
    vec2 glitchUV = uv;
    glitchUV.y = 1.0 - glitchUV.y;
    float glitch = noise(glitchUV * 12.0 + time * 0.5);
    
    // Define a dynamic band pattern based on the new coordinates
    float band = smoothstep(0.05, 0.06, abs(fract(newPos.x * 5.0 + time) - 0.5));
    
    // Create two contrasting color palettes
    vec3 palette1 = vec3(0.2, 0.7, 0.9);
    vec3 palette2 = vec3(0.9, 0.3, 0.4);
    
    // MIX colors based on the glitch noise and band effect, invert glitch effect to magnify its presence
    vec3 color = mix(palette1, palette2, band);
    color += (1.0 - glitch) * 0.25;
    
    // Add a shifting radial vignette that inverts at the edges
    float vignette = 1.0 - smoothstep(0.4, 0.8, radius);
    color *= mix(vignette, 1.0 - vignette, 0.5);
    
    gl_FragColor = vec4(color, 1.0);
}