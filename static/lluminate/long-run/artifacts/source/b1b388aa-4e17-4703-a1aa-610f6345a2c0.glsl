precision mediump float;
varying vec2 uv;
uniform float time;

// Function to create a pulsating brain-like fractal structure by replacing a heart symbol 
// with a neural network motif in a context where connectivity (a key trait) is essential.
float brainFractal(vec2 p) {
    // Normalize coordinates centered at 0.5
    p = (p - 0.5) * 2.0;
    
    // Rotate coordinates with time to simulate neural pulse
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    p = mat2(c, -s, s, c) * p;
    
    // Create multiple layers of oscillating curves to mimic complex neural networks
    float accum = 0.0;
    float freq = 3.0;
    float amp = 0.25;
    for (int i = 0; i < 5; i++) {
        float d = length(p);
        float wave = sin(freq * (p.x + p.y) + time * 2.0);
        accum += smoothstep(0.5, 0.0, abs(d - amp * wave));
        freq *= 1.5;
        amp *= 0.7;
    }
    
    // Enhance connectivity by emphasizing intersecting curves
    return clamp(accum, 0.0, 1.0);
}

void main() {
    // Background: subtle gradient mimicking the electric field necessary for brain activity
    float dist = length(uv - vec2(0.5));
    vec3 bgColor = mix(vec3(0.0, 0.0, 0.1), vec3(0.05, 0.05, 0.2), smoothstep(0.0, 0.7, dist));
    
    // Compute the brain fractal structure
    float brain = brainFractal(uv);
    
    // Use color interpolation to produce a high-tech neural vibe
    vec3 neuralColor = mix(vec3(0.6, 0.1, 0.8), vec3(0.1, 0.8, 0.6), uv.y + 0.5 * sin(time));
    
    // Composite the fractal neural structure with the background
    vec3 finalColor = mix(bgColor, neuralColor, brain);
    
    gl_FragColor = vec4(finalColor, 1.0);
}