precision mediump float;
varying vec2 uv;
uniform float time;

// 2D rotation matrix
mat2 rot(float a) {
    float s = sin(a), c = cos(a);
    return mat2(c, -s, s, c);
}

// Hash function to create pseudo randomness
float hash(vec2 p) {
    p = fract(p*vec2(123.34,456.21));
    p += dot(p, p+78.233);
    return fract(p.x * p.y);
}

// Classic noise function
float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0,0.0));
    float c = hash(i + vec2(0.0,1.0));
    float d = hash(i + vec2(1.0,1.0));
    // Smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void main(void) {
    // Transform and center the UV space
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply a subtle rotation that evolves over time
    p *= rot(0.3 * sin(time * 0.5));
    
    // Create swirling distortion by warping the coordinates with noise and sine waves
    vec2 warp = vec2(noise(p * 3.0 + time), noise(p * 3.0 - time));
    p += warp * 0.2;
    
    // Convert to polar coordinates for radial effects
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a fractal pattern using iterative sine warps
    float fractal = 0.0;
    float amp = 0.5;
    float freq = 1.0;
    for (int i = 0; i < 6; i++) {
        fractal += amp * sin(freq * a + time + r * 10.0);
        freq *= 1.8;
        amp *= 0.6;
    }
    
    // Create a second layer of dynamic noise based on time and coordinates
    float n = noise(p * 5.0 + time);
    
    // Mix colors in an unexpected way: base color dynamically shifts with the fractal and noise values
    vec3 col1 = vec3(0.5 + 0.5 * sin(time + fractal),
                     0.5 + 0.5 * cos(time * 0.8 + r * 5.0),
                     0.5 + 0.5 * sin(time * 1.3 - a));
                     
    vec3 col2 = vec3(0.5 + 0.5 * cos(time + n * 3.0),
                     0.5 + 0.5 * sin(time * 0.9 + a * 2.0),
                     0.5 + 0.5 * cos(time * 1.1 - r * 4.0));
                     
    vec3 finalColor = mix(col1, col2, smoothstep(-0.5, 1.0, fractal + n));
    
    // Apply a tight, organic vignette effect
    float v = smoothstep(0.9, 0.3, r);
    finalColor *= v;
    
    gl_FragColor = vec4(finalColor, 1.0);
}