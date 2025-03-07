precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
    vec2 pos = uv * 2.0 - 1.0;
    pos.x *= 1.5;
    
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Dynamic swirling waves
    float wave1 = sin(10.0 * radius - 3.0 * time + 5.0 * angle);
    float wave2 = sin(20.0 * radius - time * 2.0 + angle * 3.0);
    float wave3 = sin(15.0 * (radius + 0.5 * sin(time)) - 4.0 * angle);
    float combinedWave = (wave1 + wave2 + wave3) / 3.0;
    
    // Adding glitch effect using pseudorandom noise
    combinedWave += (pseudoRandom(pos * time) - 0.5) * 0.2;
    
    // Color dynamics: base swirling colors with gradients
    vec3 colorA = vec3(0.5 + 0.5 * cos(time + radius * 10.0 + vec3(0.0, 2.0, 4.0)));
    vec3 colorB = vec3(0.5 + 0.5 * sin(time - radius * 10.0 + vec3(4.0, 2.0, 0.0)));
    vec3 color = mix(colorA, colorB, smoothstep(-1.0, 1.0, radius));
    
    // Modulate swirling offset
    float swirl = sin(10.0 * radius - time + 3.0 * angle);
    color += swirl * 0.3;
    
    // Apply vignette for depth
    float vignette = smoothstep(0.8, 0.2, radius);
    color *= vignette;
    
    // Enhance contrast using smoothstep on combined wave intensity
    float intensity = smoothstep(0.3, 0.5, combinedWave) - smoothstep(0.7, 0.8, combinedWave);
    
    gl_FragColor = vec4(color * intensity, 1.0);
}