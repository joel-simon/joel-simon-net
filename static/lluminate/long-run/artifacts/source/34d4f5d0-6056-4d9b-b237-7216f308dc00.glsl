precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on uv coordinates
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898, 78.233))) * 43758.5453123);
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

// Heart shape implicit function; modified for dynamic noise replacement
float heartShape(vec2 pos) {
    // Scale pos for aesthetic proportions
    pos *= 1.3;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0)*(x*x + y*y - 1.0)*(x*x + y*y - 1.0) - x*x*y*y*y;
}

void main() {
    // Center and scale UV space to [-1,1] domain
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a time-varying rotation to evolve the scene
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Distort coordinates with dynamic sine-wave modulations
    vec2 warpedPos = pos + 0.1 * vec2(sin(5.0 * pos.y + time), cos(5.0 * pos.x + time));
    
    // Create the heart shape function and compute mask boundary
    float heartVal = heartShape(pos * 1.2);
    float heartMask = smoothstep(0.02, -0.02, heartVal);
    
    // Generate a fractal noise pattern for a "brain-like" texture overlay inside the heart
    float n = 0.0;
    vec2 noisePos = warpedPos * 3.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        n += amplitude * noise(noisePos);
        noisePos *= 1.7;
        amplitude *= 0.5;
    }
    
    // Create dynamic color changes using sin and cosine functions applied to the noise pattern
    vec3 brainColor = vec3(0.2 + 0.7 * sin(n + time),
                           0.2 + 0.7 * cos(n - time),
                           0.5 + 0.5 * sin(n * 2.0 + time));
    
    // Build a layered background that combines digital glitch elements with fluid waves
    vec2 grid = fract(uv * 10.0) - 0.5;
    float gridLines = smoothstep(0.48, 0.5, abs(grid.x)) + smoothstep(0.48, 0.5, abs(grid.y));
    float glitch = step(0.98, random(uv * time)) * 0.15;
    vec3 bgColor = vec3(0.05, 0.02, 0.1) + 0.2 * vec3(sin(time * 0.3), cos(time * 0.4), sin(time * 0.5));
    bgColor += gridLines * 0.15 + glitch;
    
    // Mix the two areas: inside the heart the fractal noise (brainColor) dominates, while outside the heart the background prevails
    vec3 color = mix(bgColor, brainColor, heartMask);
    
    gl_FragColor = vec4(color, 1.0);
}