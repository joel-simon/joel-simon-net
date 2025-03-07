precision mediump float;
varying vec2 uv;
uniform float time;

// Basic random function using uv coordinates
float random (in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function with smooth interpolation
float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    vec2 u = f*f*(3.0-2.0*f);
    
    return mix(a, b, u.x) + (c - a)*u.y*(1.0-u.x);
}

// Function to simulate origami fold behavior
vec2 origamiFold(in vec2 p, float folds) {
    // Scale and translate to create repeated folds
    p *= folds;
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    
    // Mirror fold: reflect over midpoint of each cell
    fp = abs(fp - 0.5);
    
    return fp;
}

// Function to create ripple effect representing fluid dynamics
float ripple(in vec2 p, float frequency, float speed) {
    float d = length(p);
    return sin(frequency * d - time * speed);
}

void main() {
    // Center uv to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply origami fold distortions (mimicking paper folding)
    vec2 folded = origamiFold(pos, 6.0);
    
    // Introduce fluidic ripples from a moving center point 
    vec2 rippleCenter = vec2(sin(time * 0.5), cos(time * 0.5));
    float rippleEffect = ripple(pos - rippleCenter, 20.0, 3.0);
    
    // Mix noise to add granular texture reminiscent of natural bubble surfaces in cosmic scenes
    float n = noise(pos * 3.0 + time * 0.5);
    
    // Synthesize elements: combining structured origami folds and fluid ripple dynamics
    float synth = smoothstep(0.3, 0.7, folded.x + folded.y + 0.5 * rippleEffect + 0.3 * n);
    
    // Dynamic color mapping blending cool cosmic blues with warm origami reds
    vec3 colorA = vec3(0.1, 0.2, 0.6);
    vec3 colorB = vec3(0.8, 0.3, 0.2);
    
    // Controlled stratification based on synthesized value transformed into bands
    float bands = smoothstep(0.4, 0.5, fract(synth * 10.0));
    
    vec3 color = mix(colorA, colorB, synth);
    color += bands * vec3(0.1, 0.1, 0.05);
    
    // Vignette effect to focus attention toward the center
    float vignette = smoothstep(1.2, 0.3, length(pos));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}