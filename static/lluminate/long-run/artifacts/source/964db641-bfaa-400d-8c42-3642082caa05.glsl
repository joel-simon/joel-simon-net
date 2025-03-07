precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 239.345);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i+vec2(0.0,0.0)), hash(i+vec2(1.0,0.0)), u.x),
               mix(hash(i+vec2(0.0,1.0)), hash(i+vec2(1.0,1.0)), u.x), u.y);
}

float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        total += noise(p) * amplitude;
        p *= 1.8;
        amplitude *= 0.5;
    }
    return total;
}

vec2 glitch(vec2 p, float seed) {
    float t = time + seed;
    float shift = (noise(p * 10.0 + t) - 0.5) * 0.08;
    return p + vec2(shift, shift);
}

float starburst(vec2 pos) {
    float angle = atan(pos.y, pos.x);
    float radius = length(pos);
    float wave = sin(angle * 8.0 + time * 4.0) * 0.1;
    float pattern = smoothstep(0.0, 0.02, abs(radius - wave));
    return pattern;
}

float organicPulse(vec2 pos) {
    float r = length(pos);
    float pulse = sin(r * 12.0 - time * 3.0);
    return smoothstep(0.3, 0.31, abs(pulse));
}

void main() {
    // Inspired by the directive: "Honor thy error as a hidden intention"
    vec2 st = uv * 2.0 - 1.0;
    st *= 1.2;
    
    // Apply a glitch distortion based on time and position
    vec2 distorted = glitch(st, 3.14);
    
    // Create a cosmic background with swirling fractal noise and starburst
    float f = fbm(distorted * 2.0);
    float burst = starburst(distorted);
    vec3 bg = mix(vec3(0.1, 0.05, 0.2), vec3(0.0, 0.2, 0.4), f + burst);
    
    // Add an organic, pulsating element to the scene
    float pulse = organicPulse(st);
    vec3 organic = mix(vec3(0.8, 0.3, 0.2), vec3(0.2, 0.6, 0.4), pulse);
    
    // Mix both layers with subtle time modulation
    vec3 color = mix(bg, organic, 0.5 + 0.5*sin(time*0.7));
    
    // Final glitch overlay via noise stripes
    float stripe = step(0.45, fract(uv.y*20.0 + time));
    color = mix(color, vec3(0.0), stripe * 0.15);
    
    gl_FragColor = vec4(color, 1.0);
}