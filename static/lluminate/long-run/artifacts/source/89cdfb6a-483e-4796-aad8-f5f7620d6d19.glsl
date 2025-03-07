precision mediump float;
varying vec2 uv;
uniform float time;

// Random directive: "Honor thy error as a hidden intention."
// Transform "error" into an opportunity for chaos and unexpected beauty.

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453);
}

float smoothNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * smoothNoise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main(void) {
    // Intentionally map uv to chaotic coordinate space
    vec2 pos = uv * 4.0 - 2.0;
    
    // Apply a twist: rotate vector by an angle that changes with error term (fbm)
    float angle = fbm(pos + time * 0.2) * 6.2831;
    float c = cos(angle);
    float s = sin(angle);
    mat2 rotation = mat2(c, -s, s, c);
    pos = rotation * pos;
    
    // Generate unexpected patterns using layered noise and sin distortions
    float pattern = sin(pos.x * 3.0 + time) * cos(pos.y * 3.0 - time);
    float noiseLayer = fbm(pos * 1.5 + time * 0.5);
    float glitch = step(0.8, pseudoRandom(uv * 20.0 + time)) * 0.5;
    
    // Let hidden error become visible in colors and shape fractures
    float combined = pattern + noiseLayer + glitch;
    
    // Create a palette based on unexpected mixing of cool and warm hues
    vec3 colorA = vec3(0.2, 0.5, 0.8);
    vec3 colorB = vec3(0.9, 0.3, 0.4);
    
    // Relate the intensity to our combined pattern using smoothstep for transitions
    vec3 color = mix(colorA, colorB, smoothstep(-1.0, 1.0, combined));
    
    // Introduce an extra chaotic modulation based on radial distance
    float dist = length(uv - 0.5);
    color += vec3(0.1 * sin(time + dist * 20.0), 0.05 * cos(time - dist * 15.0), 0.07 * sin(time * 1.3 + dist * 25.0));
    
    // Final glitchy interference overlay that lets error emerge as art
    float interference = smoothNoise(uv * 30.0 + time);
    color += interference * 0.08;
    
    gl_FragColor = vec4(color, 1.0);
}