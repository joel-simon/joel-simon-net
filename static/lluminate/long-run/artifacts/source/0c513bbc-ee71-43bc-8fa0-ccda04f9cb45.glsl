precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
    // Normalize coordinates: center to (0.0, 0.0)
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;
    
    // Compute polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Swirling waves component (inspired by dynamic patterns)
    float wave1 = sin(10.0 * radius - 3.0 * time + 5.0 * angle);
    float wave2 = sin(20.0 * radius - 2.0 * time + 3.0 * angle);
    float wave3 = sin(15.0 * (radius + 0.5 * sin(time)) - 4.0 * angle);
    float combinedWave = (wave1 + wave2 + wave3) / 3.0;
    
    // Grid disruption component (inspired by abrupt glitches)
    vec2 gridUV = uv * 20.0;
    vec2 cell = floor(gridUV);
    vec2 fracPart = fract(gridUV);
    float cellNoise = pseudoRandom(cell + time * 0.5);
    float edgeThreshold = 0.1 + 0.2 * cellNoise;
    vec2 disrupted = step(edgeThreshold, fracPart) * step(edgeThreshold, 1.0 - fracPart);
    float gridOverlay = disrupted.x * disrupted.y;
    
    // Create two dynamic color palettes
    vec3 colorA = vec3(0.5 + 0.5 * cos(time + radius * 10.0 + vec3(0.0, 2.0, 4.0)));
    vec3 colorB = vec3(0.5 + 0.5 * sin(time - radius * 10.0 + vec3(4.0, 2.0, 0.0)));
    vec3 swirlColor = mix(colorA, colorB, smoothstep(-1.0, 1.0, radius));
    
    // Additional glitch effect based on grid overlay and sinusoidal oscillation
    float glitch = step(0.95, abs(sin(time * 3.14159 * gridOverlay * 10.0)));
    vec3 baseColor = mix(swirlColor, vec3(0.0), glitch);
    
    // Apply vignette for depth
    float vignette = smoothstep(0.8, 0.2, radius);
    baseColor *= vignette;
    
    // Enhance overall intensity by modulating with the combined wave
    float intensity = smoothstep(0.3, 0.5, combinedWave) - smoothstep(0.7, 0.8, combinedWave);
    
    gl_FragColor = vec4(baseColor * intensity, 1.0);
}