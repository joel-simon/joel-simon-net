precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

void main() {
    // Reverse the assumption of continuous swirling by adopting a grid-based discrete pattern
    vec2 pos = uv * 10.0; // Increase grid resolution
    vec2 id = floor(pos);
    vec2 f = fract(pos);
    
    // Create time-varying offsets for each grid cell using pseudo randomness
    float offset = pseudoRandom(id + time);
    vec2 displacement = vec2(sin(time + offset * 6.2831), cos(time + offset * 6.2831)) * 0.5;
    
    // Perturb the local coordinates by the cell displacement
    f = fract(f + displacement);
    
    // Invert the typical smooth gradients by using a sharp step function
    float cellBorder = step(0.1, min(f.x, f.y)) * step(0.1, min(1.0 - f.x, 1.0 - f.y));
    
    // Dynamic color generation: reverse typical fading by high contrast color clamping
    vec3 colorBase = vec3(pseudoRandom(id * 0.5), pseudoRandom(id * 0.7), pseudoRandom(id * 0.9));
    vec3 colorShift = vec3(sin(time), cos(time), sin(time * 0.5));
    vec3 color = mix(colorBase, colorShift, 0.5);
    
    // Apply sharp grid mask with influence of cell borders
    color *= cellBorder;
    
    // Add a subtle glitch of noise that challenges the grid uniformity
    float glitch = pseudoRandom(uv * time) * 0.25;
    color += glitch;
    
    gl_FragColor = vec4(color, 1.0);
}