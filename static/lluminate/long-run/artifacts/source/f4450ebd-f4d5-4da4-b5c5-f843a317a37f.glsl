precision mediump float;
varying vec2 uv;
uniform float time;

// Simple pseudo-random function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// 2D noise
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Create a pulsing heart shape based on polar coordinates
// Equation inspired from: (x^2 + y^2 - 1)^3 - x^2 * y^3 = 0
float heartShape(vec2 pos) {
    float x = pos.x;
    float y = pos.y;
    float a = x*x + y*y - 1.0;
    return a*a*a - x*x * y*y*y;
}

void main(void) {
    // Map uv coordinates from [0,1] to [-1,1] space
    vec2 pos = (uv - 0.5)*2.0;
    
    // Introduce a slight time based twist to simulate dynamic context
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c*pos.x - s*pos.y, s*pos.x + c*pos.y);
    
    // Scale heart shape pulsation with time and noise
    float pulse = 1.0 + 0.3*sin(time*3.0);
    vec2 heartPos = pos / pulse;
    
    // Compute the heart equation value
    float heartVal = heartShape(heartPos);
    
    // Create a smooth edge for the heart
    float heartEdge = smoothstep(0.02, -0.02, heartVal);
    
    // Background: dynamic noise-based turbulence meant to evoke a "rose garden" where the heart replaces the rose
    vec2 noisePos = uv * 10.0 + vec2(time * 0.5, time * 0.3);
    float n = noise(noisePos);
    n = smoothstep(0.4, 0.6, n);
    
    // Combine the heart (subject replaced) over a context symbolizing a universe that normally celebrates the rose's trait (love)
    // Here, love is visualized by the pulsing heart amidst a chaotic, shifting background
    vec3 col = mix(vec3(0.1, 0.0, 0.1), vec3(0.8, 0.2, 0.4), n);
    
    // Blend in the heart shape with a vibrant color
    vec3 heartColor = vec3(1.0, 0.2, 0.3);
    col = mix(col, heartColor, heartEdge);
    
    gl_FragColor = vec4(col, 1.0);
}