precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Domain: undersea coral growth (organic, fractal nature)
// Domain: digital circuit boards (grid, pixel glitches)
// Synthesize organic fractal tendrils with digital grid interruptions.

vec3 coralCircuit(vec2 pos, float t) {
    // Organic coral-like growth via fbm
    float organic = fbm(pos * 3.0 + vec2(0.0, t * 0.2));
    // Digital circuit grid pattern
    vec2 grid = fract(pos * 10.0);
    float circuit = step(0.2, grid.x) * step(0.2, grid.y);
    // Introduce glitch: digital interruptions from pseudo randomness
    float glitch = smoothstep(0.3, 0.7, pseudoRandom(pos * t));
    
    // Synthesize both: blend organic fractal pattern with circuit grid disruptions.
    float mask = organic * (1.0 - glitch) + circuit * glitch;
    
    // Map mask to colors: organic coral in warm hues, circuits in cool electric blues.
    vec3 organicColor = vec3(0.8, 0.4, 0.2) * organic;
    vec3 circuitColor = vec3(0.2, 0.6, 0.9) * circuit;
    
    return mix(organicColor, circuitColor, mask);
}

vec3 digitalWave(vec2 pos, float t) {
    // Additional touch: modulate a digital interference wave over the scene.
    float wave = sin((pos.y + t) * 20.0) * 0.5 + 0.5;
    vec3 waveColor = vec3(wave * 0.1, wave * 0.2, wave * 0.3);
    return waveColor;
}

void main(){
    vec2 pos = uv;
    // Slight rotation to introduce dynamic movement
    float angle = sin(time * 0.5) * 0.2;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * (pos - 0.5) + 0.5;
    
    // Synthesize the coral growth with circuit interruptions
    vec3 baseColor = coralCircuit(pos, time);
    // Add a digital wave interference layer
    vec3 waveLayer = digitalWave(pos, time);
    
    // Combine layers with subtle brightness modulation and time evolution
    vec3 finalColor = baseColor + waveLayer;
    finalColor = mix(finalColor, vec3(0.1,0.1,0.1), 0.1 * sin(time));
    
    gl_FragColor = vec4(finalColor, 1.0);
}