precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

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

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Digital Grid Concept: Define crisp digital boundaries via a grid.
    vec2 gridPattern = abs(fract(pos * 10.0) - 0.5);
    float grid = 1.0 - step(0.45, min(gridPattern.x, gridPattern.y));
    
    // Organic Flow Concept: Create an organic oscillation pattern.
    float organicWave = sin((pos.x + pos.y) * 3.1415 + time * 2.0);
    organicWave = smoothstep(0.3, 0.5, organicWave);
    
    // Merge the two conceptual spaces using a time-modulated blend factor.
    float blendFactor = 0.5 + 0.5 * sin(time);
    float emergentShape = mix(organicWave, grid, blendFactor);
    
    // Add a slight glitch/noise element to enhance the digital feel.
    emergentShape += 0.1 * noise(pos * 20.0 + time);
    
    // Develop Emergent Aesthetics: Blend organic (earthy green) and neon digital (icy blue) colors.
    vec3 organicColor = vec3(0.2, 0.8, 0.3);
    vec3 digitalColor = vec3(0.1, 0.8, 1.0);
    vec3 finalColor = mix(organicColor, digitalColor, emergentShape);
    
    // Impose a radial soft mask to focus the viewer's attention.
    float mask = smoothstep(1.0, 0.5, length(pos));
    gl_FragColor = vec4(finalColor * mask, 1.0);
}