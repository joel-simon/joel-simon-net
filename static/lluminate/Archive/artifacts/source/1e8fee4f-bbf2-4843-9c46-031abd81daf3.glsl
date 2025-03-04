precision mediump float;
varying vec2 uv;
uniform float time;

const int ITERATIONS = 6;
const float PI = 3.141592653589793;

float pattern(vec2 p) {
    // Iterate a fractal swirling twist transformation.
    float strength = 0.5;
    float accum = 0.0;
    float freq = 1.0;
    for (int i = 0; i < ITERATIONS; i++) {
        float angle = atan(p.y, p.x) + time * 0.5;
        float radius = length(p);
        // Twist and distort using sinusoidal modulation
        float twist = sin(angle * freq + time * 0.5) * strength;
        p = vec2(p.x * cos(twist) - p.y * sin(twist),
                 p.x * sin(twist) + p.y * cos(twist));
        accum += sin(p.x * 3.0 + time) * cos(p.y * 3.0 + time);
        freq *= 1.5;
        strength *= 0.7;
        p *= 1.2;
    }
    return accum;
}

void main(){
    // Center uv coordinates from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply a non-linear lens distortion based on radial distance.
    float rad = length(pos);
    float lens = smoothstep(1.0, 0.0, rad);
    pos *= 1.0 + lens * 0.8;
    
    // Convert to polar for additional twist effects.
    float a = atan(pos.y, pos.x);
    float r = length(pos);
    
    // Apply a swirling time based distortion.
    float swirl = sin(r * 10.0 - time * 2.0 + a * 5.0);
    float distortion = smoothstep(0.0, 1.0, swirl * 0.5 + 0.5);
    a += distortion * 0.8;
    
    // Spiral back to cartesian coordinates.
    vec2 spiralPos = vec2(cos(a), sin(a)) * r;
    
    // Generate an intricate fractal-based pattern.
    float fractal = pattern(spiralPos * 1.5);
    fractal = fractal * 0.5 + 0.5;
    
    // Color palette based on angle and fractal intensity.
    vec3 colA = vec3(0.2, 0.4, 0.8);
    vec3 colB = vec3(0.8, 0.3, 0.5);
    vec3 colC = vec3(0.1, 0.8, 0.6);
    
    float mixVal = smoothstep(0.2, 0.8, r);
    vec3 color = mix(colA, colB, mixVal);
    color = mix(color, colC, fractal);
    color *= 1.0 - smoothstep(0.9, 1.0, r);
    
    // Vignette effect.
    float vignette = smoothstep(0.8, 0.5, r);
    color *= vignette; 
    
    gl_FragColor = vec4(color, 1.0);
}