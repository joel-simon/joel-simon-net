precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Rotates a 2d vector.
vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

// Gear pattern: circular ridges modulated to mimic clockwork gears.
float gear(vec2 pos, float teeth, float thickness) {
    float a = atan(pos.y, pos.x);
    float r = length(pos);
    float m = abs(sin(teeth * a + time)) * thickness;
    return smoothstep(0.5 - m, 0.5 + m, r);
}

// Organic coral fractal branch function.
float coral(vec2 pos) {
    float accum = 0.0;
    float scale = 1.0;
    for (int i = 0; i < 5; i++) {
        float n = noise(pos * scale + time * 0.2);
        accum += (n / scale);
        scale *= 1.8;
        pos *= 1.3;
    }
    return accum;
}

// Synthesized scene combining steampunk gears and bioluminescent coral.
void main() {
    // Transform uv into centered coordinates.
    vec2 st = uv * 2.0 - 1.0;
    
    // Domain separation for gear and coral using a dynamic split.
    float split = sin(time * 0.5) * 0.4;
    
    // Gear region (left side)
    float gearMask = smoothstep(-0.05, 0.05, st.x - split);
    vec2 gearPos = rotate(st * 1.2, time * 0.5);
    float gearPattern = gear(gearPos, 12.0, 0.1);
    vec3 gearColor = mix(vec3(0.2, 0.15, 0.1), vec3(0.5, 0.4, 0.3), gearPattern);
    
    // Coral region (right side)
    float coralMask = smoothstep(0.05, -0.05, st.x - split);
    vec2 coralPos = st * 2.5;
    float coralBranch = coral(coralPos);
    coralBranch = smoothstep(0.5, 1.2, coralBranch);
    vec3 coralColor = vec3(0.05, 0.4, 0.6) + vec3(0.3, 0.2, 0.5) * coralBranch;
    
    // Blend between regions.
    vec3 color = mix(gearColor, coralColor, coralMask);
    
    // Add a faint overlay of dynamic noise for organic feel.
    float n = noise(uv * 10.0 + time);
    color += 0.05 * vec3(n, n * 0.8, n * 1.2);
    
    gl_FragColor = vec4(color, 1.0);
}