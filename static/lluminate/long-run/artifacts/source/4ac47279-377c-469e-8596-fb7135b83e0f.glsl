precision mediump float;
varying vec2 uv;
uniform float time;

//
// Trait T: Adaptability
// Symbol S: A static grid (typically representing rigidity)
// Subject P: The adaptive, ever-changing chameleon
//
// In this context, we replace the static grid with swirling, organic fractal waves that mimic a chameleon's ability to shift its skin pattern dynamically.
//
float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    // Smooth Interpolation using smoothstep
    vec2 u = smoothstep(0.0, 1.0, f);
    
    // Mix results from corners
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

void main() {
    // Center uv coordinates around (0,0)
    vec2 pos = uv * 2.0 - 1.0;

    // Polar coordinates for swirling dynamics.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);

    // Create a swirling pattern that evolves with time:
    float swirl = sin(5.0 * angle + time + noise(pos * 3.0));
    
    // Generate an adaptive, chameleon-like color blending
    // Use smoothstep to generate soft transitions and mimic a camouflage effect:
    float mask = smoothstep(0.3, 0.5, abs(swirl) + 0.5 * radius);
    
    // Color adjustments: base colors shifting with time
    vec3 color1 = vec3(0.2, 0.6, 0.3); // earthy green
    vec3 color2 = vec3(0.8, 0.4, 0.1); // warm terracotta
    
    // Dynamic mix influenced by time and noise for a lively adaptive effect.
    vec3 color = mix(color1, color2, 0.5 + 0.5 * sin(time + radius * 10.0 + noise(uv * 5.0)));
    
    // Final fragment output with a vignette-like darkening on edges
    float vignette = smoothstep(0.8, 0.3, radius);
    gl_FragColor = vec4(color * mask * vignette, 1.0);
}