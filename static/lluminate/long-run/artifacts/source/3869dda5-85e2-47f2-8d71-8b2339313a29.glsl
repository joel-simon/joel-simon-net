precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 2D Noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Glitch effect function
float glitch(vec2 st, float intensity) {
    float t = time * 0.5;
    float shift = step(0.95, random(vec2(t, st.y))) * intensity;
    return shift;
}

void main() {
    // Center uv coordinates
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;
    
    // Polar coordinates
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Swirling waves dynamics
    float wave1 = sin(10.0 * r - 3.0 * time + 5.0 * angle);
    float wave2 = sin(20.0 * r - 2.0 * time + 3.0 * angle);
    float wave3 = sin(15.0 * (r + 0.5 * sin(time)) - 4.0 * angle);
    float combinedWave = (wave1 + wave2 + wave3) / 3.0;
    
    // Introduce a glitch distortion using noise
    float glitchEffect = (random(pos * time) - 0.5) * 0.2;
    combinedWave += glitchEffect;
    
    // Organic swirling modulation with layered noise
    float layeredNoise = noise(pos * 2.0 + time * 0.5);
    float swirl = sin(10.0 * r - time + 3.0 * angle) * layeredNoise * 0.3;
    
    // Merge digital glitch grid effect
    vec2 grid = fract(uv * 20.0 - time);
    float pixelBlock = step(0.8, grid.x) * step(0.8, grid.y);
    
    // Color gradient using two dynamic color schemes
    vec3 colorA = vec3(0.5 + 0.5 * cos(time + r * 10.0 + vec3(0.0, 2.0, 4.0)));
    vec3 colorB = vec3(0.5 + 0.5 * sin(time - r * 10.0 + vec3(4.0, 2.0, 0.0)));
    vec3 baseColor = mix(colorA, colorB, smoothstep(0.0, 1.0, r));
    
    // Blend in the pixel block glitch effect
    baseColor += vec3(pixelBlock * 0.2);
    baseColor += swirl * 0.3;
    
    // Apply a vignette for depth
    float vignette = smoothstep(0.8, 0.2, r);
    baseColor *= vignette;
    
    // Enhance contrast with a smooth intensity modulation from the combined wave effect
    float intensity = smoothstep(0.3, 0.5, combinedWave) - smoothstep(0.7, 0.8, combinedWave);
    
    gl_FragColor = vec4(baseColor * intensity, 1.0);
}