precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

vec3 palette(float t, vec3 a, vec3 b, vec3 c, vec3 d) {
    return a + b * cos(6.28318 * (c * t + d));
}

void main(){
    // Reverse the assumption: Instead of mapping uv to continuous color gradients, we fragment space.
    vec2 st = uv * 2.0 - 1.0;
    
    // Create a warped space with a swirling distortion.
    float angle = time * 0.5;
    float s = sin(angle);
    float c = cos(angle);
    mat2 rot = mat2(c, -s, s, c);
    st = rot * st;
    
    // Use an iterative fractal structure to disrupt standard smooth interpolation.
    float f = fbm(st * 3.0 + time);
    
    // Instead of smooth gradients, we pick distinct bands:
    float band = smoothstep(0.2, 0.21, fract(f * 10.0));
    
    // Reverse assumption: use noise to generate hard edges and fragment the space.
    float edge = step(0.5, noise(st * 10.0 - time));
    
    // Blend two color palettes: one organic, one digital.
    vec3 organic = palette(f, vec3(0.5), vec3(0.5), vec3(1.0, 0.8, 0.4), vec3(0.0, 0.33, 0.67));
    vec3 digital = palette(f, vec3(0.3), vec3(0.7), vec3(0.4, 0.2, 1.0), vec3(0.2, 0.4, 0.6));
    
    // Fragment space via abrupt transitions.
    vec3 color = mix(organic, digital, edge);
    
    // Introduce an unexpected glitch band.
    color = mix(color, vec3(0.0), band);
    
    // Final modulation with time-dependent brightness.
    color *= 0.5 + 0.5 * sin(time + length(st) * 10.0);
    
    gl_FragColor = vec4(color, 1.0);
}