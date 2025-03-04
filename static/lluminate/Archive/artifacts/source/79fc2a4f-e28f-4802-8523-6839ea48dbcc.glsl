precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;
const int ITERATIONS = 8;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    return mix(mix(hash(n+  0.0), hash(n+ 1.0), f.x),
               mix(hash(n+57.0), hash(n+58.0), f.x), f.y);
}

float spiralDistort(vec2 p) {
    float accum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < ITERATIONS; i++) {
        float r = length(p);
        float a = atan(p.y, p.x);
        // Create a spiral twist influenced by noise and time.
        float twist = sin(a * 4.0 + time * 0.8 + noise(p * 5.0) * PI);
        // Twist and warp the coordinate.
        float ca = cos(twist);
        float sa = sin(twist);
        p = vec2(p.x * ca - p.y * sa, p.x * sa + p.y * ca);
        // Accumulate a sine wave based on transformed x and radial distance.
        accum += sin(p.x * 3.0 + time) * amp;
        p *= 1.7;
        amp *= 0.65;
    }
    return accum;
}

void main(){
    // Center uv coordinates around (0,0) and scale.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Polar coordinates for radial effects.
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    
    // Apply an additional oscillating twist based on radial distance.
    a += sin(r * 12.0 - time * 1.3) * 0.8;
    pos = vec2(cos(a), sin(a)) * r;
    
    // Apply hyperbolic-like warp.
    float warp = 1.0 + 0.6 * sin(time + r * 15.0);
    pos *= warp;
    
    // Generate a complex spiral fractal distortion.
    float pattern = spiralDistort(pos);
    pattern = sin(pattern * PI);
    
    // Create dynamic color modulation.
    vec3 baseColor = vec3(0.15, 0.4, 0.8);
    vec3 highlight = vec3(0.9, 0.7, 0.3);
    vec3 accent = vec3(0.3, 0.8, 0.5);
    
    // Mix colors based on pattern and radial distance.
    float mixVal = smoothstep(-1.0, 1.0, pattern);
    vec3 color = mix(baseColor, highlight, mixVal);
    color = mix(color, accent, smoothstep(0.2, 0.8, r + 0.4*sin(time*0.9)));
    
    // Apply a soft vignette to focus towards center.
    float vignette = smoothstep(0.8, 0.1, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}