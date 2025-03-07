precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) * (1.0 - u.y) + mix(c, d, u.x) * u.y;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++){
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 tunnelWarp(vec2 pos, float strength) {
    vec2 centered = pos - 0.5;
    float r = length(centered);
    float theta = atan(centered.y, centered.x);
    theta += strength / (r + 0.1);
    vec2 warped;
    warped.x = r * cos(theta);
    warped.y = r * sin(theta);
    return warped + 0.5;
}

vec3 digitalStatic(vec2 pos) {
    float n = noise(pos * 50.0 + time);
    float intensity = smoothstep(0.48, 0.52, fract(n * 10.0 + time));
    return vec3(intensity * 0.8, intensity * 0.9, intensity);
}

vec3 organicGlow(vec2 pos) {
    vec2 centered = pos - 0.5;
    float r = length(centered);
    float n = fbm(pos * 5.0 - time * 0.3);
    vec3 col = mix(vec3(0.1, 0.3, 0.15), vec3(0.8, 0.5, 0.2), n);
    float glow = smoothstep(0.4, 0.0, r);
    return col * glow;
}

void main(void) {
    vec2 pos = uv;
    
    // Apply a tunnel warp effect for a dynamic, swirling sensation
    pos = tunnelWarp(pos, 0.5 * sin(time * 0.7));
    
    // Generate a base organic glow texture
    vec3 organic = organicGlow(pos);
    
    // Superimpose digital static glitches via noise patterns
    vec3 glitch = digitalStatic(pos);
    
    // Create a radial vignette effect using fbm layered noise
    vec2 centered = uv - 0.5;
    float radius = length(centered);
    float vignette = smoothstep(0.8, 0.3, radius + fbm(uv * 3.0 - time));
    
    // Blend the organic glow with digital glitch effects
    vec3 color = mix(organic, glitch, 0.5);
    
    // Apply the radial vignette to darken edges and enhance tunnel depth
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}