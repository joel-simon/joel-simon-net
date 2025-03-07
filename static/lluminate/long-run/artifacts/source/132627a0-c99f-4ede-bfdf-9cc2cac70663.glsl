precision mediump float;
varying vec2 uv;
uniform float time;

// A simple pseudo-random generator based on uv coordinates.
float rand(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// A noise function to introduce organic randomness.
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Function generating a fractal brain-wiring pattern, replacing the common lightbulb symbol (for ideas)
// with an intricate neural network, symbolizing profound intelligence.
float brainSignal(vec2 pos, float t) {
    // Center and scale coordinates to introduce swirling dynamics.
    vec2 p = pos - 0.5;
    float angle = atan(p.y, p.x);
    float radius = length(p);
    
    // Create spiral waves to simulate neural pathways.
    float spiral = sin(12.0 * radius - 4.0 * angle + t * 3.0);
    
    // Mix in noise for organic disruption.
    float organic = noise(pos * 8.0 + t);
    
    // Combine spiral and noise patterns.
    float signal = smoothstep(0.3, 0.5, abs(spiral)) * organic;
    return signal;
}

// Color modulation function: builds a palette from deep purples to electric blues,
// mixing in a reddish glow to suggest neural activity.
vec3 brainColor(vec2 pos, float t) {
    vec3 base = vec3(0.05, 0.02, 0.1);
    vec3 neural = vec3(0.5, 0.1, 0.7);
    vec3 spark = vec3(0.9, 0.3, 0.2);
    
    // Compute the brain pattern intensity.
    float intensity = brainSignal(pos, t);
    
    // Create a radial gradient: more intense in the center as if focused neural activity.
    float radial = smoothstep(0.5, 0.15, distance(pos, vec2(0.5)));
    
    // Blend colors based on intensity and radial falloff.
    vec3 color = mix(base, neural, intensity);
    color = mix(color, spark, radial * intensity);
    return color;
}

void main() {
    // Introduce a subtle animated distortion replacing the common lightbulb symbol (icon for ideas)
    // with a detailed brain network, conveying that real insight comes from complex neural activity.
    vec2 pos = uv;
    
    // Apply a gentle zoom and camera pan effect over time.
    pos = (pos - 0.5) * (1.0 + 0.2 * sin(time * 0.8)) + 0.5;
    
    // Synthesize an intricate scene of neural signals.
    vec3 finalColor = brainColor(pos, time);
    
    gl_FragColor = vec4(finalColor, 1.0);
}