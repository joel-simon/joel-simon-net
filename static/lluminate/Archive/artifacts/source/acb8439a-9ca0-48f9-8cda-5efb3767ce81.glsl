precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233)))*43758.5453);
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

void main(){
    // Transform coordinates to centered space and add time-based offset.
    vec2 p = (uv - 0.5) * 2.0;
    p *= 1.2;
    vec2 orig = p;
    
    // Twist effect: rotate based on distance from center and time.
    float r = length(p);
    float angle = time * 0.5 + sin(r * 10.0 - time) * 0.8;
    p = rotate(p, angle);
    
    // Fractal-like iterative distortion.
    float accum = 0.0;
    vec2 seed = p;
    float scale = 1.0;
    for (int i = 0; i < 6; i++){
        // Create a mirrored and warped repetition structure.
        seed = abs(seed) / dot(seed, seed + 0.7) - 0.5;
        float damp = exp(-length(seed) * scale);
        accum += damp;
        scale *= 1.3;
    }
    
    // Create a dynamic noise ripple using the hash function.
    float n = hash(p * 3.5 + time);
    float ripple = sin(10.0 * r - time*2.0 + n * 6.2831);
    
    // Compute a color palette that shifts with time and fractal motion.
    vec3 colorA = vec3(0.5 + 0.5*sin(time + p.x * 3.0), 0.5 + 0.5*cos(time + p.y * 2.5), 0.6 + 0.4*sin(time + accum));
    vec3 colorB = vec3(0.2 + 0.8*n, 0.3 + 0.7*(1.0 - n), 0.4 + 0.6*sin(ripple));
    
    // Blend colors with dynamically modulated weight.
    float blend = smoothstep(0.2, 1.0, accum * 0.7 + r - ripple * 0.1);
    vec3 finalColor = mix(colorA, colorB, blend);
    
    gl_FragColor = vec4(finalColor, 1.0);
}