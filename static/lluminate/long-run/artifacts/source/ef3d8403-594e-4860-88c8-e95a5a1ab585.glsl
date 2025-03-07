precision mediump float;
varying vec2 uv;
uniform float time;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

vec2 rotate(vec2 p, float a) {
    float s = sin(a);
    float c = cos(a);
    return vec2(c * p.x - s * p.y, s * p.x + c * p.y);
}

float swirlField(vec2 p, float t) {
    p -= 0.5;
    float angle = length(p) * 10.0 - t;
    vec2 offset = vec2(sin(angle), cos(angle));
    float d = length(p + offset * 0.05);
    return smoothstep(0.3, 0.0, d);
}

float glitchStripes(vec2 p, float t) {
    float glitches = random(floor(p * 20.0) + t);
    return step(0.95, glitches);
}

float honorError(vec2 p, float t) {
    // "Honor thy error as a hidden intention"
    // Introduce random offset errors that create unexpected arcs
    vec2 err = vec2(sin(p.y * 15.0 + t), cos(p.x * 15.0 - t)) * 0.02;
    float val = sin((p.x+err.x)*20.0 + sin((p.y+err.y)*20.0)*3.0);
    return smoothstep(0.45, 0.55, val);
}

vec3 cosmicLayer(vec2 p, float t) {
    // Base cosmic gradient
    vec2 center = vec2(0.5);
    float dist = length(p - center);
    vec3 base = mix(vec3(0.05, 0.1, 0.15), vec3(0.8, 0.85, 1.0), smoothstep(0.0, 0.7, dist));
    // Add unexpected color twist from error
    float errVal = honorError(p, t);
    vec3 twist = vec3(0.9, 0.4, 0.6);
    return mix(base, twist, errVal * 0.5);
}

void main() {
    vec2 pos = uv;
    
    // Apply a subtle rotation over time to influence the whole field
    pos = rotate(pos - 0.5, time * 0.1) + 0.5;
    
    // Create a cosmic background with swirling dynamics
    vec3 background = cosmicLayer(pos, time);
    
    // Generate swirling organic layers inspired by a tree of error
    float swirl = swirlField(pos, time);
    vec3 organic = mix(vec3(0.1, 0.7, 0.4), vec3(0.3, 0.2, 0.1), swirl);
    
    // Mix the playful glitch effect
    float glitch = glitchStripes(pos, time);
    
    // Combine layers in an unexpected way: honor error leads the design.
    vec3 combined = mix(background, organic, swirl);
    combined = mix(combined, vec3(1.0), glitch * 0.7);
    
    gl_FragColor = vec4(combined, 1.0);
}