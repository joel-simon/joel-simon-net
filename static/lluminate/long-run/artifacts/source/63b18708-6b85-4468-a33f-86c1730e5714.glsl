precision mediump float;
varying vec2 uv;
uniform float time;

// Random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(41.323, 73.157))) * 928371.239);
}

// Simple 2D noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Fractal Brownian Motion for extra complexity
float fbm(vec2 st) {
    float value = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amp * noise(st);
        st *= 2.0;
        amp *= 0.5;
    }
    return value;
}

// Apply an "error" distortion based on directive: "Honor thy error as a hidden intention"
vec2 applyError(vec2 pos, float t) {
    float err = noise(pos * 10.0 + t * 1.5);
    pos += vec2(sin(err * 6.28), cos(err * 6.28)) * 0.03;
    return pos;
}

// Organic swirling function with vintage twist
vec3 organicSwirl(vec2 pos, float t) {
    pos = applyError(pos, t);
    float angle = fbm(pos * 3.0 + t);
    float radius = length(pos);
    float swirl = sin(angle * 6.2831 + radius * 8.0 - t);
    vec3 col = vec3(0.3 + 0.7 * sin(radius * 12.0 + t),
                    0.5 + 0.5 * cos(angle * 3.0 - t),
                    0.4 + 0.6 * sin(swirl * 9.0));
    return col;
}

// Digital mishap grid that evolves with time
vec3 digitalMishap(vec2 pos, float t) {
    vec2 gridPos = fract(pos * 15.0 - t * 0.2);
    float line = step(0.02, gridPos.x) * step(0.02, gridPos.y);
    float glitch = step(0.95, random(pos * t * 0.5));
    return mix(vec3(0.1, 0.2, 0.3), vec3(0.9, 0.4, 0.6), line + glitch);
}

void main() {
    // Center uv coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply mirror symmetry to create an old, reflective idea
    pos = abs(pos);
    
    // Create swirling organic visuals influenced by a hidden error
    vec3 swirlColor = organicSwirl(pos, time);
    
    // Generate a digital mishap overlay with glitch aesthetics
    vec3 mishapColor = digitalMishap(uv, time);
    
    // Further distort the overall pattern with a subtle fractal variation
    float fractalMask = fbm(pos * 5.0 + time * 0.5);
    
    // Blend the two worlds: organic error and digital mishap with a vintage mix
    vec3 finalColor = mix(swirlColor, mishapColor, fractalMask);
    
    // Intentionally honor an error burst every so often
    float burst = step(0.98, random(uv * time * 2.3));
    finalColor += burst * vec3(0.4, 0.2, 0.7);
    
    gl_FragColor = vec4(finalColor, 1.0);
}