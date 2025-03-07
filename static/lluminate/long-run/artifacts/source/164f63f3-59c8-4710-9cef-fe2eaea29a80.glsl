precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Function to create a digital glitch effect
float glitch(vec2 p, float t) {
    float g = noise(p * 10.0 + t);
    // Introduce abrupt discontinuities
    g = step(0.8, g);
    return g;
}

// Function to generate organic vein structures
float organicVeins(vec2 p, float t) {
    p *= 3.0;
    float veins = sin(p.x + sin(p.y + t*1.5)) * 0.5 + 0.5;
    veins = smoothstep(0.4, 0.6, veins);
    return veins;
}

void main(void) {
    // Step 1: Select two distinct conceptual spaces:
    //   A: Digital glitch patterns (structured noise and abrupt transitions)
    //   B: Organic vein-like forms (smooth curves and natural growth)
    //
    // Step 2: Map crossspace by using shared coordinate space 'uv' and time modulation.
    // Step 3: Blend selectively these inputs using mix functions, and modulation functions.
    // Step 4: Develop emergent structure:
    //     The final image displays digital glitches that reveal organic, vein-like patterns underneath.
    
    // Normalize uv to [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Rotate position slowly over time to add dynamic movement
    float angle = time * 0.4;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Compute digital glitch component
    float glitchComponent = glitch(pos, time);
    
    // Compute organic veins component
    float veinsComponent = organicVeins(pos, time);
    
    // Create emergent blended effect: glitches reveal the hidden organic structure
    float blendFactor = mix(veinsComponent, glitchComponent, 0.6);
    
    // Calculate background gradient with a shifting color palette
    vec3 bgColor = mix(vec3(0.05, 0.1, 0.15), vec3(0.2, 0.25, 0.3), uv.y);
    
    // Add color dynamics: Digital glitches are neon-like while organic parts are earthy
    vec3 digitalColor = vec3(0.0, 1.0, 1.0) * glitchComponent;
    vec3 organicColor = vec3(0.8, 0.5, 0.3) * veinsComponent;
    
    // Mix the two color palettes based on the blendFactor
    vec3 emergentColor = mix(organicColor, digitalColor, blendFactor);
    
    // Final color is a mix between background and emergent properties with subtle time pulsation
    vec3 finalColor = mix(bgColor, emergentColor, smoothstep(0.2, 0.8, blendFactor));
    
    gl_FragColor = vec4(finalColor, 1.0);
}