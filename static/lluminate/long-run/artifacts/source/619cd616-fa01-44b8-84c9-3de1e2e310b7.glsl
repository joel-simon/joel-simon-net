precision mediump float;
varying vec2 uv;
uniform float time;

// This shader replaces the traditional symbol of the sun—a source of light—with a radiant star,
// emphasizing the trait of radiance. In this cosmic canvas, the star's glow is essential for its existence,
// transforming the swirling sun into a luminous star that drives the vibrant nebula around it.

float starShape(vec2 p, float spikes, float distortion) {
    float r = length(p);
    float a = atan(p.y, p.x);
    float modAngle = mod(a, 6.28318/spikes);
    float edge = cos(modAngle * spikes) * distortion;
    return smoothstep(edge, edge + 0.01, r);
}

void main() {
    // Shift uv coordinates to center and scale
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply time-based rotation to create a swirling cosmic effect
    float angle = time * 0.3;
    float c = cos(angle);
    float s = sin(angle);
    mat2 rot = mat2(c, -s, s, c);
    p = rot * p;
    
    // Convert to polar coordinates for more dynamic star and nebula shapes
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a background nebula pattern using sinusoidal waves
    float nebula = sin(10.0 * a + time) * 0.5 + 0.5;
    nebula *= smoothstep(0.8, 0.4, r);
    
    // Generate a star shape to replace the sun as the light source,
    // emphasizing radiance as the key trait.
    float star = starShape(p, 7.0, 0.3);
    
    // Define color themes: a radiant star center and a cosmic nebula background
    vec3 starColor = vec3(1.0, 0.9, 0.6);
    vec3 nebulaColor = vec3(0.2, 0.1, 0.4) + vec3(nebula * 0.3);
    
    // Mix the star and nebula based on the star shape mask and radial distance.
    vec3 color = mix(nebulaColor, starColor, star);
    
    // Finalize with a soft vignette, drawing attention to the radiant star.
    float vignette = smoothstep(1.0, 0.3, r);
    gl_FragColor = vec4(color * vignette, 1.0);
}