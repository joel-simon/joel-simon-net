precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-random value generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123);
}

// 2D noise function with smooth interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Hyperbolic swirl distortion
vec2 hyperSwirl(vec2 p, float strength) {
    float r = length(p);
    float theta = atan(p.y, p.x);
    theta += strength / (r + 0.1);
    return vec2(r * cos(theta), r * sin(theta));
}

// Kaleidoscopic reflection: mirror radial sectors
vec2 kaleido(vec2 p, float sectors) {
    float angle = atan(p.y, p.x);
    float r = length(p);
    float tau = 6.28318530718;
    angle = mod(angle, tau / sectors);
    angle = abs(angle - tau / (2.0 * sectors));
    return vec2(r * cos(angle), r * sin(angle));
}

void main(){
    // Normalize and center coordinates in range [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a gentle rotation over time
    float aRot = time * 0.3;
    mat2 rotation = mat2(cos(aRot), -sin(aRot), sin(aRot), cos(aRot));
    pos = rotation * pos;
    
    // Apply hyperbolic swirl
    pos = hyperSwirl(pos, 1.5 + 0.5 * sin(time * 0.7));
    
    // Apply kaleidoscopic mirroring with dynamic sectors between 4 and 8
    float sectors = 4.0 + 4.0 * abs(sin(time * 0.5));
    pos = kaleido(pos, sectors);
    
    // Introduce layered noise distortion
    float scale1 = 3.0;
    float scale2 = 7.0;
    float n1 = noise(pos * scale1 + time * 0.8);
    float n2 = noise(pos * scale2 - time * 1.1);
    
    // Create a fractal-like iterative effect
    float fractal = 0.0;
    vec2 q = pos;
    for (int i = 0; i < 3; i++){
        fractal += noise(q * 2.0 + time);
        q = q * 1.8 + n1 * 0.3;
    }
    fractal /= 3.0;
    
    // Combine effects: swirl, noise, and fractal texture
    float pattern = smoothstep(-0.2, 0.2, sin(4.0 * length(pos) - time * 2.0 + fractal)) +
                    0.3 * n1 + 0.2 * n2;
    
    // Dynamic color generation using sine and cosine waves with time modulation
    vec3 color;
    color.r = 0.5 + 0.5 * sin(pattern + pos.x + time);
    color.g = 0.5 + 0.5 * cos(pattern + pos.y - time * 0.7);
    color.b = 0.5 + 0.5 * sin(pattern * 3.0 + time * 0.9);
    
    // Apply a subtle vignette effect
    float vignette = smoothstep(1.2, 0.0, length(pos));
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}