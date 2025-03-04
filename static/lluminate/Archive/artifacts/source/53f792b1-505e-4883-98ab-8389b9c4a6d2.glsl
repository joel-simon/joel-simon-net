precision mediump float;
varying vec2 uv;
uniform float time;

// 2D rotation function
mat2 rotate(float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return mat2(c, -s, s, c);
}

// Hash function for pseudo-random number generation
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// 2D Noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Fractal noise (FBM)
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

void main(){
    // Center and scale uv coordinates
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a time based rotation and stretching effect
    pos *= rotate(time * 0.3);
    pos.x *= 1.2;
    
    // Convert to polar coordinates
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    
    // Create a kaleidoscopic effect by reflecting the angle in segments
    float segments = 6.0;
    angle = mod(angle, 6.2831853/segments);
    
    // Apply twisting effect influenced by fbm noise
    float n = fbm(pos * 3.0 + time * 0.5);
    float twist = sin(angle * 3.0 + n * 3.1415 + time);
    
    // Generate color variations based on radius, angle, and twist
    vec3 col;
    col.r = 0.5 + 0.5 * cos(3.1415 * radius + twist);
    col.g = 0.5 + 0.5 * sin(3.1415 * angle + time + n);
    col.b = 0.5 + 0.5 * cos((radius + angle) * 2.0 - time);
    
    // Mix with an outer vignette effect
    float vignette = smoothstep(1.0, 0.2, radius);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}