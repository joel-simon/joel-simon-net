precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on uv coordinates
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function using bilinear interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Function to simulate a tree branch structure using polar coordinates.
// Here we replace the seed (symbol for potential growth) with a fully formed branch,
// emphasizing that growth (trait) is already matured.
float treeBranch(vec2 pos) {
    // Convert cartesian coordinates to polar
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create periodic patterns in the angular domain to mimic branching
    float branchPattern = smoothstep(0.02, 0.0, abs(sin(4.0 * angle + time) * 0.5 + 0.5 - r));
    
    // Add some organic irregularity with noise
    branchPattern *= smoothstep(0.0, 0.3, noise(pos * 5.0 + time));
    return branchPattern;
}

void main() {
    // Center and scale UV space to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a global rotation modulated by time
    float angle = time * 0.3;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Create a warped version of pos for additional dynamic behavior
    vec2 warpedPos = pos + 0.1 * vec2(sin(3.0 * pos.y + time*1.2), cos(3.0 * pos.x + time*1.2));
    
    // Draw the tree branch pattern which replaces the typical seed symbol (heart)
    // to emphasize matured organic growth.
    float branchMask = treeBranch(warpedPos * 1.5);
    
    // Generate fractal noise for the background texture
    float n = 0.0;
    vec2 noisePos = warpedPos * 3.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        n += amplitude * noise(noisePos);
        noisePos *= 1.7;
        amplitude *= 0.5;
    }
    
    // Evolving color palette: branches take on a warm, earthy hue while the background remains cool.
    vec3 branchColor = vec3(0.3 + 0.4 * sin(n + time), 0.2 + 0.3 * cos(n - time), 0.1 + 0.2 * sin(n * 2.0 + time));
    
    // Create a structured digital glitch background using grid lines and slight random offsets
    vec2 grid = fract(uv * 12.0) - 0.5;
    float gridLines = smoothstep(0.47, 0.5, abs(grid.x)) + smoothstep(0.47, 0.5, abs(grid.y));
    float glitch = step(0.99, random(uv * time)) * 0.12;
    vec3 bgColor = vec3(0.05, 0.06, 0.1) + 0.15 * vec3(sin(time * 0.4), cos(time * 0.45), sin(time * 0.5));
    bgColor += gridLines * 0.15 + glitch;
    
    // Blend the branch structure with the digital background.
    vec3 color = mix(bgColor, branchColor, branchMask);
    
    gl_FragColor = vec4(color, 1.0);
}