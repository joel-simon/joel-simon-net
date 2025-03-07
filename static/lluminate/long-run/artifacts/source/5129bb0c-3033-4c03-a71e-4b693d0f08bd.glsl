precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo random function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Create a "bubble" shape based on distance function
float bubble(vec2 pos, vec2 center, float radius) {
    return smoothstep(radius, radius - 0.02, length(pos - center));
}

// Create digital circuit lines (glitchy neon lines)
float digitalLines(vec2 pos, float scale) {
    float line = abs(sin(pos.x * scale + time * 3.0)) * abs(cos(pos.y * scale - time * 2.0));
    return smoothstep(0.3, 0.4, line);
}

void main() {
    // Transform uv coordinates to center-based coordinates (range [-1, 1])
    vec2 pos = uv * 2.0 - 1.0;
    
    // Domain 1: Organic underwater phenomena (bubbles)
    // Create multiple bubbles moving in a vertical drift over time
    float bubblePattern = 0.0;
    // Offset the grid to animate bubbles rising
    vec2 grid = fract(pos * vec2(4.0, 6.0) + vec2(0.0, time * 0.5));
    // Create a bubble at the center of each grid cell with variable radius
    float b = bubble(grid, vec2(0.5), 0.35 + 0.1 * sin(time + pseudoRandom(grid) * 6.28));
    bubblePattern = max(bubblePattern, b);
    
    // Domain 2: Digital circuits (neon glitch lines)
    // Overlay with dynamically moving digital lines reminiscent of circuits
    float circuit = digitalLines(pos, 20.0);
    
    // Synthesize domains: blend organic bubble softness with sharp neon glitch lines
    float combined = mix(bubblePattern, circuit, 0.5 + 0.5 * sin(time * 0.8));
    
    // Color dynamics: use contrasting neon and organic ocean tones
    vec3 oceanColor = vec3(0.0, 0.4, 0.7);  // deep underwater blue
    vec3 neonColor = vec3(0.8, 0.9, 0.2);    // bright neon yellow-green
    vec3 color = mix(oceanColor, neonColor, combined);
    
    // Add soft vignette for focus
    float vignette = smoothstep(1.0, 0.3, length(pos));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}