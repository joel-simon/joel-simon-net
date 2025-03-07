precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = smoothstep(0.0, 1.0, fract(st));
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float heartShape(vec2 pos) {
    float x = pos.x;
    float y = pos.y;
    float a = x*x + y*y - 1.0;
    return a*a*a - x*x * y*y*y;
}

vec3 celestial(vec2 pos) {
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float spiral = sin(10.0 * r - angle + time);
    float intensity = smoothstep(0.3, 0.0, r) * spiral;
    return vec3(0.1, 0.2, 0.5) + vec3(0.4, 0.3, 0.6) * intensity;
}

vec3 reef(vec2 pos) {
    float r = length(pos);
    float organic = noise(pos * 3.0 + time);
    float flow = smoothstep(0.4, 0.0, r) * organic;
    return vec3(0.0, 0.4, 0.3) + vec3(0.2, 0.6, 0.5) * flow;
}

void main() {
    // Normalize and center uv from [0,1] -> [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create two conceptual spaces:
    // Space A: Celestial spiral with rotation twist
    vec2 posA = pos;
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    posA = vec2(c * posA.x - s * posA.y, s * posA.x + c * posA.y);
    vec3 colorA = celestial(posA);
    
    // Space B: Underwater reef with organic noise and heart shape influence
    vec2 posB = pos;
    posB += 0.2 * vec2(noise(pos * 5.0 + vec2(time)), noise(pos * 5.0 - vec2(time)));
    vec3 colorB = reef(posB);
    
    // Develop an emergent heart influence in the blended space
    float pulse = 1.0 + 0.3 * sin(time * 3.0);
    vec2 heartPos = pos / pulse;
    float heartVal = heartShape(heartPos);
    float heartEdge = smoothstep(0.02, -0.02, heartVal);
    
    // Blend the two spaces with a dynamic mask based on radial distance and sinusoidal perturbation
    float blendMask = smoothstep(0.6, 0.0, length(pos + 0.3 * sin(time + length(pos)*3.0)));
    vec3 emergent = mix(colorA, colorB, blendMask);
    
    // Incorporate a pulsing heart color as an overlay
    vec3 heartColor = vec3(1.0, 0.2, 0.3);
    emergent = mix(emergent, heartColor, heartEdge);
    
    // Add subtle noise texture overlay for organic detail
    float n = noise(pos * 10.0 + time);
    emergent += 0.05 * vec3(n, n * 0.8, n * 1.2);
    
    gl_FragColor = vec4(emergent, 1.0);
}