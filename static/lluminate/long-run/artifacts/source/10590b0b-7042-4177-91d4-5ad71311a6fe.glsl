precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    vec2 u = f*f*(3.0-2.0*f);

    // Mix 4 corners percentages
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
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

// Domain: Celestial (stars) and Underwater (coral bubbles)
// Function to render a cosmic star field pattern with swirling motion.
float starField(vec2 pos, float t) {
    pos *= 3.0;
    float stars = fbm(pos + t*0.2);
    stars = smoothstep(0.6, 1.0, stars);
    return stars;
}

// Function to create organic bubble shapes resembling coral growth
float coralBubble(vec2 pos, vec2 center, float scale) {
    float d = length((pos - center)*vec2(1.0, 1.5));
    return smoothstep(scale, scale - 0.02, d);
}

// Synthesize two unrelated domains: Cosmic and Underwater coral
vec3 synthesizeColor(vec2 pos, float t) {
    // Cosmic part: swirling, shifting nebula colours
    float starVal = starField(pos, t);
    vec3 cosmicColor = mix(vec3(0.0, 0.0, 0.1), vec3(0.3, 0.0, 0.5), starVal);
    
    // Underwater coral: clusters of organic bubbles
    float bubbles = 0.0;
    for (int i = 0; i < 3; i++){
        float fi = float(i);
        vec2 center = vec2(0.3 + mod(fi + t*0.1, 0.4), 0.3 + mod(fi*1.7 + t*0.2, 0.4));
        bubbles += coralBubble(pos, center, 0.12 + 0.02*sin(t + fi));
    }
    bubbles = clamp(bubbles, 0.0, 1.0);
    vec3 coralColor = mix(vec3(0.0, 0.2, 0.1), vec3(0.1, 0.6, 0.3), bubbles);
    
    // Synthesize by blending cosmic and coral domains in a novel way.
    float blendFactor = smoothstep(0.3, 0.7, fbm(pos*2.0 + t));
    return mix(cosmicColor, coralColor, blendFactor);
}

void main(){
    vec2 pos = uv;
    
    // Apply a slight rotation and oscillation for digital disturbance
    float angle = 0.3 * sin(time * 0.5);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * (pos - 0.5) + 0.5;
    
    // Add a time-varying ripple effect to enhance organic flow.
    pos += 0.03 * vec2(sin(10.0*pos.y + time), cos(10.0*pos.x + time));
    
    // Generate final color from synthesis of Moonlit cosmos and vibrant coral.
    vec3 color = synthesizeColor(pos, time);
    
    // Final adjustments: brightness variation to accentuate digital glitch-like artifacts.
    float glitch = smoothstep(0.4, 0.6, fbm(pos*10.0 + time));
    color *= mix(0.9, 1.2, glitch);
    
    gl_FragColor = vec4(color, 1.0);
}