precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;
const int ITER = 8;

float hash(float n) {
    return fract(sin(n)*43758.5453123);
}

float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    return mix(mix(hash(n+0.0), hash(n+1.0), f.x),
               mix(hash(n+57.0),hash(n+58.0), f.x),f.y);
}

float fbm(vec2 p) {
    float res = 0.0, amp = 0.5;
    for (int i = 0; i < ITER; i++) {
        res += noise(p)*amp;
        p *= 2.0;
        amp *= 0.5;
    }
    return res;
}

vec2 kaleido(vec2 p, float sectors) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    angle = mod(angle, 2.0*PI/sectors);
    angle = abs(angle - PI/sectors);
    return vec2(cos(angle), sin(angle)) * radius;
}

void main(){
    // Center and scale uv to [-1,1]
    vec2 pos = uv * 2.0 - 1.0;
    
    // Introduce dynamic radial distortion and kaleidoscopic symmetry
    pos = kaleido(pos, 6.0 + 2.0*sin(time*0.31));
    
    // Apply time-based swirling twist
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float twist = sin(radius * 10.0 - time*2.3)*0.5;
    angle += twist;
    pos = vec2(cos(angle), sin(angle)) * radius;
    
    // Hyper-fractal warp using fbm
    float warp = fbm(pos*3.0 + time*0.5);
    pos += vec2(warp, -warp*0.8);
    
    // Create layers of dynamic noise and waves
    float layer1 = sin(pos.x*4.0 + time) + cos(pos.y*4.0 - time*1.2);
    float layer2 = fbm(pos*5.0 + vec2(time*0.7));
    float pattern = mix(layer1, layer2, 0.5);
    
    // Generate color based on polar coordinates and pattern
    vec3 colorA = vec3(0.2 + 0.3*sin(time+pattern), 0.5 + 0.4*cos(time+pattern*0.8), 0.7+0.2*sin(time*1.2));
    vec3 colorB = vec3(0.8 - 0.3*sin(time*0.9+pattern), 0.3+0.5*cos(time*0.7+pattern), 0.4+0.3*sin(time+pattern*1.3));
    float mixVal = smoothstep(-1.0, 1.0, pattern);
    vec3 col = mix(colorA, colorB, mixVal);
    
    // Vignette effect using radial falloff
    float vignette = smoothstep(0.9, 0.2, length(uv-0.5));
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}