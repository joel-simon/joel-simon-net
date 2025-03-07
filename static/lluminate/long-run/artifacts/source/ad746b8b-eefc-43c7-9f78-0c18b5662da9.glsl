precision mediump float;
varying vec2 uv;
uniform float time;

// Simple random function
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

// Swirl transformation for digital glitch effect
vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c*pos.x - s*pos.y, s*pos.x + c*pos.y);
}

// Tree branch growth function: using polar coordinates and decay
float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    // Sinusoidal modulation to form branching structure
    float wave = sin(8.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-6.0 * r);
    return smoothstep(0.25, 0.3, abs(wave) * trunk);
}

void main(void) {
    // Base coordinate transform: center uv in [-1,1]
    vec2 pos = uv;
    
    // Generate a secondary coordinate with a digital glitch swirl effect
    vec2 glitchPos = swirl(pos - 0.5, 2.5 * sin(time * 0.9));
    glitchPos += 0.5;
    
    // Cosmic background: radial gradient with starburst effects
    vec2 centered = (pos - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float starBurst = abs(cos(6.0 * angle + time * 2.0));
    float cosmicGlow = 1.0 - smoothstep(0.35, 0.5, radius);
    
    // Organic tree growth synthesis combining original and glitched coordinates.
    float branchOriginal = treeBranch(pos, time);
    float branchGlitched = treeBranch(glitchPos, time * 0.8);
    float branchPattern = mix(branchOriginal, branchGlitched, 0.5);
    
    // Additional noise for organic texture and glitch detail.
    float organicNoise = noise(pos * 5.0 + time);
    float glitchNoise = noise(glitchPos * 15.0 - time);
    
    // Color palettes: cosmic deep blue mixed with warm organic hues.
    vec3 cosmicColor = mix(vec3(0.05, 0.1, 0.25), vec3(0.15, 0.2, 0.4), radius);
    vec3 branchColor = mix(vec3(0.1, 0.3, 0.1), vec3(0.4, 0.25, 0.1), branchPattern);
    vec3 glitchColor = mix(vec3(0.8, 0.2, 0.4), vec3(1.0, 0.7, 0.2), glitchNoise);
    
    // Synthesize the scene by mixing cosmic background, tree growth, and glitch artifacts.
    vec3 color = cosmicColor * cosmicGlow;
    color = mix(color, glitchColor, 0.3 * glitchNoise);
    color = mix(color, branchColor, smoothstep(0.2, 0.35, branchPattern + organicNoise * 0.2));
    
    gl_FragColor = vec4(color, 1.0);
}