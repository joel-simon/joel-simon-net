precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // draw_random_card: "Honor thy error as a hidden intention."
    // interpret_directive: Use inherent "errors" or glitches as creative features.
    // apply_insight: Generate unexpected artifacts by intentionally perturbing transformations.
    
    // Center coordinates at (0,0)
    vec2 pos = uv - 0.5;
    
    // Calculate polar coordinates with a twist
    float r = length(pos);
    float phi = atan(pos.y, pos.x);
    
    // Introduce a "glitch" based on time and spatial position to honor inherent errors
    float glitch = sin(time * 5.0 + r * 20.0) * 0.2;
    float newPhi = phi + glitch;
    
    // Distort the wave pattern by swapping roles: use radius to inform angular modulation
    float wave = sin((r * 15.0) - (time * 2.5));
    
    // Construct color channels using the perturbed angle and unexpected mix
    vec3 color = vec3(
        0.5 + 0.5 * sin(newPhi * 3.0 + time + 0.0),
        0.5 + 0.5 * sin(newPhi * 3.0 + time + 2.0),
        0.5 + 0.5 * sin(newPhi * 3.0 + time + 4.0)
    );
    
    // Mix an alternative color interpretation based on position and the glitch factor
    vec3 altColor = vec3(r, (newPhi / 3.1416), 1.0 - r);
    color = mix(color, altColor, 0.5 + glitch);
    
    // Apply the wave modulation to enhance the glitch-inspired dynamics
    color *= 0.5 + 0.5 * wave;
    
    gl_FragColor = vec4(color, 1.0);
}