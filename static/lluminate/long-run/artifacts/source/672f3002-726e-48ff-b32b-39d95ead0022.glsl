precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main(void) {
    // Center coordinates and polar conversion
    vec2 pos = uv - 0.5;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Create a dynamic wave and glitched petal effect using both structured and random elements
    float wave = sin(radius * 20.0 - time * 5.0);
    float glitch = random(uv * time) * 0.3;
    
    // Synthesize structured color gradients with a touch of randomness
    float pulse = abs(sin(10.0 * (1.0 - radius) + time * 2.0 + glitch));
    float modulatedAngle = angle + pulse * 3.0;

    // Color blending and dynamic color mixing using polar coordinates and time
    vec3 baseColor = vec3(0.5 + 0.5 * cos(modulatedAngle + time),
                          0.5 + 0.5 * sin(modulatedAngle * 1.5 - time),
                          0.5 + 0.5 * cos((1.0 - radius) * 12.0 - time));
                          
    // Generate additional grid/spiral fragment using sine waves
    float ring = smoothstep(0.48, 0.5, abs(sin(radius * 20.0 - time)));
    vec3 spiralColor = 0.5 + 0.5 * cos(vec3(angle, angle + 2.0, angle + 4.0) + time);
    
    // Blend collection ideas: structured spiral elements with organic petal effects and glitch noise
    vec3 colorMix = mix(baseColor, spiralColor, 0.5 + 0.5 * sin(time));
    colorMix = mix(colorMix, vec3(1.0, 0.8, 0.3), ring);

    // Optional vignette for depth
    float vignette = smoothstep(0.6, 0.3, radius);
    colorMix *= vignette * (0.7 + 0.3 * wave);
    
    gl_FragColor = vec4(colorMix, 1.0);
}