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

vec3 glitchColor(vec2 pos, float t) {
    float n = random(pos * 50.0 + t);
    float r = random(pos + vec2(t * 0.1, 0.0));
    float g = random(pos + vec2(0.0, t * 0.15));
    float b = random(pos + vec2(-t * 0.1, t * 0.05));
    vec3 col = vec3(r, g, b);
    float glitch = step(0.98, n);
    return mix(col, vec3(1.0), glitch);
}

vec3 spiralCosmos(vec2 pos) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float spiral = sin(10.0 * radius - time * 4.0 + angle * 5.0);
    vec3 base = mix(vec3(0.1, 0.0, 0.2), vec3(0.2, 0.8, 1.0), radius);
    return base * (0.5 + 0.5 * spiral);
}

vec3 urbanGrid(vec2 pos) {
    // Create grid pattern
    vec2 grid = abs(fract(pos * 10.0) - 0.5);
    float gridLine = smoothstep(0.4, 0.42, min(grid.x, grid.y));
    return vec3(gridLine);
}

void main() {
    // Normalize and center uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Concept Anchor: cosmic spiral foundation
    vec3 cosmos = spiralCosmos(pos);
    
    // Generate an urban overlay using grid pattern and glitch effect.
    vec3 gridOverlay = urbanGrid(pos);
    vec3 digitalStatic = glitchColor(pos * 2.0, time);
    
    // Combine urban elements with cosmic base (medium connetion)
    vec3 combined = mix(cosmos, digitalStatic, 0.25) + gridOverlay * 0.3;
    
    // Introduce a subtle heart shape modulation as symbolic association.
    float pulse = 1.0 + 0.3 * sin(time * 3.0);
    vec2 heartPos = pos / pulse;
    float heartVal = heartShape(heartPos);
    float heartEdge = smoothstep(0.02, -0.02, heartVal);
    vec3 heartColor = vec3(1.0, 0.2, 0.3);
    
    combined = mix(combined, heartColor, heartEdge * 0.5);
    
    // Add organic noise detail for texture.
    float n = noise(pos * 10.0 + time);
    combined += 0.05 * vec3(n, n * 0.8, n * 1.2);
    
    // Vignette effect
    float vignette = smoothstep(0.7, 0.3, length(pos));
    combined *= vignette;
    
    gl_FragColor = vec4(combined, 1.0);
}