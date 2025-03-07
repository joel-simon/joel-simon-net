precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

// Organic noise function based on layered sine waves
float organicNoise(vec2 p) {
    float n = sin(p.x * 10.0 + time) * sin(p.y * 10.0 + time);
    n *= 0.5 + 0.5 * sin(time * 0.5);
    return n;
}

// Glitch distortion: abrupt offset using random jumps in grid
vec2 glitch(vec2 p) {
    float gridSize = 0.1;
    vec2 grid = floor(p / gridSize);
    float offset = rand(grid) * 0.3;
    p.x += offset;
    return p;
}

// Blended emergent structure from organic and glitch spaces
vec3 emergentStructure(vec2 p) {
    // Map from [0,1] to [-1,1] for organic swirling effect
    vec2 pos = p * 2.0 - 1.0;
    
    // Convert to polar coordinates for swirl effect
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Organic swirling pattern modified by time
    float swirl = sin(6.0 * a + time) * cos(4.0 * r - time);
    
    // Apply glitch distortion to original uv for grid artifact
    vec2 glitchUV = glitch(p);
    
    // Organic noise on glitch-distorted uv
    float org = organicNoise(glitchUV * 3.0);
    
    // Blend two conceptual spaces with selective mixing: 
    // one defined by swirl and the other by organic glitch noise.
    float blend = mix(swirl, org, 0.5);
    
    // Emergent property: radial gradient modulated by blend factor.
    vec3 cosmic = vec3(0.1, 0.2, 0.5) + 0.5 * vec3(sin(blend * 3.14 + time),
                                                   cos(blend * 3.14 - time),
                                                   sin(blend * 3.14 * 0.5));
    cosmic *= smoothstep(1.0, 0.0, r);
    return cosmic;
}

void main() {
    vec2 pos = uv;
    // Slight panning effect using time
    pos.x += 0.05 * sin(time * 0.8);
    pos.y += 0.05 * cos(time * 1.1);
    
    vec3 color = emergentStructure(pos);
    
    gl_FragColor = vec4(color, 1.0);
}