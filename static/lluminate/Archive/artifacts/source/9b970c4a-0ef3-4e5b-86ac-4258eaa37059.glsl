precision mediump float;
varying vec2 uv;
uniform float time;

void main(){
    vec2 pos = uv - 0.5;
    float radial = length(pos) * 2.0;
    float angle = atan(pos.y, pos.x);
    
    // Create a swirling effect that evolves over time
    float swirl = angle + radial * 1.5 - time * 0.75;
    float pattern = smoothstep(0.45, 0.55, fract(swirl * 3.0));
    
    // Generate a dynamic wave pattern based on radial distance and angle
    float wave = sin(time + radial * 12.0 + angle * 4.0);
    
    // Mix two distinctive color palettes using the wave animation
    vec3 colorA = vec3(0.2, 0.3, 0.8);
    vec3 colorB = vec3(0.9, 0.5, 0.2);
    vec3 baseColor = mix(colorA, colorB, wave * 0.5 + 0.5);
    
    // Add an extra layer of color complexity with the swirl pattern
    vec3 overlay = vec3(pattern, pattern * 0.7, 1.0 - pattern);
    vec3 finalColor = baseColor + 0.35 * overlay;
    
    gl_FragColor = vec4(finalColor, 1.0);
}