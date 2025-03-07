precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

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

float organicPattern(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 7; i++) {
        // Reverse the usual scale ordering by scaling down as iteration increases.
        float angle = time * 0.3 + float(i) * 0.8;
        float s = sin(angle);
        float c = cos(angle);
        p = vec2(c * p.x + s * p.y, -s * p.x + c * p.y);
        p *= 1.3;
        value += noise(p) * amplitude;
        amplitude *= 0.6;
    }
    return value;
}

void main() {
    // Map uv to a centered domain
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply adaptive distortion for a living organic feel 
    pos += 0.12 * vec2(sin(5.0 * pos.y + time * 1.3), cos(5.0 * pos.x + time * 1.2));
    
    // Combine SCAMPER operations:
    // - Substitute: Switch digital grid with organic textures.
    // - Adapt: Use dynamic noise-grown branches for structure.
    // - Reverse: Reverse radial falloff from center to edges.
    float pattern = organicPattern(pos * 2.2);
    
    // Create an inverted radial mask (reverse falloff)
    float radial = 1.0 - smoothstep(0.0, 1.0, length(pos));
    
    // Synthesize color: Base and accent colors blend with the pattern.
    vec3 baseColor = mix(vec3(0.05, 0.02, 0.1), vec3(0.2, 0.1, 0.25), radial);
    vec3 accentColor = mix(vec3(0.0, 0.4, 0.2), vec3(0.6, 0.8, 0.2), pattern);
    
    // Use pattern to modulate between base and accent
    vec3 color = mix(baseColor, accentColor, smoothstep(0.3, 0.7, pattern));
    
    gl_FragColor = vec4(color, 1.0);
}