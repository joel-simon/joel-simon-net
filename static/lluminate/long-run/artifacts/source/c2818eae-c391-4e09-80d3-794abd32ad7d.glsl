precision mediump float;
varying vec2 uv;
uniform float time;

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);
    
    float res = mix(mix(rand(ip), rand(ip+vec2(1.0,0.0)), u.x),
                    mix(rand(ip+vec2(0.0,1.0)), rand(ip+vec2(1.0,1.0)), u.x), u.y);
    return res;
}

// Apply an intentional "error" glitch displacement based on directive: "Honor thy error as a hidden intention"
vec2 glitch(vec2 p) {
    float shift = (noise(p * 10.0 + time) - 0.5) * 0.1;
    p.x += shift;
    p.y += shift * 0.5;
    return p;
}

// Create a swirling, organic pattern defined by erroneous perturbation
float swirl(vec2 p) {
    p = p * 2.0 - 1.0;
    float r = length(p);
    float a = atan(p.y, p.x) + time * 0.5;
    float s = sin(10.0 * r - time + a);
    return smoothstep(0.4, 0.45, abs(s));
}

// Organic gradient from error-driven intention versus digital fragmentation
vec3 palette(float t) {
    // Using error as intention to invert colors periodically
    vec3 col = mix(vec3(0.2, 0.7, 0.9), vec3(0.9, 0.2, 0.5), t);
    if(mod(floor(time), 2.0) > 0.5) {
        col = vec3(1.0) - col;
    }
    return col;
}

void main(){
    vec2 uvGlitch = glitch(uv);
    float pattern = swirl(uvGlitch);
    
    // Incorporate a shifting digital grid using noise influenced by time
    float grid = smoothstep(0.45, 0.5, abs(sin(uv.x * 50.0 + time)) * abs(sin(uv.y * 50.0 + time)));
    
    // Blend organic and digital fragments
    float blend = mix(pattern, grid, 0.5);
    
    vec3 color = palette(blend);
    
    gl_FragColor = vec4(color, 1.0);
}