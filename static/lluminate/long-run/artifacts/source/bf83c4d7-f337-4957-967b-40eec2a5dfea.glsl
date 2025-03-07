precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void main() {
    // Transform uv to centered coordinates and non-uniform scale
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a slowly evolving rotation based on time
    float angle = time * 0.7;
    float s = sin(angle), c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    pos = rot * pos;
    
    // Create a grid inspired structure (domain: computer circuits) 
    // and map it along with natural organic turbulence (domain: fluid dynamics)
    vec2 grid = fract(pos * 4.0) - 0.5;
    float gridMask = smoothstep(0.4, 0.42, length(grid));
    
    // Introduce organic waves over the grid using sin and cos perturbations
    float organic = sin(pos.x * 10.0 + time) * cos(pos.y * 10.0 + time);
    float noise = random(pos + time);
    
    // Synthesize the two domains: rigid grid structures with fluid organic noise
    float pattern = gridMask + 0.4 * organic + 0.2 * noise;
    
    // Map polar coordinates for an additional overlay: inner glow effect
    float r = length(pos);
    float polarOverlay = smoothstep(0.7, 0.3, r);
    
    // Dynamic color blend: cool circuit blue and a warm organic amber
    vec3 circuitColor = vec3(0.1, 0.4, 0.7);
    vec3 organicColor = vec3(0.9, 0.5, 0.2);
    vec3 color = mix(circuitColor, organicColor, pattern);
    
    // Combine with polar overlay to create a vignette-like finish
    color *= polarOverlay;
    
    gl_FragColor = vec4(color, 1.0);
}