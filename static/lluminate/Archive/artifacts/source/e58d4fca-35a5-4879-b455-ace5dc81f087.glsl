precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;
const int ITERATIONS = 10;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float hash(vec2 p) {
    return fract(43758.5453 * sin(dot(p, vec2(12.9898,78.233))));
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

float fractal(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < ITERATIONS; i++) {
        value += noise(p) * amplitude;
        p = rotate(p, time * 0.1 + float(i) * 0.5);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

void main(){
    // Center uv coordinates around (0,0) and adjust scale.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Introduce a pulsating distortion.
    float dist = length(pos);
    float radialDistort = sin(dist * 12.0 - time * 2.0);
    pos *= 1.0 + 0.2 * radialDistort;
    
    // Convert coordinates to polar for additional twisting.
    float a = atan(pos.y, pos.x);
    float r = length(pos);
    a += 0.5 * sin(time + r * 8.0);
    pos = vec2(cos(a), sin(a)) * r;
    
    // Apply fractal noise to get a complex, organic pattern.
    float pattern = fractal(pos * 3.0 + time);
    pattern = smoothstep(0.35, 0.65, pattern);
    
    // Create a dynamic color palette.
    vec3 color1 = vec3(0.1, 0.3, 0.6);
    vec3 color2 = vec3(0.8, 0.6, 0.2);
    vec3 color3 = vec3(0.2, 0.7, 0.5);
    
    // Mix colors using both the fractal pattern and radial distance.
    vec3 col = mix(color1, color2, pattern);
    col = mix(col, color3, smoothstep(0.0, 1.0, r));
    
    // Add a swirling highlight streak effect.
    float streak = sin(5.0 * a + time * 3.0);
    col += 0.15 * vec3(streak, streak * 0.7, 1.0 - streak);
    
    // Darken edges with a vignette effect.
    float vignette = smoothstep(0.8, 0.2, r);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}