precision mediump float;
varying vec2 uv;
uniform float time;

//
// Pseudo-random function
//
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

//
// 2D Noise function
//
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

//
// Glitch effect function
//
float glitch(vec2 st, float intensity) {
    float t = time * 0.5;
    float shift = step(0.95, random(vec2(t, st.y))) * intensity;
    return shift;
}

//
// Main shader combining swirling dynamics, fractal noise, grid glitch and organic symbolic transformation.
// Creative Strategy:
//   Identify trait: "Introspection"
//   Find symbol: A heart normally symbolizes love.
//   Create context: In a digital realm, an organic brain must pulse with introspection.
//   Replace: Replace the heart shape with a brain-like pattern where swirling, fractal pulses
//            generate organic brain curves.
//
void main(void) {
    // Center uv in [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;
    
    // Polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Swirling waves dynamics combining multiple sine functions for complexity
    float wave1 = sin(10.0 * r - 3.0 * time + 5.0 * angle);
    float wave2 = sin(20.0 * r - 2.0 * time + 3.0 * angle);
    float combinedWave = (wave1 + wave2) / 2.0;
    
    // Organic brain-like pattern: modulate a pseudo heart curve using fractal noise and sine functions.
    float brainCurve = smoothstep(0.35, 0.32, abs(pow(r, 0.5) - sin(angle * 4.0 + time * 1.5) * 0.5));
    float fractalDetail = noise(pos * 3.0 + time);
    float brainPattern = brainCurve * (0.5 + 0.5 * fractalDetail);
    
    // Glitch artifact using noise and grid distortion
    vec2 grid = fract(uv * 20.0 - time);
    float pixelBlock = step(0.8, grid.x) * step(0.8, grid.y);
    float glitchEffect = (random(pos * time) - 0.5) * 0.2;
    combinedWave += glitchEffect;
    
    // Dynamic color gradients using time and radius variations
    vec3 colorA = vec3(0.5 + 0.5 * cos(time + r * 10.0 + vec3(0.0, 2.0, 4.0)));
    vec3 colorB = vec3(0.5 + 0.5 * sin(time - r * 10.0 + vec3(4.0, 2.0, 0.0)));
    vec3 baseColor = mix(colorA, colorB, smoothstep(0.0, 1.0, r));
    
    // Introduce layered swirl using additional sin modulation
    float layeredSwirl = sin(8.0 * r - time + 3.0 * angle) * noise(pos * 2.0 + time * 0.3);
    baseColor += layeredSwirl * 0.3;
    
    // Blend in glitch grid effect
    baseColor += vec3(pixelBlock * 0.2);
    
    // Create a vignette for depth
    float vignette = smoothstep(0.8, 0.2, r);
    baseColor *= vignette;
    
    // Enhance the pattern intensity using the combined wave effect and organic brain pattern.
    float intensity = smoothstep(0.3, 0.5, combinedWave) - smoothstep(0.7, 0.8, combinedWave);
    vec3 organicPattern = mix(baseColor, vec3(1.0, 0.3, 0.5), brainPattern * 0.5);
    
    gl_FragColor = vec4(organicPattern * intensity, 1.0);
}