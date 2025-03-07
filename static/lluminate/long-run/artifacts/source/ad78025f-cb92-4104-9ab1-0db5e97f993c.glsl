precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
    // Directive: "Honor thy error as a hidden intention"
    // Interpretation: Embrace noise and glitches as intrinsic parts of the design.
    // Remap uv coordinates from [0,1] to [-1,1]:
    vec2 pos = uv * 2.0 - 1.0;
    
    // Compute polar coordinates:
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // A chaotic swirl: combine sinusoidal modulation with noise perturbation.
    float swirl = sin(radius * 12.0 - time * 2.0) + noise(pos * 5.0 + time);
    float modAngle = angle + swirl * 0.7;
    
    // Generate an unpredictable glitch factor:
    float glitch = noise(vec2(uv.y * 15.0, time * 0.7)) * 0.3;
    
    // Organic fractal-like pulse using polar coordinates:
    float pulse = smoothstep(0.35, 0.36, radius + 0.1 * sin(modAngle * 5.0 + time));
    
    // Create an abstract heart shape using implicit functions:
    float heart = smoothstep(0.4, 0.38, abs(pow(radius, 0.5) - sin(modAngle * 4.0 + time*1.5)*0.6));
    
    // Evolve colors with time: warm vs cool influenced by modAngle and glitch
    vec3 warmColor = vec3(0.9, 0.4, 0.3);
    vec3 coolColor = vec3(0.3, 0.6, 0.9);
    vec3 colorMix = mix(warmColor, coolColor, (sin(modAngle + time) + 1.0) * 0.5);
    
    // Add dynamic background glow using distance from center:
    float glow = 1.0 - smoothstep(0.2, 0.5, length(uv - vec2(0.5)));
    vec3 background = mix(vec3(0.1, 0.2, 0.3), vec3(0.8, 0.7, 0.2), glow);
    
    // Integrate glitch and heart shape into base color:
    vec3 baseColor = colorMix * pulse;
    baseColor += glitch * vec3(0.2, 0.2, 0.2);
    baseColor = mix(baseColor, vec3(0.8, 0.2, 0.5), heart * 0.5);
    
    // Final composition, blending background with the procedural elements:
    vec3 finalColor = mix(background, baseColor, 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}