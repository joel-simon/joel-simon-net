precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random generator based on uv coordinates
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Cellular noise inspired function for mechanical cog pattern
float cogNoise(vec2 st, float scale) {
    st *= scale;
    vec2 i = floor(st);
    vec2 f = fract(st);
    float minDist = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = i + neighbor + 0.5 + 0.5 * sin(time + 6.2831 * pseudoRandom(i + neighbor));
            float dist = length(f - (point - i));
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

// Organic fractal noise function merging underwater fluidity and mechanical pulses
float fractalNoise(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 4; i++) {
        value += amplitude * (0.5 - abs(0.5 - pseudoRandom(st * frequency)));
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Main shader function synthesizing the two domains:
// The organic underwater fluidity and precise mechanical cog structures.
void main() {
    vec2 pos = uv;

    // Create an organic background ripple effect that ebbs like submarine currents.
    vec2 ripplePos = pos * 10.0 - vec2(time * 0.5);
    float ripple = sin(ripplePos.x + sin(ripplePos.y + time)) * 0.5 + 0.5;
    
    // Generate mechanical cog texture pattern overlaid on the background.
    float cog = smoothstep(0.35, 0.3, cogNoise(pos, 15.0));
    
    // Introduce fractal noise to add organic randomness.
    float organic = fractalNoise(pos * 5.0 + vec2(time * 0.2));
    
    // Synthesize the two unrelated domains: convey a sense of underwater clockwork.
    float blend = mix(organic, cog, 0.7);
    
    // Use contrasting color schemes to enhance the duality:
    // Deep ocean blue for the fluid underwater domain and rust orange for mechanical clockworks.
    vec3 colorUnderwater = vec3(0.0, 0.2, 0.5);
    vec3 colorClockwork = vec3(0.8, 0.4, 0.1);
    vec3 color = mix(colorUnderwater, colorClockwork, blend);
    
    // Add subtle time-driven modulation to simulate gentle pulsation.
    float modulator = sin(time + length(pos - 0.5) * 20.0) * 0.1;
    color += modulator;
    
    gl_FragColor = vec4(color, 1.0);
}