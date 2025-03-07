precision mediump float;
varying vec2 uv;
uniform float time;

// A pseudo-random function based on the input vector
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

// A simple noise function based on interpolation
float noise(vec2 p) {
    vec2 ip = floor(p);
    vec2 fp = fract(p);
    float a = rand(ip);
    float b = rand(ip + vec2(1.0, 0.0));
    float c = rand(ip + vec2(0.0, 1.0));
    float d = rand(ip + vec2(1.0, 1.0));
    vec2 f = fp * fp * (3.0 - 2.0 * fp);
    return mix(a, b, f.x) + (c - a)*f.y*(1.0 - f.x) + (d - b)*f.x*f.y;
}

// Fractal Brownian Motion function: medium number of octaves
float fbm(vec2 p) {
    float f = 0.0;
    float ampl = 0.5;
    for (int i = 0; i < 6; i++) {
        f += ampl * noise(p);
        p *= 2.0;
        ampl *= 0.5;
    }
    return f;
}

// Main rendering with a swirling vortex and glitch-textured organic grid
void main() {
    // Center the UV coordinates to [-1, 1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Calculate the radius and angle from center
    float r = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Create a swirling vortex distortion with medium-distance modulation
    float swirl = sin(3.0 * r - time) * 0.5;
    angle += swirl;
    
    // Map back to Cartesian coordinates with the transformed angle
    vec2 swirlPos = vec2(r * cos(angle), r * sin(angle));
    
    // Overlay an organic fractal noise pattern
    float organic = fbm(3.0 * swirlPos + time);
    
    // Generate a digital glitch texture by slicing the uv space
    vec2 glitchUV = uv;
    glitchUV.y += floor(glitchUV.x * 20.0) / 20.0;
    float glitch = step(0.95, rand(glitchUV + time));
    
    // Create a background gradient that evolves with time (cosmic feel)
    vec3 bgColor = vec3(0.1, 0.05, 0.2) + 0.3 * vec3(cos(time + r * 3.14), sin(time + r * 3.14), cos(time - r * 3.14));
    
    // Combine the organic noise and the glitch texture with a radial falloff mask
    float mask = smoothstep(0.4, 0.2, r);
    vec3 organicColor = vec3(organic * 0.7 + 0.3, organic * 0.4, 0.6 - organic * 0.5);
    
    // Merge the two aesthetics: organic swirling core with a digital glitch periphery
    vec3 color = mix(bgColor, organicColor, mask);
    color += glitch * vec3(0.2, 0.05, 0.3);
    
    gl_FragColor = vec4(color, 1.0);
}