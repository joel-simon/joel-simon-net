precision mediump float;
varying vec2 uv;
uniform float time;

// Function to rotate a point
vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Pseudo random noise function
float noise(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// Create a wiggle pattern mimicking brain convolutions
float brainWaves(vec2 pos, float t) {
    float pattern = 0.0;
    // Multiple frequencies for convolution effect
    pattern += sin(8.0 * pos.x + t);
    pattern += sin(8.0 * pos.y - t);
    pattern += sin(6.0 * (pos.x+pos.y) + t * 1.5);
    return pattern * 0.05;
}

void main() {
    // Normalize coordinates (centered and aspect corrected)
    vec2 pos = uv * 2.0 - 1.0;
    
    // Creative idea:
    // Replace the traditional lightbulb (symbol of ideas) with a brain,
    // where intellect (trait) is key for illumination.
    // Draw a lightbulb shape and infuse brain-like convolutions.
    
    // Convert to polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Lightbulb outline: a rounded shape with a slight narrowing at the bottom
    // Modify radius threshold to mimic bulb structure
    float bulbRadius = 0.5 + 0.1 * sin(time * 0.5);
    float bulbShape = smoothstep(bulbRadius, bulbRadius - 0.02, radius);
    
    // Add a neck to the bulb to resemble a lightbulb base
    float neck = smoothstep(0.3, 0.32, -pos.y - 0.6);
    bulbShape = max(bulbShape, neck);
    
    // Add internal brain-like waves inside the bulb
    float waves = brainWaves(pos * 3.0, time);
    // Create an internal detail effect that oscillates with the pattern
    float detail = smoothstep(bulbRadius - 0.08 + waves, bulbRadius - 0.1 + waves, radius);
    
    // Combine the shapes: the bulb outline and the internal brain patterns
    float finalShape = bulbShape - detail;
    
    // Color palette:
    // Outside: dark background.
    // Inside bulb: warm glowing yellow to evoke illumination.
    // Brain curves: shading with soft gray tones.
    vec3 bulbColor = mix(vec3(0.2, 0.2, 0.2), vec3(1.0, 0.85, 0.4), detail);
    
    // Final color modulation with time-based pulsation.
    bulbColor *= 0.5 + 0.5 * sin(time + radius * 10.0);
    
    gl_FragColor = vec4(bulbColor * finalShape, 1.0);
}