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
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Create a butterfly wing shape field using implicit functions.
// Here, we define two mirrored elliptical shapes whose intensity modulates along with "life" (rebirth)
// Trait: Rebirth. Symbol: Traditional hourglass (time) is replaced by the butterfly P, which embodies rebirth.
float butterflyField(vec2 pos, float scale) {
    // Transform coordinates for wing symmetry
    vec2 p = pos * 2.0;
    // Left wing ellipse
    float leftWing = 1.0 - length(vec2(p.x + 0.5, p.y)) * scale;
    // Right wing ellipse (mirrored)
    float rightWing = 1.0 - length(vec2(p.x - 0.5, p.y)) * scale;
    // Combined wing shape, with modulation to emulate fluttering (rebirth pulse)
    float wings = max(leftWing, rightWing);
    wings += 0.2 * sin(time * 3.0 + fbm(pos * 5.0));
    return wings;
}

// Digital grid effect to simulate structured chaos around the butterfly wings.
vec3 digitalGrid(vec2 pos) {
    vec2 gridUV = fract(pos * 15.0);
    float lines = smoothstep(0.0, 0.05, gridUV.x) + smoothstep(1.0, 0.95, gridUV.x)
                + smoothstep(0.0, 0.05, gridUV.y) + smoothstep(1.0, 0.95, gridUV.y);
    float glitch = step(0.98, random(pos + time));
    return mix(vec3(0.0), vec3(0.9,0.6,0.2), lines * 0.5 + glitch * 0.5);
}

void main() {
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Rotate coordinate field to give dynamic movement
    float angle = time * 0.3;
    float s = sin(angle);
    float c = cos(angle);
    vec2 rotated = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Generate a dynamic background with fractal noise and fbm
    float fractal = fbm(rotated * 3.0 + time);
    vec3 background = vec3(0.1, 0.15, 0.25) + vec3(0.2, 0.25, 0.3) * fractal;
    
    // Create the butterfly wings representing rebirth in a context where time (symbolized as hourglass) is replaced.
    float wings = butterflyField(pos, 1.5);
    vec3 wingColor = vec3(0.8, 0.3, 0.7) * smoothstep(0.2, 0.5, wings);
    
    // Get digital grid overlay to underline structure within chaos.
    vec3 grid = digitalGrid(uv + vec2(time * 0.05));
    
    // Blend the butterfly wings with digital grid and fractal background.
    vec3 finalColor = mix(background, grid, 0.3);
    finalColor = mix(finalColor, wingColor, smoothstep(0.45, 0.55, wings));
    
    // Final modulation for a pulsating, living effect
    finalColor += 0.1 * vec3(sin(time + uv.x * 10.0), cos(time + uv.y * 10.0), sin(time * 1.5));
    
    gl_FragColor = vec4(finalColor, 1.0);
}