precision mediump float;
varying vec2 uv;
uniform float time;

// Random directive: "Honor thy error as a hidden intention."

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

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

vec3 glitchIntent(vec2 pos) {
    // Honor errors as hidden intentions: introduce random distortions.
    float n = noise(pos * 10.0 + time);
    float glitch = step(0.95, random(pos + time));
    vec3 base = vec3(n, 0.5 * n, 1.0 - n);
    return mix(base, vec3(1.0,0.0,0.5), glitch * 0.7);
}

vec3 organicError(vec2 pos) {
    // Create an organic swirl with unexpected shifts.
    float angle = time + fbm(pos * 3.0);
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    float intensity = fbm(rotated * 2.0 + time * 0.5);
    return vec3(intensity * 0.2, intensity * 0.8, intensity);
}

void main() {
    // Normalize and center coordinates.
    vec2 pos = (uv - 0.5) * 2.0;

    // Introduce a deliberate error displacement.
    float errorFactor = sin(time * 3.0) * 0.2;
    vec2 errorPos = pos + vec2(errorFactor, -errorFactor);
    
    // Combine digital glitch intent and organic error swirl.
    vec3 digitalIntent = glitchIntent(uv * 5.0 + time * 0.3);
    vec3 organicSwirl = organicError(errorPos);
    
    // Blend the layers with a paradoxical mix.
    float blendFactor = smoothstep(0.3, 1.0, fbm(pos * 4.0 + time));
    vec3 finalColor = mix(digitalIntent, organicSwirl, blendFactor);
    
    // Final touch: a random burst that honors its error.
    float burst = step(0.98, random(uv * time * 0.5));
    finalColor += burst * vec3(0.3, 0.1, 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}