precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(17.0, 43.0))) * 2398.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main(void) {
    // Distort coordinates with glitch-like shifts
    vec2 pos = uv;
    float glitch = noise(vec2(pos.y * 15.0, time));
    pos.x += 0.03 * sin(time * 5.0 + pos.y * 20.0) * glitch;
    pos.y += 0.03 * cos(time * 3.0 + pos.x * 20.0) * glitch;
    
    // Map to centered coordinates
    vec2 p = pos * 2.0 - 1.0;
    float r = length(p);
    float angle = atan(p.y, p.x);
    
    // Create fractal branch-like structures by combining fbm and polar modulation
    float branches = fbm(p * 3.0 + vec2(time * 0.3));
    float radial = smoothstep(0.5, 0.48, r + 0.15 * sin(angle*4.0 + time));
    float tree = smoothstep(0.02, 0.0, abs(branches - radial));
    
    // Organic grid-like digital interference
    vec2 grid = fract(uv * 20.0);
    float line = step(0.95, grid.x) + step(0.95, grid.y);
    
    // Combine organic branch with digital glitch grid
    float mixLayer = mix(tree, line, 0.3);
    
    // Color choices: warm organic and cool digital
    vec3 organicColor = vec3(0.2, 0.5, 0.2) + 0.3*sin(vec3(angle, angle+2.0, angle+4.0) + time);
    vec3 digitalColor = vec3(0.1, 0.3, 0.6) + 0.2*cos(vec3(uv, uv.x+uv.y) * 10.0 + time);
    
    // Mix with a radial gradient to emphasize center distortion
    float center = smoothstep(1.0, 0.3, r);
    vec3 color = mix(digitalColor, organicColor, center);
    color *= mixLayer;
    
    // Add subtle glow effect
    float glow = 1.0 - smoothstep(0.0, 0.7, r);
    color += glow * vec3(0.9, 0.8, 0.4) * 0.2;
    
    gl_FragColor = vec4(color, 1.0);
}