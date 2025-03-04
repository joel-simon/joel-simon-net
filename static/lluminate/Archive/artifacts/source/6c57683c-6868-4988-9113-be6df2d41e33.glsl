precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

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

void main(){
    vec2 p = uv - 0.5;
    p *= 2.0;
    
    float r = length(p);
    float a = atan(p.y, p.x);
    
    // Create a kaleidoscopic effect with 6-fold symmetry
    float sectors = 6.0;
    float sectorAngle = 6.28318530718 / sectors;
    a = mod(a, sectorAngle);
    
    // Apply a time-based twist to the angle
    a += time * 0.5;
    
    // Convert back to Cartesian coordinates with modified angle
    vec2 uv2 = r * vec2(cos(a), sin(a));
    
    // Add noise-based distortion for organic variation
    float n = noise(uv2 * 3.0 + time);
    uv2 += n * 0.2;
    
    // Generate an intricate pattern using trigonometric interplay
    float pattern = sin(10.0 * uv2.x) * cos(10.0 * uv2.y);
    pattern += n * 0.5;
    
    // Create dynamic color mixing influenced by time and the pattern
    vec3 color = 0.5 + 0.5 * cos(time + vec3(0.0, 2.0, 4.0) + pattern + vec3(0.0, 1.0, 2.0));
    
    // Apply a vignette effect to draw focus to the center
    color *= smoothstep(1.0, 0.2, r);
    
    gl_FragColor = vec4(color, 1.0);
}