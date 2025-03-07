precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 rotate(vec2 pos, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

vec2 reverseGlitch(vec2 pos, float seed) {
    // Reverse the glitch by subtracting noise-induced offsets.
    float offset = cos(pos.y * 60.0 - seed) * 0.007 + noise(pos * 25.0 - seed) * 0.012;
    pos.x -= offset;
    return pos;
}

vec3 cosmicSwirl(vec2 pos) {
    // Create a swirling cosmic effect with layered fbm and polar transformation.
    float angle = fbm(pos * 4.0 + time * 0.5) * 6.28;
    vec2 rotated = rotate(pos, angle);
    float n = fbm(rotated * 3.0);
    // Apply reverse glitch effect to break linearity.
    vec2 glitched = reverseGlitch(rotated, time);
    // Use radial gradient modulated by fbm noise.
    float radial = length(glitched);
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.15), vec3(0.8, 0.6, 0.9), n);
    float vignette = smoothstep(0.6, 0.2, radial);
    return baseColor * vignette;
}

vec3 digitalBloom(vec2 pos) {
    // Create dynamic digital bursts using alternating wave patterns.
    vec2 grid = fract(pos * 20.0 - time * 0.3);
    float line = abs(grid.y - 0.5);
    float pulse = smoothstep(0.0, 0.04, line);
    float spark = step(0.97, rand(pos * (time * 1.2))) * 0.3;
    return mix(vec3(0.05, 0.2, 0.25), vec3(0.75, 0.9, 1.0), pulse) + spark;
}

void main(){
    // Center and scale UV coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Build base organic cosmic swirl effect
    vec3 cosmic = cosmicSwirl(pos);
    
    // Overlay digital bloom bursts controlled by reversed glitch
    vec2 modPos = reverseGlitch(pos, time * 0.8);
    vec3 bloom = digitalBloom(modPos);
    
    // Synthesize by reversing the composition: digital elements emerge near center.
    float mixFactor = smoothstep(1.2, 0.0, length(pos));
    vec3 finalColor = mix(cosmic, bloom, mixFactor);
    
    gl_FragColor = vec4(finalColor, 1.0);
}