precision mediump float;
varying vec2 uv;
uniform float time;

float pseudoRandom(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = pseudoRandom(i);
    float b = pseudoRandom(i + vec2(1.0, 0.0));
    float c = pseudoRandom(i + vec2(0.0, 1.0));
    float d = pseudoRandom(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

void main(){
    // Normalize and offset UV coordinates
    vec2 st = uv * 2.0 - 1.0;
    st.x *= 1.2;
    
    // Transform coordinates into polar form.
    float r = length(st);
    float a = atan(st.y, st.x);
    
    // Anchor concept: "organically digital transition"
    // Medium-distance association: "time-evolving fractal petals"
    // Develop association: modulate a fractal petal-like structure with polar coordinates and noise.
    
    // Create a base swirling petal pattern using sine and cosine with angular frequency.
    float petal = abs(cos(4.0 * a + time * 1.3));
    
    // Introduce an evolving ripple influenced by radial distance and fractal noise.
    float ripple = sin(15.0 * r - time * 2.0 + noise(st * 3.0) * 6.28);
    
    // Combine petal and ripple effects
    float mixPattern = smoothstep(0.2, 0.3, petal * ripple + 0.3);
    
    // Create a glitch effect by perturbing the angle with additional noise.
    float glitch = noise(st * 10.0 + time);
    a += (glitch - 0.5) * 0.5;
    
    // Recalculate a modified petal pattern post glitch
    float modPetal = abs(cos(4.0 * a - time * 0.8));
    
    // Mix patterns in two layers (organic petal vs fractured glitch)
    float finalPattern = mix(mixPattern, modPetal, 0.5 + 0.5 * sin(time + r * 10.0));
    
    // Color transitions: mix warm and cool based on the final pattern and radius.
    vec3 warm = vec3(0.8, 0.5, 0.2) + 0.3 * cos(vec3(time, time + 2.0, time + 4.0));
    vec3 cool = vec3(0.2, 0.5, 0.8) + 0.3 * sin(vec3(time, time + 3.0, time + 5.0));
    vec3 color = mix(warm, cool, finalPattern);
    
    // Introduce a subtle vignette effect using radial distance.
    float vignette = smoothstep(0.8, 0.3, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}