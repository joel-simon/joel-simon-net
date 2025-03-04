precision mediump float;
varying vec2 uv;
uniform float time;

const float PI = 3.14159265;
const int ITERATIONS = 7;

float hash(float n) {
    return fract(sin(n) * 43758.5453123);
}

float noise(vec2 x) {
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f * f * (3.0 - 2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix(hash(n +  0.0), hash(n +  1.0), f.x),
                    mix(hash(n + 57.0), hash(n + 58.0), f.x), f.y);
    return res;
}

float fractalPattern(vec2 p) {
    float accum = 0.0;
    float amp = 0.5;
    for (int i = 0; i < ITERATIONS; i++) {
        float angle = atan(p.y, p.x) + time * 0.3;
        float radius = length(p);
        float twist = sin(angle * 3.0 + time + noise(p * 3.0)) * 1.0;
        p = vec2(p.x * cos(twist) - p.y * sin(twist),
                 p.x * sin(twist) + p.y * cos(twist));
        accum += sin(p.x * 4.0 + time) * amp;
        p *= 1.5;
        amp *= 0.6;
    }
    return accum;
}

void main(){
    // Re-map uv to centered coordinates (-1, 1)
    vec2 pos = uv * 2.0 - 1.0;
    
    // Apply non-linear radial distortion and oscillation
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    float twistFactor = sin(r * 8.0 - time * 1.5);
    angle += twistFactor * 0.6;
    pos = vec2(cos(angle), sin(angle)) * r;
    
    // Hyperbolic warp on the coordinates
    float factor = (1.0 + 0.5 * sin(time + r * 10.0));
    pos *= factor;
    
    // Generate fractal pattern
    float fp = fractalPattern(pos);
    fp = sin(fp * PI);
    
    // Create a dynamic color palette
    vec3 col1 = vec3(0.2, 0.6, 0.9);
    vec3 col2 = vec3(0.9, 0.4, 0.3);
    vec3 col3 = vec3(0.3, 0.9, 0.5);
    
    // Use angular and radial values to mix colors
    float tMix = smoothstep(-1.0, 1.0, fp);
    vec3 color = mix(col1, col2, tMix);
    color = mix(color, col3, smoothstep(0.3, 0.7, r + 0.5*sin(time*0.7)));
    
    // Add soft vignette effect
    float vignette = smoothstep(0.8, 0.2, r);
    color *= vignette;
    
    gl_FragColor = vec4(color, 1.0);
}