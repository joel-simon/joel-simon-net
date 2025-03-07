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
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x) + (d - b)*u.x*u.y;
}

// Implicit heart shape function
float heartShape(vec2 pos) {
    pos *= 1.3;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0)*(x*x + y*y - 1.0)*(x*x + y*y - 1.0) - x*x*y*y*y;
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(p);
        p *= 1.7;
        amplitude *= 0.5;
    }
    return value;
}

void main() {
    // Transform uv coordinate space to [-1,1] domain and adjust aspect
    vec2 pos = (uv - 0.5) * 2.0;
    pos.x *= 1.5;
    
    // Time-based rotation for dynamic effect
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Create swirling waves using polar coordinates
    float radius = length(pos);
    float theta = atan(pos.y, pos.x);
    float wave = sin(10.0 * radius - 3.0 * time + 5.0 * theta);
    
    // Generate glitch effect with pseudorandom noise
    float glitch = (random(uv * time) - 0.5) * 0.2;
    
    // Create fractal noise layer to overlay texture
    float fbmValue = fbm(pos * 3.0 + time * 0.5);
    
    // Generate a heart mask using implicit function and smooth thresholding
    float heartVal = heartShape(pos * 1.2);
    float heartMask = smoothstep(0.02, -0.02, heartVal);
    
    // Use creative strategy: Replace a symbol (heart) with a pulsating organic tree element.
    // When the heart (symbol for love/compassion) is essential, we instead let the fractal noise (tree growth texture) emerge.
    vec3 organicColor = vec3(0.2 + 0.7 * sin(fbmValue + time),
                               0.2 + 0.7 * cos(fbmValue - time),
                               0.5 + 0.5 * sin(fbmValue * 2.0 + time));
    
    // Background digital glitch and swirling waves
    vec3 bgColor = vec3(0.05, 0.02, 0.1) 
                 + 0.2 * vec3(sin(time * 0.3), cos(time * 0.4), sin(time * 0.5));
    bgColor += glitch;
    bgColor += wave * 0.15;
    
    // Blend organic texture inside the heart mask area
    vec3 finalColor = mix(bgColor, organicColor, heartMask);
    
    // Apply vignette based on distance
    float vignette = smoothstep(0.8, 0.2, radius);
    finalColor *= vignette;
    
    gl_FragColor = vec4(finalColor, 1.0);
}