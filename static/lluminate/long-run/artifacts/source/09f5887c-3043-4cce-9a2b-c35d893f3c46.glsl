precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for randomization
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
    vec2 u = f * f * (3.0 - 2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion
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

// Reverse swirl operation: creates an inward twisting vortex using reverse angular displacement
vec2 reverseSwirl(vec2 p, float strength) {
    vec2 centered = p - 0.5;
    float dist = length(centered);
    float angle = atan(centered.y, centered.x);
    // Reverse the angle based on distance and strength
    float twist = strength / (dist + 0.1);
    angle -= twist;
    vec2 result = vec2(cos(angle), sin(angle)) * dist;
    return result + 0.5;
}

void main(void) {
    // Use original UV coordinates and apply a reverse swirl transformation
    vec2 pos = reverseSwirl(uv, 1.5 * sin(time * 0.7));
    
    // Generate a radial gradient based on distance from center
    vec2 centered = pos - 0.5;
    float radius = length(centered);
    float radial = smoothstep(0.5, 0.0, radius);
    
    // Create pulsating fractal rings using fbm and sine modulation
    float rings = sin(10.0 * radius - time * 3.0);
    float fbmVal = fbm(uv * 4.0 + time*0.2);
    float ringPattern = smoothstep(0.4, 0.42, abs(rings + fbmVal*0.4));
    
    // Layer noise to add texture and digital distortion element
    float n = fbm(uv * 10.0 - time);
    
    // Synthesize colors using reversed operations: start with vivid inner colors, transition to dark outer
    vec3 innerColor = vec3(0.9, 0.3, 0.6);
    vec3 midColor = vec3(0.2, 0.6, 0.8);
    vec3 outerColor = vec3(0.05, 0.05, 0.1);
    
    // Blend colors based on radial gradient and ring patterns
    vec3 color = mix(outerColor, midColor, radial);
    color = mix(color, innerColor, ringPattern);
    
    // Add digital glitch by modulating brightness with noise
    color += n * 0.1;
    
    gl_FragColor = vec4(color, 1.0);
}