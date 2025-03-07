precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash based on sine
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(27.619, 57.583))) * 43758.5453);
}

// 2D noise function using smoothing
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

// Fractional brownian motion noise
float fbm(vec2 p) {
    float f = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        f += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return f;
}

// Sine-wave modulation based transformation
vec2 sineTransform(vec2 pos, float t) {
    pos.x += sin(pos.y * 12.0 + t) * 0.02;
    pos.y += cos(pos.x * 12.0 + t) * 0.02;
    return pos;
}

// Polar transformation for rotation
vec2 polarRotate(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

// Emergent color blending from two conceptual spaces:
vec3 emergentColor(vec2 pos, float t) {
    // First space: fractal noise-based cosmic field
    float n = fbm(pos * 3.5 + t * 0.3);
    vec3 cosmic = mix(vec3(0.0, 0.05, 0.15), vec3(0.5, 0.1, 0.6), smoothstep(0.3, 0.7, n));
    
    // Second space: sinusoidal patterned organic structure
    float wave = sin((pos.x + pos.y) * 20.0 + t * 4.0);
    float organic = smoothstep(0.2, 0.25, abs(wave)) * fbm(pos * 7.0 - t * 0.5);
    vec3 organicCol = mix(vec3(0.1, 0.4, 0.2), vec3(0.8, 0.3, 0.1), organic);
    
    // Blend with a selective function based on distance from center
    float d = length(pos);
    float blend = smoothstep(0.2, 0.5, d);
    
    return mix(organicCol, cosmic, blend);
}

void main(void) {
    // Map UV to centered coordinates
    vec2 pos = uv - 0.5;
    
    // Select two spaces: fractal cosmic and sinusoidal organic.
    // Map cross-space: apply subtle polar rotation from fbm noise.
    float angle = fbm(pos * 2.0 + time * 0.5) * 6.2831 * 0.1;
    pos = polarRotate(pos, angle);
    
    // Blend selectively: apply sine wave distortion to mix the spaces.
    vec2 posSine = sineTransform(pos, time);
    
    // Develop emergent properties: blend positions non-linearly.
    vec2 mixedPos = mix(pos, posSine, 0.5 + 0.5 * sin(time));
    
    // Compute the final color from emergent color function.
    vec3 color = emergentColor(mixedPos, time);
    
    gl_FragColor = vec4(color, 1.0);
}