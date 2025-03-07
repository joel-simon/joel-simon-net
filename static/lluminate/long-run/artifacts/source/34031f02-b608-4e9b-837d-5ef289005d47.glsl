precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

float heartShape(vec2 pos) {
    pos *= 1.3;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0);
}

float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = sin(t * 0.7) * 0.5;
    float s = sin(angle), c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-8.0 * r);
    float branch = smoothstep(0.2, 0.3, abs(wave) * trunk);
    return branch;
}

void main() {
    // Anchor concept: organic movement meets digital structure.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Medium association: rotating heart and branching tree merge.
    float angle = time * 0.3;
    float s = sin(angle), c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Distort coordinates with sine waves to merge organic curves and digital glitches.
    vec2 warpedPos = pos + 0.1 * vec2(sin(5.0 * pos.y + time), cos(5.0 * pos.x + time));
    
    // Create a heart shape mask.
    float heart = heartShape(pos * 1.2);
    float heartMask = smoothstep(0.02, -0.02, heart);
    
    // Generate fractal noise for organic detail.
    float noiseVal = fbm(warpedPos * 2.0);
    
    // Create a digital grid overlay.
    vec2 grid = fract(uv * 12.0) - 0.5;
    float gridLines = smoothstep(0.48, 0.5, abs(grid.x)) + smoothstep(0.48, 0.5, abs(grid.y));
    float glitch = step(0.98, random(uv * time + noiseVal)) * 0.15;
    
    // Branch structure as a tree, hinting at growth.
    float branch = treeBranch(uv, time);
    
    // Medium association: blend organic noise with digital branch structure.
    vec3 organic = vec3(0.3 + 0.7 * sin(noiseVal + time),
                        0.3 + 0.7 * cos(noiseVal - time),
                        0.5 + 0.5 * sin(noiseVal * 2.0 + time));
    
    vec3 digital = vec3(0.05, 0.02, 0.1) + branch * vec3(0.4, 0.25, 0.1);
    digital += gridLines * 0.15 + glitch;
    
    // Blending based on heart mask: inside the heart show organic; outside use digital.
    vec3 color = mix(digital, organic, heartMask);
    
    gl_FragColor = vec4(color, 1.0);
}