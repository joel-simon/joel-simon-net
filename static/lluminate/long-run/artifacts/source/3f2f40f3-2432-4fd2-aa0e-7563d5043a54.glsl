precision mediump float;
varying vec2 uv;
uniform float time;

float noise(vec2 p){
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

vec3 glitchColor(vec2 p, float t) {
    float r = noise(p + vec2(t * 0.1, 0.0));
    float g = noise(p + vec2(0.0, t * 0.15));
    float b = noise(p + vec2(-t * 0.1, t * 0.05));
    return vec3(r, g, b);
}

void main(){
    // Center uv coordinates
    vec2 centered = uv - 0.5;
    
    // Convert to polar coordinates
    float angle = atan(centered.y, centered.x);
    float radius = length(centered);
    
    // Create swirling spiral effect from cosmic dynamics
    float spiral = sin(10.0 * radius - time * 4.0 + angle * 5.0);
    
    // Create organic noise-based background texture
    float n = noise(uv * 15.0 + vec2(time));
    
    // Hybrid effect: blend glitch disturbances with cosmic spiral dynamics
    vec3 baseColor = mix(vec3(0.1, 0.0, 0.2), vec3(0.2, 0.8, 1.0), radius);
    vec3 spiralColor = vec3(0.5 + 0.5 * spiral);
    vec3 glitch = glitchColor(centered * 2.0, time);
    
    // Combine the layers in a non-linear emergent structure
    vec3 color = mix(baseColor, spiralColor, 0.5);
    color = mix(color, glitch, 0.25);
    
    // Introduce a vignette effect with noise modulation for depth
    float vignette = smoothstep(0.7, 0.3, radius);
    color *= vignette * (0.5 + 0.5 * n);
    
    gl_FragColor = vec4(color, 1.0);
}