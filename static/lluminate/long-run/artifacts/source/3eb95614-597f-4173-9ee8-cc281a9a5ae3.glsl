precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 glitchOffset(vec2 pos, float strength) {
    float n = noise(pos * 10.0 + time);
    return pos + strength * vec2(sin(time + n * 6.2831), cos(time + n * 6.2831));
}

float fractal(vec2 p) {
    float amplitude = 0.5;
    float frequency = 1.0;
    float sum = 0.0;
    for (int i = 0; i < 5; i++) {
        sum += amplitude * abs(noise(p * frequency) - 0.5);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return sum;
}

vec3 blendConcepts(vec2 pos, float t) {
    // Input Space 1: Organic fractal growth
    float organic = fractal(pos * 3.0 + t);
    
    // Input Space 2: Digital glitch patterns
    vec2 glitchPos = glitchOffset(pos, 0.1 * sin(t * 2.0));
    float digital = noise(glitchPos * 20.0 - t);
    
    // Map crossspace: common factor based on radial distance
    float radial = length(pos - 0.5);
    
    // Blend selectively: emergent properties
    float emergent = mix(organic, digital, smoothstep(0.2, 0.5, radial));
    
    // Develop emergent: use emergent value to modulate color channels
    vec3 colorOrganic = vec3(0.2, 0.5, 0.3) + organic * vec3(0.3, 0.6, 0.2);
    vec3 colorDigital = vec3(0.6, 0.2, 0.5) + digital * vec3(0.2, 0.1, 0.4);
    
    return mix(colorOrganic, colorDigital, emergent);
}

void main() {
    vec2 pos = uv;
    
    // Create a secondary, slightly warped coordinate space for cross blending
    vec2 warped = pos + 0.05 * vec2(sin(time + pos.y * 10.0), cos(time + pos.x * 10.0));
    
    // Blend two distinct conceptual outputs
    vec3 emergentColor = blendConcepts(pos, time);
    vec3 layeredColor = blendConcepts(warped, time * 1.1);
    
    // Combine emergent structures with a base dynamic gradient background
    float gradient = smoothstep(0.0, 0.8, length(pos - 0.5)) + noise(pos * 15.0 - time) * 0.2;
    vec3 baseColor = mix(vec3(0.05, 0.1, 0.15), vec3(0.2, 0.3, 0.5), gradient);
    
    vec3 finalColor = mix(baseColor, emergentColor, 0.5);
    finalColor = mix(finalColor, layeredColor, 0.4);
    
    gl_FragColor = vec4(finalColor, 1.0);
}