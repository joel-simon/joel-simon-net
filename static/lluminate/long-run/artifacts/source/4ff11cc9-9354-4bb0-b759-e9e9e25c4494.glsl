precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
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

vec3 organicPattern(vec2 pos, float t) {
    // Shift coordinates to create a swirling motion
    vec2 center = vec2(0.5);
    vec2 offset = pos - center;
    float angle = atan(offset.y, offset.x);
    float radius = length(offset);
    
    // Add swirling based on time and fractal noise
    float swirl = sin(angle * 3.0 + t) * 0.1;
    radius += swirl;
    
    // Create an organic texture using fbm
    float n = fbm(pos * 8.0 + vec2(t * 0.2, t * 0.3));
    
    // Derive color bands from the radius and noise interaction
    float band = smoothstep(0.3, 0.35, abs(sin(10.0 * radius + n * 5.0)));
    vec3 organicColor = mix(vec3(0.05, 0.2, 0.1), vec3(0.15, 0.8, 0.4), band);
    
    return organicColor;
}

vec3 digitalGlitch(vec2 pos, float t) {
    // Introduce a glitch-like distortion based on random offsets.
    float glitch = step(0.95, random(vec2(floor(pos.y * 50.0), t)));
    vec2 glitchOffset = vec2(glitch * 0.05, 0.0);
    pos += glitchOffset;
    
    // Create a grid digital effect with sharp transitions.
    float grid = smoothstep(0.45, 0.55, fract(pos.x * 20.0)) * 
                 smoothstep(0.45, 0.55, fract(pos.y * 20.0));
    vec3 glitchColor = mix(vec3(0.8, 0.8, 0.8), vec3(0.2, 0.2, 0.2), grid);
    
    return glitchColor;
}

void main() {
    vec2 pos = uv;
    
    // Apply a slow zoom pulse effect
    float zoom = 1.0 + 0.1 * sin(time * 0.8);
    pos = (pos - 0.5) * zoom + 0.5;
    
    // Separate organic and digital layers with independent motions.
    vec3 organicLayer = organicPattern(pos, time);
    vec3 digitalLayer = digitalGlitch(pos, time);
    
    // Combine the layers using a time-dependent blending factor.
    float blend = smoothstep(0.3, 0.7, sin(time * 0.5) * 0.5 + 0.5);
    vec3 color = mix(organicLayer, digitalLayer, blend);
    
    gl_FragColor = vec4(color, 1.0);
}