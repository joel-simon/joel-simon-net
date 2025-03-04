precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7)))*43758.5453123);
}

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

vec2 swirl(vec2 p, float strength) {
    float r = length(p);
    float a = atan(p.y, p.x);
    a += strength / (r + 0.1);
    return vec2(r * cos(a), r * sin(a));
}

void main(){
    // Center coordinates around (0,0) and scale
    vec2 p = (uv - 0.5) * 2.0;
    
    // Create a time evolving swirl effect
    float swirlStrength = sin(time * 0.8) * 2.0;
    p = swirl(p, swirlStrength);
    
    // Generate multiple noise layers with varying frequencies
    float n = noise(p * 2.0 + time);
    float n2 = noise(p * 4.0 - time * 1.3);
    float n3 = noise(p * 8.0 + vec2(sin(time), cos(time)));
    
    // Combine noise layers non-linearly
    float pattern = mix(n, n2, 0.5) + 0.5 * n3;
    
    // Create dynamic radial distortion
    float r = length(p);
    float radial = smoothstep(1.2, 0.0, r + 0.3 * sin(time + pattern * 6.2831));
    
    // Generate color channels with phase offsets, enhanced by pattern
    float val = sin(pattern * 6.2831 + time);
    vec3 color;
    color.r = sin(val * 3.1415 + time * 1.1) * 0.5 + 0.5;
    color.g = sin(val * 3.1415 + time * 0.9) * 0.5 + 0.5;
    color.b = sin(val * 3.1415 + time * 1.3) * 0.5 + 0.5;
    
    // Overlay a vignette-like darkening outer edge
    color *= radial;
    
    gl_FragColor = vec4(color, 1.0);
}