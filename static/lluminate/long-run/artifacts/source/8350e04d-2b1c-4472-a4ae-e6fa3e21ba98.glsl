precision mediump float;
varying vec2 uv;
uniform float time;

// A simple hash-based pseudo-random function
float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

// A 2D noise function inspired by an old idea of classic Perlin noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Applies an "old idea" fractal layering of noise for organic growth
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Polar coordinate distortion function creating ancient radial ripples
vec2 polarDistort(vec2 p) {
    float r = length(p);
    float a = atan(p.y, p.x);
    a += sin(r * 10.0 - time * 2.0) * 0.3;
    r += cos(a * 5.0 + time) * 0.1;
    return vec2(r * cos(a), r * sin(a));
}

void main(void) {
    // Normalize uv coordinates to center at 0.0
    vec2 p = (uv - 0.5) * 2.0;
    
    // Creative random card: "Use an old idea"
    // Interpreation: Incorporate classic fractal noise via fbm and polar distortion.
    p = polarDistort(p);
    
    // Generate the fractal background representing organic complexity
    float fractal = fbm(p * 3.0 + time * 0.2);
    
    // Create a central luminous burst using radial distance with an old-school twist
    float r = length(p);
    float burst = smoothstep(0.5, 0.0, r);
    
    // Combine fractal details with the burst effect
    vec3 baseColor = mix(vec3(0.0, 0.2, 0.5), vec3(0.8, 0.3, 0.1), fractal);
    vec3 finalColor = mix(baseColor, vec3(1.0, 0.9, 0.4), burst);
    
    gl_FragColor = vec4(finalColor, 1.0);
}