precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(p * frequency);
        frequency *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Create a cellular pulse by combining a hexagonal grid with soft edges
float cellPattern(vec2 p) {
    // Convert to hex coordinates
    vec2 q = vec2((p.x * 2.0/3.0), (-p.x/3.0 + sqrt(3.0)/3.0 * p.y));
    vec2 id = floor(q);
    vec2 f = fract(q);
    float m = 1.0;
    
    for (int j=-1; j<=1; j++) {
        for (int i=-1; i<=1; i++) {
            vec2 neighbor = vec2(float(i), float(j));
            vec2 pos = id + neighbor;
            // Hex center back to cartesian:
            vec2 hexCenter;
            hexCenter.x = pos.x * 1.5;
            hexCenter.y = sqrt(3.0) * (pos.y + pos.x * 0.5);
            float d = length(p - hexCenter);
            float shape = smoothstep(0.45, 0.4, d);
            m = min(m, shape);
        }
    }
    return m;
}

void main(void) {
    // Center UV coordinates and add swirling distortion
    vec2 pos = uv - 0.5;
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Domain 1: Cosmic swirl - a spiral that pulsates like a galaxy
    float spiral = sin(angle * 5.0 - time * 2.0 + fbm(pos * 10.0)) * 0.5 + 0.5;
    
    // Domain 2: Organic cellular structure - Using hexagonal cells as if simulating biological tissue
    float cells = cellPattern(pos * 6.0 + vec2(sin(time), cos(time)) * 0.5);
    
    // Synthesize the two distinct domains
    float blend = smoothstep(0.2, 0.6, radius);
    float pattern = mix(spiral, cells, blend);
    
    // Add pulsating glow
    float glow = smoothstep(0.4, 0.0, abs(radius - 0.3 + 0.1 * sin(time * 3.0)));
    
    // Color synthesis: cosmic neon meets organic greenish tint
    vec3 cosmicColor = vec3(0.2, 0.0, 0.5) + vec3(0.5, 0.2, 0.8) * spiral;
    vec3 organicColor = vec3(0.0, 0.4, 0.0) + vec3(0.3, 0.7, 0.3) * cells;
    vec3 color = mix(cosmicColor, organicColor, blend);
    
    // Final mix with glow and pattern intensity
    color += glow * vec3(0.8, 0.6, 0.2);
    color *= pattern;
    
    gl_FragColor = vec4(color, 1.0);
}