precision mediump float;
varying vec2 uv;
uniform float time;

float random (vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float smoothNoise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    // Four corners in 2D of our cell
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    // Smooth Interpolation
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

vec3 cyberneticBrain(vec2 pos) {
    // Warp the coordinate space to suggest neural pathways
    float warp = smoothNoise(pos * 3.0 + time * 0.5);
    pos += 0.2 * vec2(sin(time + pos.y * 5.0), cos(time + pos.x * 5.0)) * warp;
    
    // Generate a fractal interference pattern through layered noise
    float amplitude = 0.5;
    float frequency = 1.0;
    float noiseSum = 0.0;
    for (int i = 0; i < 4; i++){
        noiseSum += amplitude * smoothNoise(pos * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    
    // Compute a circular influence that pulsates, denoting the anchor concept of a brain core
    float centerDist = length(pos - vec2(0.5));
    float brainCore = smoothstep(0.6, 0.4, centerDist + 0.2 * sin(time));
    
    // Color blending representing organic and cybernetic elements
    vec3 organic = vec3(0.4, 0.8, 0.6) * noiseSum;
    vec3 cyber = vec3(0.9, 0.3, 0.7) * brainCore;
    
    return mix(organic, cyber, 0.5 + 0.5 * sin(time + noiseSum * 3.1415));
}

vec3 fractalArchitecture(vec2 pos) {
    // Rotate the coordinate space slowly to simulate evolving geometric structure
    float angle = time * 0.3;
    float s = sin(angle);
    float c = cos(angle);
    pos = vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
    
    // Use layered noise to generate grid and glitch effects reminiscent of digital architecture
    float grid = smoothstep(0.45, 0.5, abs(sin(10.0 * pos.x)) * abs(sin(10.0 * pos.y)));
    float glitch = random(pos * 10.0 + time) * smoothstep(0.0, 0.1, abs(sin(time * 3.0)));
    
    // Combine effects into a cool color palette of deep blues and purples
    vec3 base = vec3(0.1, 0.1, 0.3);
    vec3 highlight = vec3(0.6, 0.2, 0.8);
    
    return mix(base, highlight, grid + glitch);
}

void main() {
    // Remap uv from [0,1] to a center coordinate space [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Split the screen conceptually into two halves with soft blending
    float mask = smoothstep(0.0, 0.3, pos.x + 0.2 * sin(time*1.5));
    
    // Compute brain-like organic cybernetic scene in one domain
    vec3 brainScene = cyberneticBrain(uv);
    // Compute fractal abstract architecture scene in the other domain
    vec3 fractalScene = fractalArchitecture(uv * 1.5 + vec2(0.3*cos(time), 0.3*sin(time)));
    
    // Blend the two scenes using the mask to create emerging dynamic complexity
    vec3 color = mix(fractalScene, brainScene, mask);
    
    // Apply an additive subtle noise for further organic disruption
    float overlay = smoothNoise(uv * 20.0 + time);
    color += 0.05 * vec3(overlay, overlay * 0.9, overlay * 1.1);
    
    gl_FragColor = vec4(color, 1.0);
}