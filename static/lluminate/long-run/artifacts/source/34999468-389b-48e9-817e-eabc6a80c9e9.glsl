precision mediump float;
varying vec2 uv;
uniform float time;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b)* u.x * u.y;
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0, amp = 0.5;
    for(int i = 0; i < 5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Digital glitch effect by offsetting UVs
vec2 glitchOffset(vec2 p, float t) {
    float offset = sin(p.y * 10.0 + t * 5.0) * 0.03;
    p.x += offset;
    return p;
}

// Organic tree branch function: simulate organic growth pattern
float treeBranch(vec2 p, float t) {
    p = glitchOffset(p, t);
    float branch = smoothstep(0.02, 0.0, abs(p.x)) * smoothstep(0.3, 0.0, length(p - vec2(0.0, t*0.3)));
    return branch;
}

void main(void) {
    // Map uv from [0,1] to [-1,1]
    vec2 pos = (uv - 0.5) * 2.0;
    
    // Create swirling vortex effect using polar coordinates
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float swirl = sin(angle * 3.0 + time * 2.0);
    float vortex = smoothstep(0.7, 0.4, radius + swirl * 0.2);
    
    // Add organic FBM noise texture for cosmic dust and organic feel
    float noiseVal = fbm(pos * 3.0 + time * 0.5);
    float organic = smoothstep(0.4, 0.5, noiseVal);
    
    // Simulate a tree branch silhouette at the center using time modulation
    float branchShape = treeBranch(pos, sin(time) * 0.5 + 0.5);
    
    // Combine the vortex and branch effects to blend digital glitch with organic growth
    float composite = mix(vortex, branchShape, 0.5);
    composite = mix(composite, organic, 0.4);
    
    // Dynamic color scheme: blend warm and cool hues over time
    vec3 warm = vec3(0.9, 0.6, 0.2);
    vec3 cool = vec3(0.2, 0.4, 0.8);
    vec3 glitchColor = mix(warm, cool, noise(pos * 5.0 + time));
    
    // Final color modulation based on composite effects and radial gradient for depth
    vec3 color = mix(glitchColor, vec3(1.0, 1.0, 1.0), composite);
    color *= smoothstep(1.0, 0.2, radius);
    
    gl_FragColor = vec4(color, 1.0);
}