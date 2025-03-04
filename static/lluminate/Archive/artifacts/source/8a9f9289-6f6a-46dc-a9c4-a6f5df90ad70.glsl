precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(23.1407, 91.0983))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)*u.y*(1.0 - u.x) + (d - b)*u.x*u.y;
}

float fractalNoise(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec3 colorPalette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(void) {
    // Transform uv to centered coordinates with aspect correction
    vec2 p = uv * 2.0 - 1.0;
    
    // Introduce a swirling twist that dynamically evolves
    float angle = atan(p.y, p.x);
    float radius = length(p);
    float twist = sin(time + radius * 10.0) * 0.5;
    angle += twist;
    vec2 twistedUV = vec2(cos(angle), sin(angle)) * radius;
    
    // Create layered fractal noise with time-varying offsets
    float n1 = fractalNoise(twistedUV * 3.0 + time * 0.5);
    float n2 = fractalNoise(twistedUV * 6.0 - time * 0.8);
    float pattern = mix(n1, n2, sin(time + radius * 5.0)*0.5 + 0.5);
    
    // Apply a radial ripple effect based on multiple offset layers
    float ripple = sin(10.0 * radius - time * 3.0 + pattern * 5.0);
    float mask = smoothstep(0.4, 0.0, abs(ripple));
    
    // Create an interference pattern by iterating transformations
    vec2 q = twistedUV;
    float interference = 0.0;
    for (int i = 0; i < 4; i++) {
        q = vec2(q.x * cos(0.8) - q.y * sin(0.8), q.x * sin(0.8) + q.y * cos(0.8));
        interference += noise(q * (float(i) * 1.5 + 1.0) + time);
    }
    interference = interference / 4.0;
    
    // Combine different effects into a final blend factor
    float blend = mix(pattern, interference, 0.5);
    blend *= mask;
    
    // Create a dynamic color palette evolving over time
    vec3 col = colorPalette(blend,
                            vec3(0.2, 0.1, 0.35),
                            vec3(0.5, 0.4, 0.7),
                            vec3(1.0, 0.8, 0.6),
                            vec3(time * 0.1, time * 0.15, time * 0.05));
    
    // Apply a subtle vignette effect to focus the view
    float vignette = smoothstep(1.0, 0.2, radius);
    col *= vignette;
    
    gl_FragColor = vec4(col, 1.0);
}