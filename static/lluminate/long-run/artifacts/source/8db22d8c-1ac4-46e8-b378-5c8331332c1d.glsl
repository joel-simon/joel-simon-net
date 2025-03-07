precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Basic 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Fractal Brownian Motion using noise
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

// Inverse swirl: instead of twisting coordinates outward, we twist them inward with diminishing strength.
vec2 inverseSwirl(vec2 pos, float strength) {
    float r = length(pos);
    float angle = strength / (r + 0.0001); // avoid division by zero
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x + s * pos.y, -s * pos.x + c * pos.y);
}

void main() {
    // Center UV coordinates around (0,0)
    vec2 pos = uv - 0.5;
    
    // Introduce evolving inverse swirl based on time and distance
    vec2 swirled = inverseSwirl(pos, time * 2.0);
    
    // Generate a fractal noise pattern on the swirled coordinates
    float pattern = fbm(swirled * 3.0 + time * 0.5);
    
    // Create a radial gradient from the center that inverts typical dark-center assumption
    float r = length(pos);
    float radial = smoothstep(0.5, 0.0, r);
    
    // Blend the fbm pattern with the radial gradient to create an unexpected luminous core
    float mixFactor = mix(pattern, radial, 0.7);
    
    // Color palette that reverses common dark-space expectations: vibrant central glow melting into cool outer tones
    vec3 centerColor = vec3(1.0, 0.6, 0.2);
    vec3 edgeColor = vec3(0.1, 0.2, 0.5);
    
    // Final color mix
    vec3 color = mix(edgeColor, centerColor, mixFactor);
    
    gl_FragColor = vec4(color, 1.0);
}