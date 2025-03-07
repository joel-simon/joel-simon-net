precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * pseudoRandom(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

float urbanGrid(vec2 pos) {
    // Create a grid pattern representing urban architecture:
    // Amplify the grid frequency and provide soft edges for building outlines.
    vec2 grid = abs(fract(pos * 10.0) - 0.5);
    float lineX = smoothstep(0.45, 0.5, grid.x);
    float lineY = smoothstep(0.45, 0.5, grid.y);
    return lineX * lineY;
}

float organicPulse(vec2 pos) {
    // Create an organic, wavy pattern mimicking natural growth rhythms.
    float wave = sin(pos.x * 8.0 + time * 2.0) * cos(pos.y * 8.0 + time * 1.5);
    float noise = fbm(pos * 2.0 + time);
    return wave * noise;
}

void main() {
    // Map uv from [0,1] to [-1,1] space.
    vec2 pos = uv * 2.0 - 1.0;
    
    // Create an urban grid pattern texture.
    float gridPattern = urbanGrid(pos);
    
    // Generate an organic pulse texture.
    float pulsePattern = organicPulse(pos + fbm(pos * 3.0));
    
    // Synthesize both domains by combining grid patterns and organic pulses.
    float mixFactor = 0.5 + 0.5 * sin(time + pulsePattern * 3.1416);
    float combinedPattern = mix(pulsePattern, gridPattern, mixFactor);
    
    // Define color dynamics for both domains:
    // Urban grid: cool, structured blue tones.
    vec3 urbanColor = vec3(0.2, 0.35, 0.55) + 0.15 * vec3(fbm(pos * 5.0));
    // Organic field: warm, vibrant hues.
    vec3 organicColor = vec3(0.8, 0.45, 0.3) + 0.15 * vec3(organicPulse(pos * 1.5));
    
    // Final color mix: blend based on combined synthesized pattern.
    vec3 finalColor = mix(organicColor, urbanColor, combinedPattern);
    
    gl_FragColor = vec4(finalColor, 1.0);
}