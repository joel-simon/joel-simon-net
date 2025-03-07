precision mediump float;
varying vec2 uv;
uniform float time;

// Simple random function
float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D Noise function
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    // Smooth Interpolation using smoothstep
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Fractal Brownian Motion using noise
float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Medium-distance association: a rhythmic, distorted waveform
float wave(in vec2 pos, float t) {
    float waveFreq = 15.0;
    float waveAmp = 0.02;
    float w = sin((pos.x + t) * waveFreq) * waveAmp;
    return smoothstep(0.48 + w, 0.5 + w, pos.y);
}

// Digital glitch effect function
float glitch(in vec2 pos, float t) {
    float g = step(0.98, random(pos * (t + 1.0)));
    return g;
}

// Develop creative connection: Organic fractal ripples with digital banding
vec3 organicDigital(in vec2 pos, float t) {
    // Use fbm to create organic ripple patterns
    float ripples = fbm(pos * 3.0 + t * 0.5);
    // Add sine based swirl for dynamics
    float swirl = sin((pos.x + pos.y + t) * 5.0);
    // Combine with wave function to introduce banding structure
    float bands = wave(pos, t);
    // Get glitch burst overlay
    float burst = glitch(pos, t);
    
    // Combine color elements
    vec3 organic = vec3(0.2 + 0.5 * ripples, 0.3 + 0.4 * swirl, 0.4 + 0.4 * bands);
    vec3 digital = vec3(0.7, 0.2, 0.5);
    
    // Mix both domains with a varying mask based on bands and bursts
    vec3 color = mix(organic, digital, bands);
    color += burst * 0.3;
    return color;
}

// Adding a circular vignette for focus
float vignette(in vec2 pos) {
    float d = distance(pos, vec2(0.5));
    return smoothstep(0.8, 0.3, d);
}

void main() {
    vec2 pos = uv;
    
    // Rotate UVs slightly for digital perturbation
    float angle = 0.2 * sin(time * 0.5);
    mat2 rotation = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rotation * (pos - 0.5) + 0.5;
    
    // Construct layered effect using both organic ripples and digital glitch lines
    vec3 color = organicDigital(pos, time);
    
    // Apply a dynamic pulsating vignette that evolves with time
    float v = vignette(uv);
    color *= v;
    
    gl_FragColor = vec4(color, 1.0);
}