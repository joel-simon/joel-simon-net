precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898,78.233)))*43758.5453);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) * (1.0 - u.y) + mix(c, d, u.x) * u.y;
}

float fbm(vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 4; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec3 glitchLayer(vec2 pos) {
    float glitch = fbm(pos * 10.0 + time);
    return vec3(glitch * 0.8, glitch * 0.5, glitch);
}

vec3 fractalTree(vec2 pos) {
    // Convert to polar coordinates centered in the screen
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Use a combination of sine waves to emulate branching fractal structure
    float branch = sin(6.0 * a + time * 1.5) * 0.2 + sin(12.0 * a + time * 2.0) * 0.1;
    float trunk = smoothstep(0.0, 0.5, r);
    float pattern = smoothstep(branch - 0.02, branch + 0.02, r - 0.4);
    
    // Use colors reminiscent of organic wood with a hint of digital overlay
    vec3 baseColor = mix(vec3(0.2, 0.1, 0.0), vec3(0.8, 0.5, 0.2), pattern);
    return baseColor;
}

void main(){
    // Normalize and center uv coordinate system
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create an organic fractal tree branch pattern based on polar coordinates
    vec3 tree = fractalTree(pos);
    
    // Add textured glitch layer with dynamic noise overlay
    vec3 glitch = glitchLayer(pos);
    
    // Blend tree and glitch layers using a time-varying mixing factor
    float mixFactor = 0.5 + 0.5 * sin(time * 0.8);
    vec3 color = mix(tree, glitch, mixFactor);
    
    gl_FragColor = vec4(color, 1.0);
}