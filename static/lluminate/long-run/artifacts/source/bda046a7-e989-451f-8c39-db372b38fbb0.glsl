precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

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

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

float crystalShape(vec2 p) {
    // Establish a crystalline shape with recursive folding and angular modulation
    float angle = atan(p.y, p.x);
    float radius = length(p);
    // Create a repeated angular pattern by modulating the angle
    float n = abs(mod(angle * 3.0, 3.1416) - 1.5708);
    float shape = smoothstep(0.02, 0.05, n - radius*0.7);
    return shape;
}

vec3 crystalColor(vec2 p, float t) {
    // Use fbm to produce subtle color variations reminiscent of light refracting in crystals
    float n = fbm(p * 3.0 + t * 0.3);
    vec3 col1 = vec3(0.1, 0.4, 0.8);
    vec3 col2 = vec3(0.8, 0.3, 0.6);
    return mix(col1, col2, n);
}

void main(){
    // Normalize and center coordinates
    vec2 st = uv * 2.0 - 1.0;
    
    // Introduce a swirling distortion mapping, representing the fluid evolution of a crystal structure
    vec2 pos = st;
    pos = rotate(pos, sin(time * 0.5) * 0.8);
    pos += vec2(fbm(st * 4.0 + time), fbm(st * 4.0 - time)) * 0.15;
    
    // Generate the crystalline pattern
    float shape = crystalShape(pos);
    
    // Generate color variation by mixing two palettes using fbm noise
    vec3 col = crystalColor(pos, time);
    
    // Overlay subtle glitch lines to add a digital disturbance element
    float glitch = step(0.98, fract(sin(dot(st, vec2(12.345,67.890)) * time)));
    col = mix(col, vec3(1.0, 1.0, 1.0), glitch * 0.3);
    
    // Blend the crystal pattern with a dark background
    vec3 background = vec3(0.02, 0.02, 0.05);
    vec3 finalColor = mix(background, col, shape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}