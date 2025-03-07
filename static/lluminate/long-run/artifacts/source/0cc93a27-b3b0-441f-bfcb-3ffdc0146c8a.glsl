precision mediump float;
varying vec2 uv;
uniform float time;

// Simple hash function for pseudo-randomness.
float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

// 2D noise function
float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    // Four corners in 2D of a tile
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    
    // Cubic Hermite curve for smooth interpolation
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b)* u.x * u.y;
}

// Polar swirl function: transform cartesian uv using polar coordinates.
vec2 polarTransform(vec2 p) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    // Medium association: introduce a medium-frequency swirling twist based on distance and time.
    angle += 0.5 * sin(time + r*8.0);
    return vec2(r * cos(angle), r * sin(angle));
}

// Main visual combining swirling vortex and subtle glitch noise.
void main() {
    // Center and scale coordinates
    vec2 p = uv - 0.5;
    p *= 2.0;
    
    // Apply polar transformation for swirling vortex effect in the medium distance association.
    vec2 polarP = polarTransform(p);
    
    // Create concentric rings using a sine function on radial distance.
    float rings = sin(10.0 * length(polarP) - time * 3.0);
    rings = smoothstep(0.0, 0.02, abs(rings));
    
    // Glitch-like perturbation: detail noise overlaying the pattern.
    float n = noise(p * 3.0 + time);
    float glitch = smoothstep(0.45, 0.55, n);
    
    // Combine the swirling vortex and glitch noise.
    float pattern = rings + glitch * 0.5;
    
    // Dynamic color modulation: blend between dark purple and neon blue.
    vec3 colorA = vec3(0.15, 0.0, 0.3);
    vec3 colorB = vec3(0.0, 0.8, 1.0);
    vec3 color = mix(colorA, colorB, 0.5 + 0.5*sin(time + length(p)*5.0));
    
    // Final color mix with the patterned overlay.
    color *= 1.0 - pattern * 0.8;
    
    gl_FragColor = vec4(color, 1.0);
}