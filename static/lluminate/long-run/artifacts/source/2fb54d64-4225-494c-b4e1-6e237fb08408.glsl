precision mediump float;
varying vec2 uv;
uniform float time;

// Random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic 2D noise
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion function
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Swirl function for dynamic distortion
vec2 swirl(vec2 pos, float strength) {
    float angle = length(pos) * strength;
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Organic branch function using polar coordinates and sine modulation
float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

void main() {
    // Center uv coordinates
    vec2 pos = uv;
    
    // Create a swirling/digital glitch effect on a secondary coordinate set
    vec2 glitchPos = swirl(pos - 0.5, 3.0 * sin(time * 0.8));
    glitchPos += 0.5;
    
    // Cosmic gradient background based on vertical sine modulation
    float gradient = 0.5 + 0.5 * sin(time + pos.y * 3.0);
    vec3 cosmicBG = mix(vec3(0.05, 0.1, 0.15), vec3(0.15, 0.25, 0.3), gradient);
    
    // Create a starburst-like pattern from centered UVs
    vec2 centered = (pos - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float burst = abs(cos(8.0 * angle + time * 2.0));
    float star = smoothstep(0.4, 0.38, radius) * burst;
    
    // Generate tree branch organic patterns from two coordinate sets (original & glitched)
    float branch1 = treeBranch(pos, time);
    float branch2 = treeBranch(glitchPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Introduce layered noise and fractal detail through FBM
    float n = noise(pos * 5.0 + time);
    float fractal = fbm((pos - 0.5) * 7.0 + time);
    
    // Define color schemes representing a creative merge:
    // Replace symbol (a digital glitch artifact) with the subject (organic tree) in a cosmic context.
    vec3 digitalColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), n);
    vec3 organicColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    vec3 fractalColor = mix(vec3(0.8, 0.4, 0.2) + 0.2 * vec3(sin(time), cos(time), sin(time * 1.2)),
                             vec3(0.2, 0.5, 0.7) + 0.15 * vec3(cos(time * 0.5), sin(time * 0.3), cos(time * 0.7)),
                             fractal);
    
    // Blend digital glitch overlay (symbol) with the natural organic pattern (subject)
    vec3 mixColor = mix(organicColor, digitalColor, 0.5);
    mixColor = mix(mixColor, fractalColor, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
    
    // Final color: mix cosmic background, starburst, and our blended pattern
    vec3 finalColor = cosmicBG;
    finalColor = mix(finalColor, mixColor, star);
    
    gl_FragColor = vec4(finalColor, 1.0);
}