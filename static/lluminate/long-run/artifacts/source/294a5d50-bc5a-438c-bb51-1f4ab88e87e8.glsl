precision mediump float;
varying vec2 uv;
uniform float time;

// Basic random function
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
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

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Tree branch distance function using polar transformation and fractal noise.
// SCAMPER Operations: Substitute heart with organic tree branches, Combine swirling polar transform with digital noise, Reverse typical landscape.
float branchPattern(vec2 p) {
    // Move coordinate center to lower part of screen
    p -= vec2(0.5, 0.2);
    // Convert to polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create branch-like streaks by modulating the angle
    float branches = abs(sin(a * 8.0 + time));
    
    // Use fbm noise for organic variability
    float n = fbm(p * 5.0 + time * 0.5);
    
    // Combine effects
    float pattern = smoothstep(0.1 + n * 0.1, 0.12 + n * 0.1, r + branches * 0.05);
    return pattern;
}

// Glitch distortion function using noise
vec2 glitchDistort(vec2 p) {
    float g = fbm(p * 20.0 - time);
    // Reverse effect: invert the glitch offset sometimes  
    float offset = mix(-0.03, 0.03, smoothstep(0.4, 0.6, g));
    p.x += offset * sin(time * 8.0 + p.y * 10.0);
    p.y += offset * cos(time * 8.0 + p.x * 10.0);
    return p;
}

void main() {
    // Apply glitch distortion to uv coordinates
    vec2 pos = glitchDistort(uv);
    
    // Create the tree branch structure pattern
    float tree = branchPattern(pos);
    
    // Background of digital forest with deep blues and purples
    vec3 bgColor = vec3(0.05, 0.02, 0.1);
    
    // Color for branches with digital neon effect
    vec3 branchColor = vec3(0.2, 0.8, 0.4) * (0.5 + 0.5 * sin(time + pos.x * 15.0));
    
    // Combine the branch pattern over the background
    vec3 color = mix(bgColor, branchColor, tree);
    
    gl_FragColor = vec4(color, 1.0);
}