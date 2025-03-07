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
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Swirl function for water current effect
vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Ocean wave function representing resilience
float oceanWaves(vec2 pos, float t) {
    // Shift uv to center and scale for polar effects
    vec2 centered = pos - 0.5;
    float r = length(centered);
    float a = atan(centered.y, centered.x);
    
    // Use sine modulation to simulate wave crests and troughs
    float wave = sin(12.0 * r - a * 6.0 + t * 3.0);
    
    // Enhance wave intensity near the center of the vortex
    float intensity = exp(-5.0 * r);
    
    return smoothstep(0.3, 0.35, abs(wave) * intensity);
}

void main() {
    // Base UV coordinates
    vec2 pos = uv;
    
    // Create a water current distortion effect
    vec2 distortedPos = swirl(pos - 0.5, 2.5 * sin(time * 0.9));
    distortedPos += 0.5;
    
    // Generate a dynamic "ocean" of waves that symbolizes resilience amid chaos.
    float wavePattern1 = oceanWaves(pos, time);
    float wavePattern2 = oceanWaves(distortedPos, time * 0.8);
    float combinedWaves = mix(wavePattern1, wavePattern2, 0.6);
    
    // Layered noise for additional texture in the water
    float n = noise(pos * 4.0 + time);
    float n2 = noise(distortedPos * 8.0 - time);
    
    // Base ocean tones
    vec3 deepOcean = mix(vec3(0.0, 0.05, 0.2), vec3(0.0, 0.1, 0.3), pos.y);
    
    // Wave highlights and glitched offset splashes
    vec3 waveHighlights = mix(vec3(0.1, 0.3, 0.7), vec3(0.2, 0.5, 0.9), n2);
    
    // Combine to evoke resilience: the ocean in which turbulent and calm currents coexist.
    vec3 color = deepOcean;
    color = mix(color, waveHighlights, combinedWaves * 0.8);
    color = mix(color, vec3(n * 0.1, n * 0.15, n * 0.2), 0.4);
    
    gl_FragColor = vec4(color, 1.0);
}