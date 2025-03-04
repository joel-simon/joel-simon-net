precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo noise
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    // Four corners in 2D of a tile
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    // Smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

void main() {
    // Recenter UV coordinates from [0,1] to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;

    // Apply a dynamic rotation and swirl effect
    float angle = time * 0.8;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;

    // Create a swirling distortion based on radial distance and time
    float r = length(pos);
    float theta = atan(pos.y, pos.x);
    theta += 0.5 / (r + 0.3) + time * 0.3;
    pos = vec2(r * cos(theta), r * sin(theta));

    // Fractal noise layers for depth: iterate to accumulate noise
    float f = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 4; i++) {
        f += amplitude * noise(pos * frequency + time * 0.5);
        frequency *= 2.0;
        amplitude *= 0.5;
    }

    // Create a radial gradient
    float gradient = smoothstep(1.0, 0.0, r);
    
    // Compute a dynamic color palette using sine functions and noise
    vec3 col1 = vec3(0.5 + 0.5*sin(time + vec3(0.0,2.0,4.0)));
    vec3 col2 = vec3(0.5 + 0.5*cos(time + vec3(1.0,3.0,5.0)));
    
    // Mix based on the fractal noise and gradient effects
    vec3 color = mix(col1, col2, f);
    color *= gradient;

    // Add a subtle vignette effect to deepen the impact
    float vignette = smoothstep(0.8, 0.2, r);
    color *= vignette;

    gl_FragColor = vec4(color, 1.0);
}