precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

// 2D noise function using smooth interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Fractal Brownian Motion for organic texture
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 4; i++){
        total += noise(p) * amplitude;
        p *= 2.0;
        amplitude *= 0.5;
    }
    return total;
}

// Simulates tree branch growth using modulated sinusoidal decay
float treeBranch(vec2 p, float t) {
    float angle = atan(p.y, p.x);
    float radius = length(p);
    // The branch "grows" outwards with time; using time as seasonal growth factor.
    float growth = smoothstep(0.0, 0.5, radius - 0.2 * sin(t + angle * 3.0));
    // Introduce slight fractal variation to mimic organic imperfections.
    float organic = fbm(p * 3.0 + t);
    return growth * organic;
}

// Glitch-inspired distortion repurposed for organic context
vec2 organicDistort(vec2 p) {
    float offset = noise(p * 10.0 + time);
    return p + vec2(offset * 0.03, offset * 0.03);
}

void main(void) {
    // Center and scale UV coordinates, representing the canvas.
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Apply organic distortion mimicking nature's irregularity.
    pos = organicDistort(pos);
    
    // Convert to polar coordinates for swirling seasonal growth.
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    
    // Identify trait: resilience/growth.
    // Symbol typically associated: a rigid "pixel error" which we now replace with a dynamic tree branch.
    float branch = treeBranch(pos, time);
    
    // Use polar modulation to create dynamic growth rings.
    float rings = smoothstep(0.2, 0.22, abs(sin(10.0 * radius - time * 3.0)));
    
    // Combine branch growth and ringing decay to simulate a natural, evolving pattern.
    float pattern = mix(branch, rings, 0.5);
    
    // Organic color gradient: earthy greens and subtle browns evolving over time.
    vec3 baseColor = mix(vec3(0.1, 0.3, 0.1), vec3(0.3, 0.2, 0.1), pattern);
    vec3 highlight = vec3(0.05, 0.15, 0.05) + 0.2 * vec3(sin(time), cos(time), sin(time * 0.5));
    
    vec3 color = baseColor + highlight * smoothstep(0.0, 1.0, pattern);
    
    gl_FragColor = vec4(color, 1.0);
}