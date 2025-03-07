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
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Directive: "Honor thy error as a hidden intention"
// Use the error to create intentional glitches by distorting the uv coordinates
vec2 glitch(vec2 p, float intensity) {
    float offset = sin(time * 5.0 + p.y * 30.0) * intensity;
    p.x += offset;
    p.y += cos(time * 3.0 + p.x * 20.0) * intensity;
    return p;
}

void main(void) {
    // Transform uv to center
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply glitch effects based on an "error" intensity that oscillates over time
    float errorIntensity = smoothstep(0.0, 0.5, abs(sin(time * 2.0)));
    vec2 glitchedPos = glitch(pos, errorIntensity * 0.1);
    
    // Create a swirling vortex using polar coordinates
    float angle = atan(glitchedPos.y, glitchedPos.x);
    float radius = length(glitchedPos);
    float spiral = sin(angle * 5.0 + time * 2.0 + fbm(glitchedPos * 3.0));
    
    // Introduce an intentional "error" band
    float errorBand = smoothstep(0.2, 0.21, mod(radius + time, 0.4));
    
    // Color defined by the vortex and error layer
    vec3 vortexColor = vec3(0.5 + 0.5 * cos(angle + time), 0.5 + 0.5 * sin(angle * 3.0 - time), 0.7 + 0.3 * cos(time - radius * 5.0));
    vec3 noiseColor = vec3(fbm(glitchedPos * 5.0));
    
    // Blend using the spiral pattern and error band to honor the glitch
    float blend = smoothstep(-0.2, 0.2, spiral);
    vec3 color = mix(noiseColor, vortexColor, blend);
    color += errorBand * vec3(1.0, 0.3, 0.3);
    
    gl_FragColor = vec4(color, 1.0);
}