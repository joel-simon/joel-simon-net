precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898,78.233))) * 43758.5453);
}

void main() {
    // Map from [0,1] to centered coordinates [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Compute polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Domain 1: Cosmic spirals (space imagery)
    float spiral = sin(6.0 * (a + time * 0.5) + r * 10.0);
    
    // Domain 2: Organic cellular pulses (biology domain)
    float cell = sin(20.0 * r - time * 3.0);
    cell = smoothstep(0.0, 0.05, abs(cell));
    
    // Introduce randomness inspired by digital static (unrelated domain)
    float grain = rand(pos * time);
    grain = smoothstep(0.45, 0.55, grain);
    
    // Synthesize elements: combine spiral, cell, and random grain
    float mixPattern = mix(spiral, cell, 0.5) + grain * 0.2;
    
    // Create a color mapping based on radial distance and pattern mix
    vec3 color = vec3(
        sin(mixPattern + time * 0.3 + r * 3.0),
        cos(mixPattern - time * 0.4 + r * 3.0),
        sin(mixPattern + time * 0.5 - r * 3.0)
    );
    
    // Apply a vignette effect using smooth radial falloff
    float vignette = smoothstep(0.8, 0.5, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}