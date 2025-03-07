precision mediump float;
varying vec2 uv;
uniform float time;

// A simple 2D hash function.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// 2D noise function using hash.
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

// Fractal Brownian Motion with few iterations accentuating large scales.
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 1.0;
    total += amplitude * noise(p);
    amplitude *= 0.5; p *= 2.0;
    total += amplitude * noise(p);
    amplitude *= 0.5; p *= 2.0;
    total += amplitude * noise(p);
    return total;
}

// Reversed symmetry: mirror across the edges instead of center.
vec2 reverseMirror(vec2 p) {
    // Instead of assuming center is the point of symmetry,
    // consider the edges as the sources of structure.
    return 1.0 - abs(1.0 - 2.0 * p);
}

// Organic disruption resulting in void in corners and bursts along boundaries.
vec3 organicEdge(vec2 p) {
    vec2 rp = reverseMirror(p);
    // Give stronger emphasis on the boundaries.
    float d = min(min(rp.x, rp.y), min(1.0 - rp.x, 1.0 - rp.y));
    float intensity = smoothstep(0.0, 0.3, d);
    // Reverse assumption: rather than the center being high, edges glow.
    return vec3(1.0 - intensity, 0.2 + intensity * 0.6, intensity * 0.8);
}

// Digital artifact: instead of random noise, use structured quantization that distorts the frequencies.
vec3 digitalArtifact(vec2 p) {
    // Disrupt expected smooth gradients with blocky architecture.
    vec2 grid = floor(p * 20.0) / 20.0;
    float artifact = step(0.7, fbm(grid * 5.0 + time * 2.0));
    return vec3(artifact * 0.3, artifact * 0.9, artifact * 1.0);
}

// Layer synthesis: combine large scale edges with pulsating digital interference.
void main(void) {
    vec2 pos = uv;
    
    // Invert the usual UV mapping assumption: let borders generate structure.
    vec2 edgeMod = reverseMirror(pos);
    
    // Apply organic design emphasizing boundaries.
    vec3 organic = organicEdge(edgeMod);
    
    // Create a digital interference layer that evolves with time.
    vec3 digital = digitalArtifact(uv);
    
    // Use fbm based blend factor to integrate two opposing patterns.
    float blendFactor = smoothstep(0.3, 0.7, fbm(pos * 3.0 - time * 0.5));
    
    // Combine layers with a twist: digital influence dominates as blendFactor rises.
    vec3 color = mix(organic, digital, blendFactor * 0.5);
    
    // Final reversal: Color inversion based on noise to challenge assumptions.
    float invert = smoothstep(0.2, 0.8, noise(uv * 10.0 + time));
    color = mix(color, vec3(1.0) - color, invert * 0.2);
    
    gl_FragColor = vec4(color, 1.0);
}