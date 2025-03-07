precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

vec2 spiral(vec2 p, float angle) {
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c*p.x - s*p.y, s*p.x + c*p.y);
}

void main(){
    // draw_random_card: "Honor thy error as a hidden intention"
    // interpret_directive: Introduce unexpected distortions and asymmetry.
    // apply_insight: Warp the coordinates unpredictably using spiral and noise.

    // Shift UV center
    vec2 p = uv - 0.5;
    
    // Apply dynamic spiral distortion evolving with time and modulated by noise
    float n = noise(p * 3.0 + time);
    float angle = time * 0.5 + n * 6.2831;
    p = spiral(p, angle);
    
    // Add subtle jitter using noise
    p += 0.03 * vec2(noise(p + time), noise(p - time));

    // Return to uv space variant after distortion
    vec2 distortedUV = p + 0.5;
    
    // Create color channels with differing noise influences
    float red   = noise(distortedUV * 10.0 + vec2(1.0, time));
    float green = noise(distortedUV * 10.0 + vec2(3.0, time * 1.2));
    float blue  = noise(distortedUV * 10.0 + vec2(5.0, time * 0.8));
    
    // Mix colors in a glitchy, non-linear way
    vec3 color = vec3(red, green, blue);
    color = pow(color, vec3(1.2)) * vec3(0.8, 1.0, 1.2);
    color = smoothstep(0.2, 0.7, color);
    
    gl_FragColor = vec4(color, 1.0);
}