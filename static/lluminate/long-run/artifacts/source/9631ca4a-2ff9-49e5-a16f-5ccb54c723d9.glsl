precision mediump float;
varying vec2 uv;
uniform float time;

void main() {
    // Transform uv to center-based coordinates
    vec2 pos = uv * 2.0 - 1.0;
    
    // Calculate polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Apply a random cryptic directive: "Honor thy error as a hidden intention"
    // Interpret this as blending subtle "errors" from multiple sine waves.
    float wave1 = sin(10.0 * radius - 3.0 * time + 5.0 * angle);
    float wave2 = sin(15.0 * (radius + 0.5 * sin(time)) - angle * 4.0);
    float wave3 = sin(20.0 * (radius - 0.3 * cos(time)) + 7.0 * angle);
    
    // Combine waves to build an organic swirling effect
    float combinedWave = (wave1 + wave2 + wave3) / 3.0;
    
    // Enhance banding and contrast
    float intensity = smoothstep(0.3, 0.5, combinedWave) - smoothstep(0.7, 0.8, combinedWave);
    
    // Color interpolation based on radius and angle with time-driven palette shifts
    vec3 color = vec3(0.5 + 0.5 * cos(time + radius * 10.0 + vec3(0.0, 2.0, 4.0)));
    
    // Introduce a vignetting effect
    float vignette = smoothstep(0.8, 0.3, radius);
    color *= vignette;
    
    // Final color mix with intensity modulating the brightness
    gl_FragColor = vec4(color * intensity, 1.0);
}