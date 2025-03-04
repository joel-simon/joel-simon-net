precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265359;

// Simple 2D hash function
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 34.345);
    return fract(p.x * p.y);
}

// Smooth 2D noise from hash
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    float a = hash(i + vec2(0.0, 0.0));
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Rotates the 2D vector by angle a.
mat2 rotate(float a) {
    float s = sin(a), c = cos(a);
    return mat2(c, -s, s, c);
}

// Creates a layered fractal field using noise and rotations
float fractalField(in vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p);
        p = rotate(PI * 0.25 + time * 0.1) * p * 1.7;
        amplitude *= 0.5;
    }
    return value;
}

// Function that applies a spiral distortion based on polar coordinates.
vec2 spiral(vec2 p) {
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += sin(r * 10.0 - time * 2.3) * 0.8;
    return vec2(r * cos(theta), r * sin(theta));
}

void main(){
    // Center and scale uv coordinates
    vec2 p = (uv - 0.5) * 2.0;

    // Apply a time-based rotation
    p *= rotate(time * 0.3);

    // Apply a spiral distortion to p for a surreal twist
    p = spiral(p);

    // Compute fractal field effect
    float field = fractalField(p * 2.0 - time * 0.5);

    // Radial falloff for vignette effect
    float r = length(p);
    float vignette = smoothstep(1.2, 0.0, r);

    // Create dynamic colors based on field and time
    vec3 colA = vec3(0.1, 0.4, 0.8);
    vec3 colB = vec3(0.9, 0.3, 0.2);
    vec3 colC = vec3(0.2, 0.8, 0.5);
    
    // Mix colors dynamically
    vec3 color = mix(colA, colB, sin(field * PI + time));
    color = mix(color, colC, smoothstep(0.2, 0.8, r + 0.3 * sin(time * 1.7)));
    
    // Overlay additional contrast with a pulsating core effect
    float pulse = smoothstep(0.4, 0.0, r) * (0.5 + 0.5 * sin(time * 3.0));
    color += vec3(0.25, 0.15, 0.05) * pulse;
    
    // Final color combination with vignette.
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}