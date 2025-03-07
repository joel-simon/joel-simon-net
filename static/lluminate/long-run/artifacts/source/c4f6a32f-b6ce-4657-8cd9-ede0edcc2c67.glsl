precision mediump float;
varying vec2 uv;
uniform float time;

// Random number generation using sin/dot
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise based on random numbers and smooth interpolation
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Glitch offset using fbm and time
vec2 glitchOffset(vec2 pos) {
    float n = fbm(pos * 8.0 + time * 0.5);
    pos.x += smoothstep(0.3, 0.7, n) * 0.05 * sin(time * 10.0);
    pos.y += smoothstep(0.3, 0.7, n) * 0.05 * cos(time * 10.0);
    return pos;
}

// Organic tree branch effect using polar coordinates and sinusoidal oscillations
float treeBranch(vec2 p, float t) {
    float r = length(p);
    float angle = atan(p.y, p.x);
    float branch = sin(5.0 * angle + t) * exp(-3.0 * r);
    return branch;
}

// Swirling digital distortion effect
vec2 swirl(vec2 pos, float t) {
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float swirlFactor = sin(radius * 10.0 - t) * 0.2;
    angle += swirlFactor;
    return vec2(radius * cos(angle), radius * sin(angle));
}

// Color modulation blending organic and digital glitch aesthetics
vec3 colorModulation(vec2 pos, float t) {
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float circle = smoothstep(0.4, 0.41, length(pos - 0.5));
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    vec3 color = mix(colorA, colorB, stripes);
    color = mix(color, vec3(0.0), circle);
    color.r += (noise(pos + t)-0.5)*0.1;
    color.g += (noise(pos - t)-0.5)*0.1;
    color.b += (noise(pos * 1.5)-0.5)*0.1;
    return color;
}

void main(){
    // Anchor: Organic growth meets digital glitch
    // Normalize uv to center coordinates [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Apply glitch distortion to generate interplay
    vec2 glitchUV = glitchOffset(uv);
    
    // Medium association: Tree branches (organic growth)
    vec2 centered = (glitchUV - 0.5) * 2.0;
    float branchEffect = treeBranch(centered, time);
    
    // Abstract swirling transformation to amplify digital glitch
    vec2 swirled = swirl(uv, time);
    
    // Create fractal texture for organic detail
    float fractalDetail = fbm(centered * 3.0 + time);
    
    // Background gradient evolving with polar angle
    float angle = atan(centered.y, centered.x);
    vec3 gradient = mix(vec3(0.1,0.2,0.4), vec3(0.8,0.4,0.2), (sin(angle + time)+1.0)*0.5);
    
    // Blend organic texture from branch effect with fractal detail
    float organicPattern = smoothstep(0.2,0.25,abs(branchEffect)) + fractalDetail * 0.3;
    
    // Generate digital glitch color modulation
    vec3 digitalColor = colorModulation(uv, time);
    
    // Combine all effects for a balanced final color
    vec3 combined = mix(gradient, digitalColor, organicPattern);
    
    // Apply subtle pulsating effect based on radial distance in swirled space
    float radial = length(swirled - 0.5);
    float pulse = smoothstep(0.3, 0.32, radial + 0.1 * sin(time * 3.0));
    
    gl_FragColor = vec4(combined * pulse, 1.0);
}