precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random hash function based on coordinates
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
}

// Basic 2D noise function using interpolation of hash values
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

// Creates a swirling effect used for glitch or organic movement
vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(c * pos.x - s * pos.y, s * pos.x + c * pos.y);
}

// Generates a glitch offset based on noise sampling; simulating digital error
vec2 glitchOffset(vec2 pos) {
    float offset = noise(vec2(floor(pos.y * 20.0), time));
    return vec2(offset * 0.05, 0.0);
}

// Organic branch pattern using polar coordinates and sinusoidal modulation
float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0; // remap UV to [-1,1]
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-6.0 * r);
    return smoothstep(0.2, 0.31, abs(wave) * trunk);
}

// Error band function to produce glitch lines
float errorBand(vec2 pos) {
    float band = sin(pos.y * 50.0 + time * 10.0);
    return smoothstep(0.02, 0.03, abs(band));
}

void main(void) {
    // Start with the base UV coordinates
    vec2 pos = uv;

    // Apply glitch offset for digital disturbance
    pos += glitchOffset(pos);
    
    // Create a swirled version for an organic, chaotic feel
    vec2 swirledPos = swirl(pos - 0.5, 3.0 * sin(time * 0.8)) + 0.5;
    
    // Compute a cosmic starburst effect using polar coordinates from the center
    vec2 centered = (uv - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float burst = abs(cos(8.0 * angle + time * 2.0));
    float star = smoothstep(0.4, 0.38, radius) * burst;
    
    // Organic tree branch patterns from both original and swirled coordinates
    float branch1 = treeBranch(uv, time);
    float branch2 = treeBranch(swirledPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Layer in noise for texture and extra organic irregularity
    float n = noise(uv * 5.0 + time);
    float n2 = noise(swirledPos * 10.0 - time);
    
    // Glitch overlay using error bands
    float bands = errorBand(uv);
    
    // Base cosmic colors influenced by radius
    vec3 baseCosmic = mix(vec3(0.1, 0.15, 0.3), vec3(0.05, 0.1, 0.25), radius);
    // Starburst colors modulated by the noise
    vec3 starColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), n2);
    // Organic branch colors transitioning between earthy and digital hues
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    
    // Combine all effects: cosmic background, starburst overlay, tree organic structure, and glitch errors
    vec3 color = baseCosmic;
    color = mix(color, starColor, star);
    color = mix(color, treeColor, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
    color = mix(color, vec3(0.8, 0.8, 0.8), bands);
    
    gl_FragColor = vec4(color, 1.0);
}