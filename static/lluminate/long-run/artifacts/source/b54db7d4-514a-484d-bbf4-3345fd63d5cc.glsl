precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

void main() {
    // Anchor concept: "organically mechanical"
    // Use polar coordinates with medium-distance association with circuit patterns
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.2; // Adjust aspect ratio
    
    // Convert to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Medium-distance idea: mechanical pulses that evoke circuitry 
    // (using sine modulation combined with noise patterns)
    float pulse = sin(8.0 * radius - time * 2.5 + 4.0 * angle);
    float circuit = noise(pos * 5.0 + vec2(time, time));
    float modulation = smoothstep(0.2, 0.5, circuit) * pulse;
    
    // Base color mix: Using a blend inspired by nature and technology
    vec3 organicColor = vec3(0.2, 0.6, 0.4) + 0.5 * vec3(sin(time + radius * 20.0), cos(time + angle * 3.0), sin(angle - time));
    vec3 techColor = vec3(0.8, 0.3, 0.1) + 0.4 * vec3(cos(time * 1.5 + radius * 15.0), sin(time * 2.0 - angle * 2.0), cos(angle + time));
    vec3 finalColor = mix(organicColor, techColor, smoothstep(0.0, 1.0, radius));
    
    // Add dynamic glitch-like circuitry texture overlay
    float glitch = pseudoRandom(uv * 50.0 + time);
    float mask = smoothstep(0.3, 0.4, glitch);
    finalColor += modulation * mask;
    
    // Add subtle vignette for depth
    float vignette = smoothstep(1.0, 0.2, radius);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}