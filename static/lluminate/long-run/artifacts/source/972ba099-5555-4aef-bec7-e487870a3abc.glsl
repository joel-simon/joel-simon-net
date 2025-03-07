precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for randomness
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
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Vortex transformation using polar coordinates
vec2 vortex(vec2 p, float strength) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    angle += sin(radius * 10.0 - time * 2.0) * strength;
    return vec2(cos(angle), sin(angle)) * radius;
}

// Create layered noise for digital texture
float layeredNoise(vec2 p) {
    float sum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 4; i++) {
        sum += noise(p) * amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return sum;
}

// Create a digital grid pattern that morphs with time
float digitalGrid(vec2 p) {
    vec2 grid = fract(p * 10.0);
    float line = smoothstep(0.0, 0.02, min(grid.x, grid.y)) * 
                 smoothstep(0.0, 0.02, min(1.0-grid.x, 1.0-grid.y));
    return line;
}

void main(void) {
    // Center and scale uv so that center is (0,0)
    vec2 p = uv - 0.5;
    p *= 2.0;
    
    // Apply vortex distortion
    vec2 vp = vortex(p, 0.3);
    
    // Create an abstract digital pattern based on layered noise and grid
    float noiseVal = layeredNoise(vp * 1.5 + time * 0.5);
    float gridVal = digitalGrid(vp + sin(time) * 0.1);
    
    // Combine influences to form organic-digital texture
    float pattern = mix(noiseVal, gridVal, 0.5);
    
    // Use polar gradient for a central burst effect
    float radial = length(p);
    float burst = smoothstep(0.7, 0.3, radial);
    
    // Mix colors between a cool digital blue and a vibrant magenta
    vec3 colorA = vec3(0.1, 0.3, 0.6);
    vec3 colorB = vec3(0.8, 0.2, 0.6);
    
    // Introduce glitch-like banding with stripes
    float stripes = abs(sin(20.0 * vp.y + time * 4.0));
    float glitch = smoothstep(0.7, 0.75, stripes);
    
    // Final color: blend burst, pattern, and glitch effects
    vec3 finalColor = mix(colorA, colorB, burst);
    finalColor = mix(finalColor, vec3(pattern), 0.3);
    finalColor += glitch * 0.1;
    
    gl_FragColor = vec4(finalColor, 1.0);
}