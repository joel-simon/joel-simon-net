precision mediump float;
varying vec2 uv;
uniform float time;

// A creative reversal: Instead of static grids we let space itself twist unpredictably,
// questioning the assumption that order must underlie design. In this shader, the calm structure of grids is replaced with an organic, swirling interplay of colors and shapes.
  
// A pseudo-random function based on sine for noise-like effects.
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Shift uv coordinates to range [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Reverse a common assumption: Instead of calm rotation, use jittering rotations.
    float angle = time + noise(pos * 5.0) * 6.2831;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
    
    // Create a fluid, fluctuating radial distortion with swirling noise.
    float radial = length(pos);
    float swirl = sin(10.0 * radial - time*3.0 + noise(pos*10.0)*6.2831);
    float blend = smoothstep(0.3, 0.5, radial + 0.1 * swirl);

    // Generate an unexpected color pattern without relying on grid alignment.
    vec3 color1 = vec3(0.2, 0.7, 0.5);
    vec3 color2 = vec3(0.8, 0.3, 0.4);
    vec3 color3 = vec3(0.4, 0.2, 0.9);
    
    // Use the swirl factor to mix colors in a non-linear way
    vec3 colorMix = mix(color1, color2, blend);
    colorMix = mix(colorMix, color3, 0.5 + 0.5*sin(time + radial * 12.0));
    
    // Apply an additional dynamic overlay with an organic noise pattern
    float overlay = noise(pos * 15.0 + time);
    colorMix += overlay * 0.15;
    
    gl_FragColor = vec4(colorMix, 1.0);
}