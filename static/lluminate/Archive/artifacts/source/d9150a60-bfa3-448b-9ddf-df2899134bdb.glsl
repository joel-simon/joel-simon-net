precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;
const int ITER = 10;

float hash(float n) {
    return fract(sin(n)*43758.5453123);
}

float noise(vec2 x) {
    vec2 i = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0 - 2.0*f);
    float n = i.x + i.y*57.0;
    return mix(mix(hash(n +  0.0), hash(n +  1.0), f.x),
               mix(hash(n + 57.0), hash(n + 58.0), f.x), f.y);
}

float fractalSwirl(vec2 p) {
    float accum = 0.0;
    float amplitude = 0.7;
    vec2 shift = vec2(1.2, -0.8);
    for (int i = 0; i < ITER; i++) {
        float r = length(p);
        float angle = atan(p.y, p.x);
        // Introduce a twist that evolves with time and noise.
        float twist = sin(angle*5.0 + time*0.5 + noise(p*4.0)*PI);
        float s = sin(twist);
        float c = cos(twist);
        p = vec2(p.x*c - p.y*s, p.x*s + p.y*c);
        // Add a fractal distortion and an offset.
        accum += sin(p.x * 3.0 + time + float(i)) * amplitude;
        p = p*1.5 + shift;
        amplitude *= 0.65;
    }
    return accum;
}

void main(){
    // Normalize coordinates to center.
    vec2 pos = (uv - 0.5) * 2.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Apply dynamic radial warping.
    angle += sin(radius*12.0 - time*1.2)*0.8;
    pos = vec2(cos(angle), sin(angle)) * radius;
    
    // Add an oscillating exponential twist.
    float expFactor = 1.0 + 0.5*sin(time + radius*10.0);
    pos *= expFactor;
    
    // Obtain a fractal swirl pattern.
    float pattern = fractalSwirl(pos);
    pattern = sin(pattern * PI);
    
    // Base colors with time evolving modulations.
    vec3 colorA = vec3(0.1, 0.3, 0.7);
    vec3 colorB = vec3(0.8, 0.6, 0.2);
    vec3 colorC = vec3(0.3, 0.9, 0.5);
    
    // Combine colors based on pattern and radial distance.
    float mixFactor = smoothstep(-1.0, 1.0, pattern);
    vec3 col = mix(colorA, colorB, mixFactor);
    col = mix(col, colorC, smoothstep(0.3, 0.7, radius + 0.35*sin(time*0.8)));
    
    // Enhance visual depth with a dynamic vignette.
    float vignette = smoothstep(0.9, 0.2, radius + 0.1*sin(time*1.3));
    col *= vignette;
    
    // Final output color.
    gl_FragColor = vec4(col, 1.0);
}