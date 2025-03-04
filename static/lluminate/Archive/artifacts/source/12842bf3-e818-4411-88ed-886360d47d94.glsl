precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 co) {
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

void main(void) {
    // Center UV coordinates
    vec2 p = uv * 2.0 - 1.0;
    
    // Polar coordinates
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Layered fractal-like swirling noise pattern
    float fractal = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) { 
        float layer = sin(a * frequency + time * (0.5 + amplitude) + r * 10.0);
        fractal += amplitude * layer;
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    
    // Add subtle dynamic random offset for organic effect
    float noise = random(p * time * 0.5);
    
    // Color modulation based on fractal noise and radial distance, rotated hues
    vec3 colorA = vec3(0.3 + 0.7 * sin(time + fractal), 0.2 + 0.8 * cos(time - fractal), 0.5 + 0.5 * sin(time + r*10.0));
    vec3 colorB = vec3(0.7 + 0.3 * cos(-time + fractal), 0.4 + 0.6 * sin(time + fractal * 2.0), 0.3 + 0.7 * cos(time + r*5.0));
    vec3 color = mix(colorA, colorB, smoothstep(0.2, 0.8, noise + fractal * 0.5));
    
    // Apply soft vignette effect based on distance
    float vignette = smoothstep(0.8, 0.4, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}