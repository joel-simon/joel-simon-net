precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    // Transform uv to center coordinates
    vec2 pos = uv * 2.0 - 1.0;
    
    // Polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Generate dynamic waves blending glitches and smooth transitions
    float wave1 = sin(10.0 * radius - 3.0 * time + 5.0 * angle);
    float wave2 = sin(15.0 * (radius + 0.5 * sin(time)) - 4.0 * angle);
    float wave3 = sin(20.0 * (radius - 0.3 * cos(time)) + 7.0 * angle);
    
    // Combine waves with randomness to celebrate imperfections
    float combinedWave = (wave1 + wave2 + wave3) / 3.0;
    combinedWave += (pseudoRandom(pos * time) - 0.5) * 0.2;
    
    // Enhance contrast with smooth step functions
    float intensity = smoothstep(0.3, 0.5, combinedWave) - smoothstep(0.7, 0.8, combinedWave);
    
    // Create swirling effect on color using polar coordinates and time
    vec3 colorA = vec3(0.5 + 0.5 * cos(time + radius * 10.0 + vec3(0.0, 2.0, 4.0)));
    vec3 colorB = vec3(0.5 + 0.5 * sin(time - radius * 10.0 + vec3(4.0, 2.0, 0.0)));
    vec3 color = mix(colorA, colorB, smoothstep(0.0, 1.0, radius));
    
    // Introduce a swirling modulation offset
    float swirl = sin(10.0 * radius - time + 3.0 * angle);
    color += swirl * 0.3;
    
    // Apply a vignette for depth
    float vignette = smoothstep(0.8, 0.2, radius);
    color *= vignette;
    
    // Final output with intensity blend
    gl_FragColor = vec4(color * intensity, 1.0);
}