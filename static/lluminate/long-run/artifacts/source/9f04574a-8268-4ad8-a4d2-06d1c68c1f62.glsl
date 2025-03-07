precision mediump float;
varying vec2 uv;
uniform float time;

// 2D rotation matrix
mat2 rotate(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

// A pseudo noise function based on uv coordinates and time
float noise(in vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);
    
    float res = mix(
        mix( fract(sin(dot(ip, vec2(127.1, 311.7))) * 43758.5453),
             fract(sin(dot(ip + vec2(1.0, 0.0), vec2(127.1, 311.7))) * 43758.5453), 
             u.x),
        mix( fract(sin(dot(ip + vec2(0.0, 1.0), vec2(127.1, 311.7))) * 43758.5453),
             fract(sin(dot(ip + vec2(1.0, 1.0), vec2(127.1, 311.7))) * 43758.5453),
             u.x), 
        u.y);
    return res;
}

// Creates a fractal field of swirling shapes
float fractalSwirl(vec2 p) {
    float amplitude = 0.5;
    float frequency = 2.0;
    float sum = 0.0;
    for (int i = 0; i < 5; i++) {
        // Rotate coordinates
        p = rotate(time*0.1 + float(i)*0.5) * p;
        // Add swirling by distorting with sine function
        vec2 q = p + vec2(sin(p.y*frequency + time*0.5), cos(p.x*frequency + time*0.5));
        float n = noise(q*frequency);
        sum += amplitude * n;
        amplitude *= 0.5;
        frequency *= 2.0;
        p *= 1.5;
    }
    return sum;
}

void main() {
    // Center coordinates: transform uv from [0,1] to [-1,1] with aspect correction
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create a swirling distortion effect
    float swirl = sin(length(pos)*10.0 - time*2.0);
    pos += normalize(pos) * swirl * 0.1;
    
    // Generate fractal swirl pattern
    float pattern = fractalSwirl(pos);
    
    // Radial gradient for vignette effect
    float vignette = smoothstep(1.0, 0.0, length(pos));
    
    // Color dynamics: blend from deep blue to vivid magenta using pattern
    vec3 colorA = vec3(0.1, 0.2, 0.8);
    vec3 colorB = vec3(0.8, 0.1, 0.5);
    vec3 color = mix(colorA, colorB, pattern);
    
    // Final blend with vignette for depth
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}