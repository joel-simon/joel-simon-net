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
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
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

vec3 cosmicField(vec2 pos, float t) {
    pos *= 3.0;
    float stars = fbm(pos + t * 0.2);
    stars = smoothstep(0.6, 1.0, stars);
    return mix(vec3(0.05,0.0,0.1), vec3(0.4,0.0,0.7), stars);
}

vec3 organicTexture(vec2 pos, float t) {
    float n = fbm(pos * 3.0 + t * 0.4);
    float edge = smoothstep(0.35, 0.38, abs(n - length(pos)));
    return mix(vec3(0.0,0.3,0.2), vec3(0.8,0.7,0.4), n) * edge;
}

void main(){
    // "Honor thy error as a hidden intention"
    vec2 pos = uv - 0.5;
    
    // Apply polar rotation based on fbm noise
    float angle = fbm(pos * 2.0 + time) * 6.2831 * 0.2;
    pos = polarTransform(pos, angle);
    
    // Apply digital glitch effect
    vec2 glitchedPos = glitch(pos + 0.5, time);
    
    // Generate cosmic stars and nebula colors
    vec3 cosmic = cosmicField(glitchedPos, time);
    
    // Generate organic growth and glitch pulsation
    vec3 organic = organicTexture(pos, time);
    
    // Blend the two domains with radial modulation
    float blendFactor = smoothstep(0.3, 0.7, length(pos));
    vec3 color = mix(organic, cosmic, blendFactor);
    
    // Subtle random burst effect for creative disruption
    float burst = step(0.98, random(glitchedPos * (time * 2.0))) * 0.25;
    color += burst;
    
    gl_FragColor = vec4(color, 1.0);
}