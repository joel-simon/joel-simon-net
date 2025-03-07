precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    float a = hash(i.x + i.y * 57.0);
    float b = hash(i.x + 1.0 + i.y * 57.0);
    float c = hash(i.x + (i.y + 1.0) * 57.0);
    float d = hash(i.x + 1.0 + (i.y + 1.0) * 57.0);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

vec3 organicCircuit(vec2 p) {
    // Anchor concept: organic patterns
    // Medium association: mechanical circuit lines blending into fluid forms
    vec2 center = vec2(0.5);
    vec2 pos = p - center;
    
    // Convert to polar coordinates for swirling effects
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Add a swirling modulation
    float swirl = sin(angle * 3.0 + time * 1.5);
    
    // Fractal noise to simulate organic digital trails 
    float n = fbm(pos * 3.0 + time);
    
    // Create a circuit-like pattern with a radial gradient and noise modulation
    float pattern = smoothstep(0.4, 0.38, radius + 0.1 * swirl) * (n * 0.8 + 0.2);
    
    // Additional layer: delicate digital crackle using sine waves on the angle axis
    float crackle = sin(20.0 * angle + time * 2.0) * 0.1 + 0.1;
    pattern += crackle * smoothstep(0.35, 0.38, radius);
    
    return vec3(pattern);
}

void main() {
    vec2 p = uv;
    
    // Background: blend of deep space and water-like hues creating a cosmic ocean.
    float bgFactor = fbm(p * 5.0 + time * 0.3);
    vec3 bgColor = mix(vec3(0.02, 0.05, 0.15), vec3(0.0, 0.2, 0.4), bgFactor);
    
    // Foreground: organic digital circuit pattern evolving over time.
    vec3 fgColor = organicCircuit(p);
    
    // Composite with dynamic time modulation to fuse nature with technology.
    float mixVal = smoothstep(0.3, 0.55, fbm(p * 8.0 - time));
    vec3 finalColor = mix(bgColor, fgColor * vec3(0.8, 0.6, 1.0), mixVal);
    
    gl_FragColor = vec4(finalColor, 1.0);
}