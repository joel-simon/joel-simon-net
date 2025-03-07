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

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec3 circuitEvolution(vec2 pos, float t) {
    // Step 1: identify_trait (Evolution/Adaptation)
    // Step 2: find_symbol (Tree) typically symbolizing organic growth
    // Step 3: create_context: In digital realms, evolution is essential for circuit connectivity.
    // Step 4: replace: Replace "tree" with "circuit pattern" where evolution ensures signal integrity.
    
    // Transform coordinate space to polar for radial patterns.
    vec2 centered = (pos - 0.5) * 2.0;
    float r = length(centered);
    float angle = atan(centered.y, centered.x);
    
    // Replace branch factors with circuit connectivity.
    float circuitBase = smoothstep(0.3, 0.8, fbm(pos * 10.0 + t * 0.5));
    
    // Introduce evolving glitch lines as digital circuit traces.
    float circuitTrace = abs(sin(10.0 * angle + t + fbm(pos * 15.0) * 6.28));
    float digitalPulse = step(0.8, circuitTrace) * smoothstep(0.0, 0.5, circuitBase);
    
    // Modulate with evolving radial signal that mimics active circuit nodes.
    float nodeSignal = smoothstep(0.2, 0.0, abs(r - fbm(pos * 8.0 + t * 0.3)));
    
    // Color blending: Replace organic tree colors with digital neon circuitry.
    vec3 circuitColor = mix(vec3(0.0, 0.15, 0.2), vec3(0.0, 1.0, 0.8), circuitBase);
    circuitColor += digitalPulse * vec3(0.5, 0.0, 0.5);
    circuitColor += nodeSignal * vec3(0.9, 0.9, 0.1);
    
    // Apply additional distortion based on radial distance.
    circuitColor *= smoothstep(1.0, 0.3, r);
    
    return circuitColor;
}

void main(void) {
    // Apply subtle time based scale and rotation
    vec2 pos = uv;
    float scale = 1.0 + 0.2 * sin(time * 1.7);
    float angleOffset = time * 0.3;
    vec2 centered = pos - 0.5;
    float ca = cos(angleOffset);
    float sa = sin(angleOffset);
    mat2 rot = mat2(ca, -sa, sa, ca);
    centered = rot * centered * scale;
    pos = centered + 0.5;
    
    vec3 color = circuitEvolution(pos, time);
    
    gl_FragColor = vec4(color, 1.0);
}