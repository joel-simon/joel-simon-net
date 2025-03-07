precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++){
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 glitchOffset(in vec2 pos, float strength) {
    float angle = fbm(pos * 10.0 + time);
    vec2 offset = vec2(cos(angle), sin(angle));
    return pos + offset * strength;
}

void main(void) {
    // Transform uv into center perspective
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply a glitch distortion on coordinates
    pos = glitchOffset(pos, 0.03);
    
    // Convert to polar coordinates
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Organic branch: create a tree-like branching effect with polar modulation
    float branch = smoothstep(0.2, 0.18, abs(r - 0.5 - 0.1 * sin(a * 4.0 + time)));
    
    // Add fractal noise for organic texture
    float texture = fbm(pos * 3.0 + time*0.5);
    
    // Generate a swirling background
    float swirl = 0.5 + 0.5*sin(a * 3.0 - r*4.0 + time);
    
    // A dynamic gradient blending warm and cool tones
    vec3 warm = vec3(0.9, 0.5, 0.2);
    vec3 cool = vec3(0.2, 0.6, 0.9);
    vec3 gradient = mix(warm, cool, uv.y);
    
    // Combine effects: branch structure modulated by texture and swirl
    float combine = branch * texture * swirl;
    vec3 color = gradient + combine * vec3(0.4, 0.8, 0.5);
    
    // Introduce subtle glitch lines overlay
    float line = smoothstep(0.48, 0.5, noise(uv * 50.0 + time*3.0));
    color += vec3(line * 0.15);
    
    gl_FragColor = vec4(color, 1.0);
}