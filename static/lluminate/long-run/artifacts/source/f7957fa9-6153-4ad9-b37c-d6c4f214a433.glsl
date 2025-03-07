precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
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

vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 10.0, time));
    return p + vec2(n * 0.05, 0.0);
}

vec3 organicPattern(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float radius = length(pos);
    float cell = smoothstep(0.4, 0.38, abs(n - radius));
    vec3 col = mix(vec3(0.1, 0.5, 0.3), vec3(0.9, 0.8, 0.4), n);
    return col * cell;
}

vec3 digitalPattern(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float glitchBurst = step(0.95, random(pos * 1.3 + time));
    vec3 col = mix(vec3(0.05, 0.05, 0.2), vec3(0.6, 0.9, 1.0), line);
    return col + glitchBurst * 0.3;
}

float mountain(vec2 p) {
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

void main(){
    // Transform uv to center coordinates
    vec2 pos = uv - 0.5;
    
    // Apply polar transformation for swirling organic growth
    float angle = fbm(pos * 3.0 + time) * 6.2831 * 0.2;
    vec2 rotatedPos = polarTransform(pos, angle);
    
    // Apply glitch distortion to create digital artifacts
    vec2 digitalPos = glitch(rotatedPos + 0.5);
    
    // Generate organic texture using fbm and cellular pattern
    vec3 organic = organicPattern(pos);
    
    // Generate digital effect using grid lines and pseudo-random bursts
    vec3 digital = digitalPattern(digitalPos);
    
    // Create a mountain-like silhouette with glitch variations
    float m = mountain(uv);
    float mask = step(uv.y, m);
    vec3 mountainColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.6, 0.4, 0.2), mask);
    
    // Blend organic and digital textures based on radial factor
    float mixFactor = smoothstep(0.6, 0.2, length(pos));
    vec3 blended = mix(organic, digital, mixFactor);
    
    // Final mixing: incorporate mountain silhouette as a symbolic anchor in composition
    vec3 finalColor = mix(blended, mountainColor, 0.5);
    
    gl_FragColor = vec4(finalColor, 1.0);
}