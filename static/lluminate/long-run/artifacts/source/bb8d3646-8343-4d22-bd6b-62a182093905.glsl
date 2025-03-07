precision mediump float;
varying vec2 uv;
uniform float time;

// Random number generator
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D Noise function
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

// Fractal Brownian Motion (fbm)
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

// Convert Cartesian coordinates to polar coordinates
vec2 toPolar(vec2 st) {
    float r = length(st);
    float a = atan(st.y, st.x);
    return vec2(r, a);
}

// Digital glitch effect: creates a displacement based on noise and time
vec2 glitch(vec2 st) {
    float shift = noise(vec2(st.y * 5.0, time)) * 0.1;
    st.x += shift;
    return st;
}

// Organic fractal branch: uses sinusoidal modulation in polar space
float organicBranch(vec2 st) {
    vec2 polar = toPolar(st);
    float branches = abs(sin(8.0 * polar.y + fbm(st * 3.0) * 3.0));
    return smoothstep(0.45, 0.5, polar.x + branches * 0.15);
}

// Main emergent scene blending glitch and organic growth
void main(){
    // Normalize uv to [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply glitch distortion selectively to the left side of screen
    vec2 glitchSt = st;
    if(st.x < 0.0){
        glitchSt = glitch(glitchSt);
    }
    
    // Organic pattern from fractal branch intensity
    float organic = organicBranch(glitchSt * 1.5);
    
    // Create digital noise pattern overlay
    float digital = fbm(st * 6.0 + time * 0.5);
    digital = smoothstep(0.4, 0.6, digital);
    
    // Blend the two effects: organic growth emerges into digital glitch
    float blendFactor = mix(organic, digital, 0.5 + 0.5 * sin(time));
    
    // Color palette: organic element in warm hues, digital in cool cyan
    vec3 organicColor = vec3(0.8, 0.4, 0.2);
    vec3 digitalColor = vec3(0.2, 0.8, 0.9);
    
    vec3 color = mix(organicColor, digitalColor, blendFactor);
    
    // Further modulate overall brightness with radial falloff
    float vignette = smoothstep(1.0, 0.5, length(st));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}