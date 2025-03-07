precision mediump float;
varying vec2 uv;
uniform float time;

// Basic pseudo-random function
float noise(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise with smoothing
float smoothNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of a tile
    float a = noise(i);
    float b = noise(i + vec2(1.0, 0.0));
    float c = noise(i + vec2(0.0, 1.0));
    float d = noise(i + vec2(1.0, 1.0));
    // Smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Fractal Brownian Motion for organic texture
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 4; i++){
        value += amplitude * smoothNoise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Symbolic function: Replacing a heart symbol (typically emblematic of love/emotion)
// with a brain-like network pattern to highlight creativity and complexity.
// The brain network evolves organically over time, emphasizing fluid connections.
float brainNetwork(vec2 pos, float t) {
    // Create a basic central structure by modulating distance
    float r = length(pos);
    float base = smoothstep(0.4, 0.38, r);
    
    // Introduce organic noise to simulate neural branches
    float branches = fbm(pos * 8.0 + t * 0.5);
    
    // Use sine waves to imitate periodic neural firing connections,
    // modulated by the angular coordinate.
    float angle = atan(pos.y, pos.x);
    float neurons = sin(6.0 * angle + t * 2.0);
    
    // Combine effects: base structure with branching noise and neural firing.
    float network = base + 0.5 * smoothstep(0.3, 0.35, branches + neurons);
    return network;
}

void main() {
    // Shift UV coordinates to center and scale up for detail.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Emphasize the trait "creative complexity" found in the brain,
    // replacing a stereotypical heart symbol.
    // Here, neural network patterns function as the central creative symbol.
    float network = brainNetwork(pos, time);
    
    // Create a background dynamic organic texture
    float background = fbm(pos * 3.0 - time * 0.3);
    
    // Color dynamics: vibrant and shifting hues representing creative energy.
    vec3 brainColor = vec3(0.2, 0.6, 0.8) + 0.3 * vec3(sin(time + pos.x), sin(time + pos.y), cos(time));
    vec3 bgColor = vec3(0.1, 0.0, 0.2) + background * 0.5;
    
    // Blend the dynamic brain network (subject) with a subtle background.
    // The network is most visible where its intensity exceeds a threshold.
    float mask = smoothstep(0.45, 0.5, network);
    vec3 finalColor = mix(bgColor, brainColor, mask);
    
    // Vignette to draw focus towards the center.
    float vignette = smoothstep(1.2, 0.3, length(pos));
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}