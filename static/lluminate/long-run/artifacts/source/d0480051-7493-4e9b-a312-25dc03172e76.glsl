precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

// Domain 1: Cosmic Swirl – an evolving, swirling pattern
float cosmicSwirl(vec2 p, float t) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    // Modify the angle with a time-varying twist and radial dependency
    float twist = sin(r * 10.0 - t * 2.0);
    float pattern = sin(angle * 5.0 + twist);
    // Create soft boundaries that fade with radius
    return smoothstep(0.0, 0.1, pattern) * (1.0 - smoothstep(0.3, 0.5, r));
}

// Domain 2: Crystal Lattice – a grid-like, angular structure with emergent distortions
float crystalLattice(vec2 p, float t) {
    // Create a grid pattern
    vec2 gv = fract(p * 5.0) - 0.5;
    // Introduce a pulsating distortion
    float d = length(gv);
    float grid = smoothstep(0.3, 0.28, d);
    // Add a pseudo-random jitter for crystalline imperfections
    float jitter = (rand(floor(p * 5.0)) - 0.5) * 0.2;
    // Combine grid with jitter and time-based modulation
    return grid * smoothstep(0.0, 0.1, abs(jitter + sin(t + d * 10.0)));
}

void main() {
    // Normalize and center coordinates: p in [-1,1]
    vec2 p = uv * 2.0 - 1.0;
    
    // Apply a rotation to p based on time for global dynamics
    float s = sin(time * 0.5);
    float c = cos(time * 0.5);
    p = vec2(p.x * c - p.y * s, p.x * s + p.y * c);
    
    // Map the two domains:
    // Domain A: Cosmic Swirl pattern
    float swirl = cosmicSwirl(p, time);
    
    // Domain B: Crystal Lattice pattern, using distorted coordinates
    vec2 pCrystal = p;
    pCrystal += vec2(sin(p.y * 3.0 + time), cos(p.x * 3.0 - time)) * 0.1;
    float crystal = crystalLattice(pCrystal, time);
    
    // Blend the two domains to form an emergent pattern:
    // Use a blending factor that depends on distance from center
    float blendFactor = smoothstep(0.2, 0.8, length(p));
    float emergent = mix(swirl, crystal, blendFactor);
    
    // Color synthesis:
    // Domain A: cool cosmic hues
    vec3 cosmicColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.2, 0.5, 0.8), swirl);
    // Domain B: crystalline warm tones with sharp contrasts
    vec3 crystalColor = mix(vec3(0.3, 0.1, 0.0), vec3(0.9, 0.7, 0.4), crystal);
    // Emergent color blend
    vec3 color = mix(cosmicColor, crystalColor, blendFactor);
    
    // Apply additional brightness modulation based on the emergent pattern
    color *= 0.5 + emergent * 1.5;
    
    gl_FragColor = vec4(color, 1.0);
}