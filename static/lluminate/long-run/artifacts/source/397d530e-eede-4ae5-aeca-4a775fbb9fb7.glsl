precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudorandom function
float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Basic noise function
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
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

// Implicit heart shape function shifted and scaled 
// Original heart: (x^2 + y^2 - 1)^3 - x^2 * y^3 = 0
float heartShape(vec2 p) {
    p = (p - 0.5) * 2.0; // Center and scale uv from -1 to 1
    float x = p.x, y = p.y;
    return pow(x*x + y*y - 1.0, 3.0) - x*x * y*y*y;
}

void main() {
    // Identify trait: Transformation. Traditional symbol for love is heart.
    // We replace the heart symbol with a blossoming tree effect – representing growth through transformation.
    // Create base heart shape and then inject tree-like perturbations inside it.

    // Perturb uv coordinates to simulate tree growth branches
    vec2 st = uv;
    float n = fbm(st * 8.0 + time * 0.5);
    vec2 offset = vec2(sin(time + st.y * 10.0), cos(time + st.x * 10.0)) * n * 0.03;
    st += offset;
    
    // Compute heart shape function value
    float heart = heartShape(st);
    
    // Create tree effect: inside the heart region, use noise to simulate branch-like textures.
    float treeTexture = fbm((st + vec2(time * 0.2)) * 12.0);
    
    // Define a mask: areas inside a softened heart shape 
    float heartMask = smoothstep(-0.1, 0.1, -heart);
    
    // Replace traditional heart with tree: blend green tree texture where heart shape exists, and a digital glitch elsewhere.
    vec3 treeColor = vec3(0.1, 0.6, 0.2) + treeTexture * 0.2;
    
    // Outside heart, create digital glitch / dynamic background.
    float glitch = pseudoRandom(uv * time) * 0.3;
    vec3 glitchColor = mix(vec3(0.8, 0.2, 0.1), vec3(0.1, 0.2, 0.8), glitch);
    
    // Mix the two contexts based on heart presence.
    vec3 color = mix(glitchColor, treeColor, heartMask);
    
    // Further perturb color with a subtle time-based glitch overlay.
    float edgeGlitch = smoothstep(0.3, 0.5, fbm(uv * 15.0 + time));
    color = mix(color, vec3(0.95, 0.95, 0.95), edgeGlitch * 0.15);
    
    gl_FragColor = vec4(color, 1.0);
}