precision mediump float;
varying vec2 uv;
uniform float time;

// Random function
float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise (in vec2 st) {
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

// Fractal Brownian Motion
float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Glitch distortion using fbm noise
vec2 glitch(in vec2 p) {
    float n = fbm(p * 10.0 + time * 0.5);
    p.x += smoothstep(0.3, 0.7, n) * 0.04 * sin(time * 10.0);
    p.y += smoothstep(0.3, 0.7, n) * 0.04 * cos(time * 10.0);
    return p;
}

// Swirling vortex effect for a creative eye motif using polar coordinates
vec3 swirlEye(vec2 pos) {
    // Map uv from [0,1] to [-1,1]
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Vortex effect inside the eye pupil area
    float vortex = sin(10.0 * r - time * 3.0 + a * 2.0);
    float pupil = smoothstep(0.25, 0.23, abs(r - 0.4 - 0.05 * vortex));
    
    // Outer iris pattern enhanced with noise
    float irisNoise = noise(uv * 8.0 + time * 0.5);
    float iris = smoothstep(0.55, 0.57, r) - smoothstep(0.6, 0.62, r);
    iris *= irisNoise * 1.2;
    
    // Radiant glow based on distance
    float glow = 1.0 - smoothstep(0.5, 0.8, r);
    float dynamicGlow = glow * (0.5 + 0.5 * sin(time + a * 3.0));
    
    // Base colors: dark center with warm highlights
    vec3 eyeCenter = mix(vec3(0.1, 0.1, 0.1), vec3(0.9, 0.8, 0.2), pupil);
    vec3 irisColor = mix(vec3(0.2, 0.4, 0.8), vec3(0.8, 0.4, 0.2), irisNoise);
    
    vec3 color = mix(eyeCenter, irisColor, smoothstep(0.35, 0.5, r));
    color += dynamicGlow * vec3(1.0, 0.9, 0.5);
    
    // Apply subtle glitch artifacts
    color += noise(uv * 15.0 + time) * 0.1;
    
    return color;
}

void main() {
    // Apply glitch distortion to uv for an organic effect
    vec2 pos = glitch(uv);
    
    // Combine the swirling eye effect with an overlay of fractal texture
    vec3 eye = swirlEye(pos);
    float fbmTexture = fbm(pos * 5.0 + time);
    
    // Blend the glitch eye with an organic noise pattern
    vec3 finalColor = mix(eye, vec3(fbmTexture * 0.3 + 0.1), 0.3);
    
    gl_FragColor = vec4(finalColor, 1.0);
}