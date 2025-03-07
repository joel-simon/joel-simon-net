precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo-randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(17.0, 43.0))) * 12345.6789);
}

// 2D noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

// Glitch distortion applied to a coordinate
vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 10.0, time));
    return p + vec2(n * 0.05, 0.0);
}

// Generate a jagged mountain silhouette with glitch distortions
float mountain(vec2 p) {
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

// Simulate a tree branch structure using polar coordinates and sine dampening
float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float angle = sin(t * 0.5) * 0.5;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    float branch = smoothstep(0.2, 0.3, abs(wave) * trunk);
    return branch;
}

void main(void) {
    vec2 p = uv;
    
    // Apply glitch distortion
    vec2 gp = glitch(p);
    
    // Compute mountain and tree branch patterns
    float m = mountain(gp);
    float branch = treeBranch(p, time);
    
    // Create a binary mask for mountain silhouette below the mountain curve
    float mountainMask = step(p.y, m);
    
    // Define glitch stripe effect based on sine waves
    float stripes = abs(sin((p.y + time * 2.0) * 50.0));
    float glitchEffect = smoothstep(0.4, 0.45, stripes);
    
    // Define colors for mountain and tree
    vec3 mountainColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.6, 0.4, 0.2), glitchEffect);
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branch);
    
    // Define a sky gradient color
    vec3 skyColor = mix(vec3(0.0, 0.0, 0.2), vec3(0.05, 0.05, 0.1), p.y);
    
    // Combine elements: where mountain exists, use mountainColor, else sky, then overlay tree branch structure
    vec3 color = mix(skyColor, mountainColor, mountainMask);
    color = mix(color, treeColor, smoothstep(0.25, 0.35, branch));
    
    gl_FragColor = vec4(color, 1.0);
}