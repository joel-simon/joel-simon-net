precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

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

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec3 digitalGrid(vec2 pos) {
    vec2 gridUV = fract(pos * 20.0);
    float line = smoothstep(0.0, 0.03, gridUV.x) + smoothstep(1.0, 0.97, gridUV.x)
               + smoothstep(0.0, 0.03, gridUV.y) + smoothstep(1.0, 0.97, gridUV.y);
    float glitch = step(0.98, random(pos + time));
    vec3 color = mix(vec3(0.0), vec3(0.8, 0.4, 1.0), line * 0.5 + glitch * 0.5);
    return color;
}

void main() {
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Coordinate rotation for organic swirl
    float angle = time * 0.5;
    float s = sin(angle), c = cos(angle);
    vec2 rotated = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Fractal-based swirling field
    float swirl = fbm(rotated * 2.0 + time);
    
    // Vortex effect based on radial distance and fractal noise
    float radius = length(pos);
    float vortex = smoothstep(0.5, 0.0, abs(sin(6.2831 * (radius - swirl))));
    
    // Digital glitch grid effect
    vec3 gridColor = digitalGrid(uv + vec2(time * 0.1));
    
    // Dynamic organic colors with fractal modulation
    vec3 organicColor = vec3(0.2 + 0.8 * fbm(pos * 3.0 + time),
                             0.3 + 0.7 * swirl,
                             0.5 + 0.5 * sin(time + radius * 3.14));
                             
    // Blend digital grid with organic swirl influenced by vortex mask
    vec3 finalColor = mix(gridColor, organicColor, vortex);
    
    // Add digital glitch bursts
    float burst = step(0.97, random(uv * time * 0.3)) * 0.2;
    finalColor += burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}