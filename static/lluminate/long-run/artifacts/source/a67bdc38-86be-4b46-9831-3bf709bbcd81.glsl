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
    // Center UV space into [-1, 1] from [0,1]
    vec2 pos = (uv - 0.5) * 2.0;

    // Convert Cartesian coordinates into polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Creative Twist:
    // Identify trait: Brilliance (trait T)
    // Subject: A star (P) instead of a generic circle symbol (S)
    // Context: In a cosmic scene, where brilliance is essential for a star to shine.
    // Replace S (generic circular burst) with P (radiant star-like burst) by modulating the radial intensity.
    
    // Create a starburst pattern
    float bursts = abs(cos(8.0 * angle + time * 2.0));
    float starShape = smoothstep(0.4, 0.38, radius) * bursts;
    
    // Add dynamic noise to simulate cosmic dust and shifting light
    float cosmicNoise = noise(pos * 3.0 + time * 1.5);
    float distortion = smoothstep(0.0, 1.0, cosmicNoise * 1.2);
    
    // Compute color gradients with a warm, radiant palette to suggest a star's brilliance
    vec3 starColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), distortion);
    
    // Introduce subtle blue edge to accentuate space ambience
    vec3 spaceGlow = mix(starColor, vec3(0.1, 0.2, 0.5), smoothstep(0.3, 0.6, radius));
    
    // Overlay the starburst pattern to emphasize the replacement concept
    vec3 finalColor = mix(spaceGlow, vec3(1.0, 1.0, 0.8), starShape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}