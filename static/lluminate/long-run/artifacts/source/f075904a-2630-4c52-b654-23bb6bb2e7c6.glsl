precision mediump float;
varying vec2 uv;
uniform float time;

// Random function
float random(in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic noise function
float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x);
}

// Fractal Brownian Motion
float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Circuit Board Glitch: simulate digital circuit noise lines
vec3 circuitBoard(in vec2 pos) {
    // Create grid lines that mimic digital circuit paths
    vec2 grid = fract(pos * 20.0 + time * 0.5);
    float horizontal = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float vertical = smoothstep(0.0, 0.02, abs(grid.x - 0.5));
    // Introduce glitch randomness along the circuits
    float glitch = step(0.95, random(pos * 15.0 + time)) * 0.4;
    vec3 baseColor = vec3(0.05, 0.2, 0.3);
    vec3 circuitColor = mix(baseColor, vec3(0.2, 0.8, 1.0), (horizontal+vertical)*0.5);
    return circuitColor + glitch;
}

// Organic Landscape: render a smooth fractal terrain silhouette
vec3 organicLandscape(in vec2 pos) {
    // Center and scale
    vec2 st = pos * 2.0 - 1.0;
    // Use fbm to mimic rolling hills
    float height = fbm(st * 1.5 + time * 0.2);
    // Create a soft horizon line using smoothstep
    float horizon = smoothstep(0.3, 0.31, st.y + height*0.3);
    vec3 sky = mix(vec3(0.0, 0.0, 0.05), vec3(0.1, 0.1, 0.2), pos.y);
    vec3 ground = mix(vec3(0.1, 0.4, 0.1), vec3(0.3, 0.2, 0.05), height);
    return mix(ground, sky, horizon);
}

// Synthesize both domains: organic landscape with digital circuit overlay
void main(){
    vec2 pos = uv;
    
    // Domain 1: Organic landscape
    vec3 organic = organicLandscape(pos);
    
    // Domain 2: Digital circuit board
    vec3 digital = circuitBoard(pos + vec2(sin(time*0.5)*0.1, cos(time*0.5)*0.1));
    
    // Combine with a synthesis function that varies with uv position and time
    float blendFactor = smoothstep(0.3, 0.7, fbm(pos * 3.0 - time * 0.3));
    
    vec3 color = mix(organic, digital, blendFactor);
    
    gl_FragColor = vec4(color, 1.0);
}