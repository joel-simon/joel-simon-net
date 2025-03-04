precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
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

vec2 rotate(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(p.x * c - p.y * s, p.x * s + p.y * c);
}

vec2 kaleidoscope(vec2 p, float sectors) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float sectorAngle = 3.14159265 / sectors;
    angle = mod(angle, 2.0 * sectorAngle);
    angle = abs(angle - sectorAngle);
    return vec2(cos(angle), sin(angle)) * radius;
}

void main(){
    // Center and scale coordinates.
    vec2 p = (uv - 0.5) * 2.0;
    
    // Apply time-dependent rotation.
    p = rotate(p, time * 0.5);
    
    // Apply a kaleidoscopic transformation.
    p = kaleidoscope(p, 6.0 + sin(time)*2.0);
    
    // Create layered noise and fractal distortion.
    float n1 = noise(p * 3.0 + time);
    float n2 = noise(p * 6.0 - time * 1.2);
    float n = mix(n1, n2, 0.5);
    
    // Distort coordinates with noise.
    p += 0.3 * vec2(sin(n * 6.2831 + time), cos(n * 6.2831 - time));
    
    // Generate radial pattern for vignette and intensity.
    float radial = smoothstep(1.0, 0.0, length(p));
    
    // Dynamic color generation with sinusoidal mixing.
    float angle = atan(p.y, p.x);
    vec3 col;
    col.r = 0.5 + 0.5 * sin(angle * 3.0 + time + n * 6.2831);
    col.g = 0.5 + 0.5 * sin(angle * 3.0 + time + n * 6.2831 + 2.094);
    col.b = 0.5 + 0.5 * sin(angle * 3.0 + time + n * 6.2831 + 4.188);
    
    // Combine pattern with vignette.
    col *= radial;
    
    gl_FragColor = vec4(col, 1.0);
}