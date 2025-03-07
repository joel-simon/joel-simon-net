precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

// Creates a swirling vortex based on polar coordinates
float vortex(vec2 p) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    // Create a spiral using sine function combined with noise
    float spiral = sin(6.0 * angle + time - radius * 12.0);
    float n = noise(p * 3.0 + time);
    return smoothstep(0.4, 0.0, abs(spiral - n * 0.5 + radius));
}

// Generates a pulsating cosmic field using radial gradients and noise
vec3 cosmicField(vec2 p) {
    float radius = length(p);
    float n = noise(p * 5.0 - time);
    // Base gradient transitioning from deep space blue to warm nebula orange
    vec3 color1 = vec3(0.05, 0.08, 0.2);
    vec3 color2 = vec3(0.8, 0.4, 0.1);
    vec3 gradient = mix(color1, color2, smoothstep(0.2, 0.7, radius + n * 0.3));
    // Add digital glitch effect via discrete jumps in sine modulation
    float glitch = step(0.95, fract(sin((p.x + p.y + time) * 50.0)));
    return mix(gradient, vec3(1.0, 1.0, 1.0), glitch * 0.2);
}

void main(void) {
    // Transform uv into centered coordinate system (-1,1)
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce rotation over time to add digital fluidity
    float angle = time * 0.2;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    vec2 rotatedPos = rot * pos;
    
    // Anchor concept: swirling vortex, medium association: cosmic pulsation
    float vort = vortex(rotatedPos);
    vec3 cosmic = cosmicField(rotatedPos);
    
    // Blend vortex effect with cosmic field
    float blend = smoothstep(0.3, 0.0, vort);
    vec3 color = mix(cosmic, vec3(0.9, 0.9, 1.0), blend);
    
    // Overlay a digital grid flicker in the background for an urban touch
    vec2 grid = fract(uv * 15.0 + sin(time) * 0.1);
    float line = smoothstep(0.48, 0.5, min(grid.x, grid.y)) +
                 smoothstep(0.48, 0.5, min(1.0 - grid.x, 1.0 - grid.y));
    color -= line * 0.15;
    
    gl_FragColor = vec4(color, 1.0);
}