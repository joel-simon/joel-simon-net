precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random generator
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Simple noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

// Fractal Brownian Motion with reversed roles:
// Instead of structured chaos, let chaotic noise dictate structured patterns.
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

// Reverse assumption: Instead of time driving predictable evolution (like growth),
// Let unpredictability (noise) drive the passage of time.
float chaoticTime(vec2 pos) {
    return time + fbm(pos * 4.0);
}

// Implicit function for a circular core that is invaded by chaotic waves.
// Represents the idea that chaos (noise) sculpts form rather than order.
float coreField(vec2 pos) {
    float radius = length(pos);
    float core = smoothstep(0.4, 0.35, radius);
    // Inject chaotic fluctuations into the core boundary.
    float chaos = 0.1 * sin(chaoticTime(pos) * 6.0 + radius*15.0);
    return core + chaos;
}

// Digital pulse grid that emerges from the chaos
vec3 pulseGrid(vec2 pos) {
    float grid = sin(pos.x * 20.0 + time * 2.0) * sin(pos.y * 20.0 + time * 2.0);
    grid = smoothstep(0.0, 0.02, abs(grid));
    return vec3(grid * 0.8, grid * 0.3, grid * 0.5);
}

void main() {
    // Shift uv from 0->1 range to centered coordinates.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a swirl effect based on the chaotic time function.
    float angle = chaoticTime(pos) * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(c*pos.x - s*pos.y, s*pos.x + c*pos.y);
    
    // Background emerges from fbm noise reversed by letting structure be defined by chaos.
    float n = fbm(rotated * 3.0 + time);
    vec3 background = mix(vec3(0.05, 0.15, 0.25), vec3(0.2, 0.3, 0.4), n);
    
    // Create a chaotic core field that is shaped by the noise-driven 'passage' of time.
    float core = coreField(pos);
    vec3 coreColor = vec3(0.9,0.6,0.2) * smoothstep(0.42, 0.38, core);
    
    // Overlay digital pulse grid that emerges unpredictably.
    vec3 grid = pulseGrid(uv * 2.0 + time * 0.2);
    
    // Blend layers with reversed roles: the chaotic noise determines both structure and modulation of colors.
    vec3 finalColor = mix(background, grid, 0.3);
    finalColor = mix(finalColor, coreColor, smoothstep(0.40, 0.36, core));
    
    // Final pulsation effect to simulate digital interference of chaos in order.
    finalColor += 0.08 * vec3(sin(time + uv.x * 12.0), cos(time + uv.y * 12.0), sin(time * 1.8));
    
    gl_FragColor = vec4(finalColor, 1.0);
}