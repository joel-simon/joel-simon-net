precision mediump float;
varying vec2 uv;
uniform float time;

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
    for (int i = 0; i < 6; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 glitch(vec2 pos, float seed) {
    float offset = sin(pos.y * 50.0 + seed) * 0.005 + noise(pos * 20.0 + seed) * 0.01;
    pos.x += offset;
    return pos;
}

vec3 organicPattern(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float radius = length(pos);
    float cell = smoothstep(0.4, 0.38, abs(n - radius));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

vec3 digitalRadar(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float glitchBurst = step(0.95, random(pos * 1.3 + time));
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + glitchBurst * 0.3;
}

void main(){
    // Center the UV coordinates
    vec2 pos = uv - 0.5;
    
    // Apply a rotational distortion to invoke organic growth vibes
    float angle = fbm(pos * 3.0 + time) * 6.2831 * 0.2;
    vec2 rotatedPos = polarTransform(pos, angle);
    
    // Apply a mild glitch effect for digital artifacts
    vec2 glitchedPos = glitch(rotatedPos + 0.5, time);
    
    // Generate organic texture based on cellular patterns
    vec3 organic = organicPattern(pos);
    
    // Generate digital radar scan lines on rotated coordinates
    vec3 radar = digitalRadar(glitchedPos);
    
    // Mix based on radial distance to allow digital elements to emerge from organic structure
    float mixFactor = smoothstep(0.6, 0.2, length(pos));
    vec3 colorMix = mix(organic, radar, mixFactor);
    
    // Add subtle random bursts to symbolize transformation
    float burst = step(0.98, random(glitchedPos * (time * 2.0))) * 0.25;
    vec3 finalColor = colorMix + burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}