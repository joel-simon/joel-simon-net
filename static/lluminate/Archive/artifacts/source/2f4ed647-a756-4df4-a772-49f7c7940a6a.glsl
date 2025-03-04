precision mediump float;
varying vec2 uv;
uniform float time;

float hash(float n) {
    return fract(sin(n) * 43758.5453);
}

float hash(vec2 p) {
    return fract(1e4 * sin(17.0*p.x + 0.1*p.y) * (0.1 + abs(sin(13.0*p.y + p.x))));
}

float noise(in vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f*f*(3.0-2.0*f);
    float n = mix(mix(hash(i), hash(i+vec2(1.0,0.0)), f.x),
                  mix(hash(i+vec2(0.0,1.0)), hash(i+vec2(1.0,1.0)), f.x), f.y);
    return n;
}

vec3 colorShift(float t) {
    return 0.5 + 0.5*cos(6.28318*t + vec3(0.0, 0.33, 0.67));
}

void main(){
    // Normalize and center coordinates
    vec2 p = (uv - 0.5) * 2.0;
    
    // Rotate space in a non-linear, time-dependent way
    float angle1 = sin(time * 0.7) * 3.1415;
    float s1 = sin(angle1), c1 = cos(angle1);
    p = vec2(p.x*c1 - p.y*s1, p.x*s1 + p.y*c1);
    
    // Radial distortion mixed with noise
    float r = length(p);
    float theta = atan(p.y, p.x);
    float twist = sin(r * 8.0 - time*2.3);
    
    // Modify angle with twist and noise perturbation
    theta += twist * 0.5 + noise(p*4.0 + time)*1.0;
    
    // Create a warped coordinate in polar space for fractal layering
    vec2 warp;
    warp.x = r * cos(theta);
    warp.y = r * sin(theta);
    
    // Iterative fractal layers with radial noise and rotation feedback.
    float iter = 0.0;
    float accum = 0.0;
    vec2 q = warp;
    for(int i = 0; i < 7; i++){
        float scale = 1.2 + float(i)*0.15;
        q = vec2(q.x * cos(time*0.2*scale) - q.y * sin(time*0.2*scale),
                 q.x * sin(time*0.2*scale) + q.y * cos(time*0.2*scale));
        float nVal = noise(q * scale + time*0.3);
        accum += smoothstep(0.3, 0.0, abs(nVal - 0.5)) / (float(i) + 1.0);
        iter += 1.0;
    }
    
    // Create shifting color base depending on fractal accumulation.
    float mixVal = accum / iter + noise(p*8.0 + time);
    vec3 col = colorShift(mixVal + time * 0.1);
    
    // Add vignette effect based on distance
    float vignette = smoothstep(0.8, 0.3, r);
    
    gl_FragColor = vec4(col * vignette, 1.0);
}