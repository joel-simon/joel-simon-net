precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoNoise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    // draw_random_card: "Honor thy error as a hidden intention."
    // Transform uv to center-based coordinates
    vec2 centered = uv - 0.5;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    
    // Introduce error via pseudo noise and sine distortions
    float noise = pseudoNoise(centered * 10.0 + time);
    float distortion = sin(time + angle * 5.0) * noise * 0.1;
    float modR = r + distortion;
    
    // Twist the angle to form a spiral-inspired pattern
    float modAngle = angle + 2.0 * noise * sin(time + modR * 10.0);
    
    // Create swirling dynamic wave using sine functions in polar coordinates
    float spiral = sin(modAngle * 7.0 + modR * 20.0 - time * 3.0);
    float spiralMask = smoothstep(0.3, 0.35, abs(modR - 0.5) + spiral * 0.1);
    
    // Additional dynamic wave pattern using basic radial waves
    float wave = sin(10.0 * modR - 3.0 * time + 5.0 * modAngle);
    float band = smoothstep(0.45, 0.5, wave);
    
    // Mix colors based on the computed radii and noise
    vec3 baseColor = vec3(0.1, 0.2, 0.3);
    vec3 highlightColor = vec3(1.0, 0.8, 0.5);
    float mixFactor = smoothstep(0.3, 0.6, modR) + 0.3 * pseudoNoise(vec2(modAngle, modR));
    vec3 color = mix(baseColor, highlightColor, mixFactor);
    
    // Apply glitch effect occasionally
    float glitch = step(0.97, pseudoNoise(vec2(time, modAngle * 3.0)));
    color += glitch * vec3(0.5, 0.1, 0.7);
    
    // Combine both spiral mask and wave band for final composite brightness
    float finalMask = spiralMask * band;
    
    gl_FragColor = vec4(color * finalMask, 1.0);
}