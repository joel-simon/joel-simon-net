precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on sine
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
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
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void main(void) {
    // Map UV coordinates from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Convert Cartesian to polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Creative Strategy:
    // Identify trait T: Brilliance.
    // Subject P: A star.
    // Symbol S: A generic bursting circle.
    // Context: A cosmic scene in which brilliance is essential for the star to shine.
    // Replace S with P by creating a radiant starburst.
    
    // Generate a multi-spiked star pattern using cosine modulation
    float spikes = abs(cos(10.0 * angle - time * 3.0));
    float starMask = smoothstep(0.45, 0.4, radius) * spikes;
    
    // Add dynamic noise for cosmic dust and shifting light
    float cosmicTexture = noise(pos * 4.0 + time * 2.0);
    float textureMod = smoothstep(0.0, 1.0, cosmicTexture * 1.3);
    
    // Create a vibrant, warm color palette to evoke a brilliant star
    vec3 starHue = mix(vec3(0.95, 0.65, 0.25), vec3(1.0, 0.85, 0.55), textureMod);
    
    // Introduce subtle cosmic blue around the edges to enhance spatial depth
    vec3 cosmicEdge = mix(starHue, vec3(0.15, 0.25, 0.55), smoothstep(0.3, 0.7, radius));
    
    // Blend the starburst pattern with the cosmic background
    vec3 finalColor = mix(cosmicEdge, vec3(1.0, 1.0, 0.85), starMask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}