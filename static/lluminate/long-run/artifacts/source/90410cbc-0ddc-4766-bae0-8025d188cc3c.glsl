precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec2 swirl(vec2 p, float strength) {
    float angle = strength * length(p);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

// Draw a pulsating, distorted circular motif representing a sun that replaces
// the generic symbol of a static star. Here, courage (P) is embodied in dynamic light.
float sunShape(vec2 p, float radius) {
    return smoothstep(radius, radius - 0.01, length(p));
}

void main(){
    // Map uv to centered coordinates
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply a swirling distortion that pulses with time
    float pulse = sin(time * 0.8) * 0.7 + 0.7;
    st = swirl(st, pulse * 3.0);
    
    // Create a layered fractal background with cosmic noise
    float background = fbm(st * 3.0 + time * 0.2);
    
    // Build a radial gradient that glows, symbolizing the sunrise (courage) replacing the old static star.
    float glow = smoothstep(0.6, 0.4, length(st));
    
    // Introduce a secondary noise-driven distortion to dynamically alter the sun shape edge.
    float edgeNoise = fbm(st * 10.0 - time);
    float sun = sunShape(st, 0.3 + edgeNoise * 0.05);
    
    // Blend colors: a deep cosmic blue mixes into a warm sunrise gold at the sun location.
    vec3 colorBg = mix(vec3(0.05, 0.1, 0.2), vec3(0.2, 0.15, 0.4), background);
    vec3 sunColor = vec3(1.0, 0.7, 0.3) * glow;
    vec3 finalColor = mix(colorBg, sunColor, sun);
    
    gl_FragColor = vec4(finalColor,1.0);
}