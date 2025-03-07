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

// Swirl function for digital distortion effect
vec2 swirl(vec2 pos, float amt) {
    float angle = amt * length(pos - 0.5);
    float s = sin(angle);
    float c = cos(angle);
    vec2 centered = pos - 0.5;
    return vec2(c * centered.x - s * centered.y, s * centered.x + c * centered.y) + 0.5;
}

// Glitch distortion applied to a coordinate
vec2 glitch(vec2 p) {
    float n = noise(vec2(p.y * 10.0, time));
    return p + vec2(n * 0.05, 0.0);
}

// Organic tree branch function using polar coordinates and sine modulations
float treeBranch(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    float wave = sin(10.0 * r - a * 4.0 + t * 2.0);
    float trunk = exp(-10.0 * r);
    return smoothstep(0.2, 0.3, abs(wave) * trunk);
}

// Generate a jagged mountain silhouette with glitch distortions
float mountain(vec2 p) {
    float hill = sin(p.x * 3.1415) * 0.4 + 0.3;
    float jag = noise(p * 5.0 + time * 0.5) * 0.2;
    return hill + jag;
}

void main(void) {
    vec2 pos = uv;
    
    // Apply glitch distortion to base coordinates
    vec2 glitchPos = glitch(pos);
    
    // Apply swirling effect for digital distortion using medium association
    vec2 swirlPos = swirl(pos, 3.0 * sin(time * 0.8));
    
    // Organic tree branch patterns from both normal and glitched positions
    float branch1 = treeBranch(pos, time);
    float branch2 = treeBranch(swirlPos, time * 0.9);
    float branchPattern = mix(branch1, branch2, 0.5);
    
    // Cosmic starburst effect created from centered coordinates
    vec2 centered = (pos - 0.5) * 2.0;
    float radius = length(centered);
    float angle = atan(centered.y, centered.x);
    float burst = abs(cos(8.0 * angle + time * 2.0));
    float star = smoothstep(0.4, 0.38, radius) * burst;
    
    // Mountain silhouette using glitch modified coordinate
    float m = mountain(glitchPos);
    float mountainMask = step(pos.y, m);
    
    // Organic texture provided by layered noise
    float n = noise(pos * 5.0 + time);
    float n2 = noise(swirlPos * 10.0 - time);
    
    // Base cosmic background color transitioning from deep blue to muted dark tones
    vec3 cosmicBase = mix(vec3(0.0, 0.0, 0.2), vec3(0.05, 0.05, 0.1), pos.y);
    
    // Starburst overlay color with warm highlights
    vec3 starColor = mix(vec3(0.9, 0.7, 0.2), vec3(1.0, 0.9, 0.5), n2);
    
    // Organic tree color blending from earthy tones to vibrant green
    vec3 treeColor = mix(vec3(0.4, 0.25, 0.1), vec3(0.1, 0.8, 0.3), branchPattern);
    
    // Mountain color blending dark hues influenced by glitch effects
    vec3 mountainColor = mix(vec3(0.1, 0.1, 0.1), vec3(0.6, 0.4, 0.2), n);
    
    // Combine elements: cosmic base, mountain silhouette, starburst, and organic tree pattern
    vec3 color = mix(cosmicBase, mountainColor, mountainMask);
    color = mix(color, starColor, star);
    color = mix(color, treeColor, smoothstep(0.15, 0.35, branchPattern + n * 0.2));
    
    gl_FragColor = vec4(color, 1.0);
}