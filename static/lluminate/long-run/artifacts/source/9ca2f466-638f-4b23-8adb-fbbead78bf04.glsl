precision mediump float;
varying vec2 uv;
uniform float time;

// Basic random function
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
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
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

// Heart shape implicit function
// Equation: (x^2 + y^2 - 1)^3 - x^2 * y^3 = 0 produces a heart shape.
float heartShape(in vec2 p) {
    // move and scale coordinates; center heart at (0.5, 0.4)
    vec2 pos = (p - vec2(0.5, 0.4)) * 2.0;
    float x = pos.x;
    float y = pos.y;
    return pow(x*x + y*y - 1.0, 3.0) - x*x*y*y*y;
}

// Glitch distortion based on fbm noise and time
vec2 glitch(in vec2 p) {
    float n = fbm(p * 10.0 + time*0.5);
    // Apply glitch offsets on x coordinate based on noise
    p.x += smoothstep(0.3, 0.7, n) * 0.04 * sin(time * 10.0);
    p.y += smoothstep(0.3, 0.7, n) * 0.04 * cos(time * 10.0);
    return p;
}

void main() {
    // Apply glitch distortion on uv coordinates
    vec2 pos = glitch(uv);
    
    // Evaluate heart shape function
    float d = heartShape(pos);
    
    // Smooth edge for heart shape fill
    float heartEdge = smoothstep(0.02, -0.02, d);
    
    // Create a pulsating effect via a sin wave modulating brightness
    float pulse = abs(sin(time * 3.0)) * 0.3 + 0.7;
    
    // Use fbm noise for internal texture of the heart
    float interior = fbm(pos * 5.0 + time);
    
    // Base colors: warm red for heart with glitch pale white streaks
    vec3 heartColor = vec3(0.8, 0.1, 0.1) * pulse;
    vec3 glitchColor = vec3(1.0) * smoothstep(0.4, 0.6, interior);
    vec3 color = mix(heartColor, glitchColor, 0.3);
    
    // Background as a very dark scene
    vec3 bg = vec3(0.0);
    
    // Combine heart shape with the background
    vec3 finalColor = mix(bg, color, heartEdge);
    
    gl_FragColor = vec4(finalColor, 1.0);
}