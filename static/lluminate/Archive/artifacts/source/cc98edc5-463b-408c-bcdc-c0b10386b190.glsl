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
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(){
    // Normalize uv to range [-1,1]
    vec2 p = uv * 2.0 - 1.0;
    float r = length(p);
    float theta = atan(p.y, p.x);
    
    // Swirl transformation that evolves over time.
    float swirl = sin(5.0 * theta + time) * 0.5;
    p += vec2(cos(theta), sin(theta)) * swirl;
    
    // Apply layered fractal noise with iterative transformations.
    float lum = 0.0;
    vec2 pos = p;
    for (int i = 0; i < 6; i++){
        float scale = pow(2.0, float(i));
        lum += noise(pos * scale + time) / (float(i) + 1.0);
        // Twist the coordinate space based on noise and time.
        float angle = sin(time + pos.x*pos.y) * 0.5;
        pos = vec2(pos.x * cos(angle) - pos.y * sin(angle),
                   pos.x * sin(angle) + pos.y * cos(angle));
    }
    
    // Combine geometry and iteration results to create a mixing parameter.
    float mixFactor = smoothstep(0.0, 1.0, lum + r);
    
    // Dynamic color palette evolving with angle and time.
    vec3 col = palette(mixFactor + time * 0.1,
                       vec3(0.2, 0.3, 0.4),
                       vec3(0.3),
                       vec3(0.5, 0.3, 0.7),
                       vec3(theta/6.28318, 0.2, 0.3));
    
    // Apply a vignette effect to draw focus toward the center.
    col *= smoothstep(1.0, 0.3, r);
    
    gl_FragColor = vec4(col, 1.0);
}