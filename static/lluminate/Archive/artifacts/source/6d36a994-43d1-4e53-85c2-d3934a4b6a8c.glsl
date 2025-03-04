precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 polar(vec2 p) {
    float r = length(p);
    float a = atan(p.y,p.x);
    return vec2(r, a);
}

void main(){
    // Center and scale uv coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a dynamic kaleidoscopic twist using polar coordinates
    vec2 pa = polar(pos);
    float twist = sin(pa.x * 3.0 - time) * 0.5;
    pa.y += twist;
    pos = vec2(pa.x * cos(pa.y), pa.x * sin(pa.y));
    
    // Rotate the coordinates over time
    float angle = time * 0.4;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Base fractal-like noise pattern layering different frequencies
    float n = 0.0;
    float amp = 1.0;
    float freq = 1.0;
    for (int i = 0; i < 5; i++){
        n += noise(pos * freq + time * 0.1) * amp;
        freq *= 2.0;
        amp *= 0.5;
    }
    
    // Create swirling interference pattern using sine functions on polar angles
    vec2 pPolar = polar(pos);
    float swirl = sin(8.0 * pPolar.y + time * 2.0) * cos(3.0 * pPolar.x - time * 1.5);
    
    // Combine noise and swirling interference for intricate details
    float pattern = mix(n, swirl, 0.5);
    
    // Compute radial falloff for vignette effect and blend colors dynamically
    float r = length(pos);
    float vignette = smoothstep(1.0, 0.3, r);
    
    // Dynamic color palette with shifting hues based on pattern and time
    vec3 color;
    color.r = 0.5 + 0.5 * sin(pattern + 0.0 + time);
    color.g = 0.5 + 0.5 * sin(pattern + 2.0 + time * 1.2);
    color.b = 0.5 + 0.5 * sin(pattern + 4.0 - time * 1.7);
    
    // Add another layer of complexity: a grid interference using noise
    vec2 grid = fract(pos * 5.0);
    float line = smoothstep(0.45, 0.5, abs(grid.x - 0.5)) * smoothstep(0.45, 0.5, abs(grid.y - 0.5));
    color = mix(color, vec3(0.1, 0.05, 0.2), line * 0.8);
    
    // Final touch: modulate brightness for depth
    color *= vignette;
    
    // Output shader color with smooth alpha falloff near the edges
    float alpha = smoothstep(1.0, 0.7, r);
    gl_FragColor = vec4(color, alpha);
}