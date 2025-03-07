precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash based on 2D input
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    // Cubic interpolation curve (smoothstep)
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Function to simulate particle-like light spots coming from an unrelated domain (e.g., bioluminescent plankton)
float particles(vec2 p, float t) {
    // Create grid of "particles"
    vec2 gv = fract(p) - 0.5;
    vec2 id = floor(p);
    // Animate each particle with time using a hash based delay
    float rnd = hash(id);
    float phase = mod(t + rnd * 6.2831, 6.2831);
    // particle flickers if near center of cell
    float d = length(gv + 0.3 * vec2(cos(phase), sin(phase)));
    return smoothstep(0.3, 0.0, d);
}

void main(void) {
    // Convert UV to centered coordinates [-1, 1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply dynamic swirl rotation with frequency modulation
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Calculate radial distance and angle for swirling background
    float d = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Swirling cosine pattern combined with radial frequency
    float swirl = cos(15.0 * d - time + 3.0 * a);
    vec3 baseColor = vec3(0.4, 0.2, 0.6) + 0.4 * vec3(sin(swirl + time), cos(swirl - time), sin(swirl * 2.0));
    
    // Synthesize with discrete particle field from a contrasting domain (organic, scattered flashes)
    vec2 particlesPos = uv * 10.0; // scale for grid density
    float sparkles = particles(particlesPos, time);
    
    // Additional noise for texture variation
    float n = noise(pos * 3.0 + time);
    
    // Composite final color, blending swirling background with particle sparkles and slight noise modulation.
    vec3 color = baseColor + sparkles * vec3(1.0, 0.8, 0.3) * 0.8 + n * 0.1;
    
    // Soft vignette effect for synthesis of both worlds
    float vignette = smoothstep(0.8, 0.4, d);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}