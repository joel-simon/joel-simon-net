precision mediump float;
varying vec2 uv;
uniform float time;

//
// Reversed assumption: Instead of building upward, we deconstruct the image, letting the background dissolve into digital fragments.
//

// A simple fractal function using iterative inversion in polar coordinates
float fractal(vec2 p) {
    // Convert to polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    float value = 0.0;
    // Inversion iteration: reverse the standard assumption of growth by instead shrinking structures.
    for (int i = 0; i < 5; i++) {
        r = 1.0 / (r + 0.001);
        a += time * 0.1;
        value += exp(-r * 3.0);
        p = vec2(r * cos(a), r * sin(a));
        r = length(p);
    }
    return value;
}

// Create a glitch distortion effect using sine waves and UV manipulation.
vec2 glitch(vec2 p) {
    float glitchStrength = 0.1 + 0.05 * sin(time * 3.0);
    float offset = sin(p.y * 80.0 + time * 5.0) * glitchStrength;
    return p + vec2(offset, 0.0);
}

// Generates an unexpected color based on inverted digital noise.
vec3 invertedColor(vec2 p) {
    float n = fract(sin(dot(p ,vec2(12.9898,78.233))) * 43758.5453);
    return vec3(1.0 - n, 0.5 + 0.5*sin(time + n*6.2831), 1.0 - n*0.5);
}

void main(void) {
    // Reverse the assumption of stability: invert UV coordinates over time.
    vec2 p = uv;
    // Invert position using time based inversion factor
    float invFactor = abs(sin(time * 0.7));
    p = mix(p, 1.0 - p, invFactor);
    
    // Apply glitch distortion 
    p = glitch(p);
    
    // Calculate radial distance from center and inverse polar angle.
    vec2 centered = p - 0.5;
    float radius = length(centered)*2.0;
    float angle = atan(centered.y, centered.x);
    
    // Fractal deconstruction: using inverse fractal iteration.
    float f = fractal(vec2(radius, angle));
    
    // Create a gradual color inversion effect based on time and fractal value.
    vec3 base = invertedColor(p);
    
    // Generate a swirling radial gradient that dissolves rather than builds up.
    float gradient = smoothstep(0.35, 0.5, abs(sin(angle * 4.0 + time) * (1.0 - radius)));
    
    // Blend the fractal deconstruction with the inverted glitch color.
    vec3 color = mix(base, vec3(f, 0.2 + f*0.8, 1.0 - f), gradient);
    
    gl_FragColor = vec4(color, 1.0);
}