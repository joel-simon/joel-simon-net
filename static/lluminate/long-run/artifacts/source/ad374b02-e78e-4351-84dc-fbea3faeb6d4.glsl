precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on uv coordinates.
float random(vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

// Glitch distortion function using a sine offset in polar space.
vec2 glitchPolar(vec2 pos, float t) {
    float angle = random(pos * t) * 6.28318;
    float offset = sin(t * 3.0 + pos.y * 10.0) * 0.03;
    pos.x += cos(angle) * offset;
    pos.y += sin(angle) * offset;
    return pos;
}

// Convert Cartesian coordinates to polar coordinates.
vec2 toPolar(vec2 pos) {
    float r = length(pos);
    float a = atan(pos.y, pos.x);
    return vec2(r, a);
}

// Convert polar coordinates back to Cartesian.
vec2 toCartesian(vec2 polar){
    return vec2(polar.x * cos(polar.y), polar.x * sin(polar.y));
}

// A swirling organic pattern with digital twist.
float swirlingPattern(vec2 pos, float t) {
    pos = glitchPolar(pos, t);
    vec2 polar = toPolar(pos - vec2(0.5, 0.5));
    float waves = sin(10.0 * polar.x - t * 2.0 + polar.y * 4.0);
    float radial = smoothstep(0.2, 0.5, polar.x);
    return mix(waves, radial, 0.5);
}

// Organic starburst effect using polar coordinates.
float starburst(vec2 pos, float t) {
    vec2 centered = pos - vec2(0.5, 0.5);
    vec2 polar = toPolar(centered);
    float stars = smoothstep(0.48, 0.5, abs(sin(polar.y * 10.0 - t * 4.0)));
    return stars * (1.0 - polar.x);
}

void main(){
    vec2 pos = uv;
    
    // Apply a slow rotation for subtle dynamics.
    float angle = time * 0.2;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * (pos - 0.5) + 0.5;
    
    // Generate swirling texture.
    float swirl = swirlingPattern(pos, time);
    
    // Generate starburst texture.
    float star = starburst(pos, time);
    
    // Mix two effects: swirling organic textures with cosmic starburst.
    float mixFactor = smoothstep(0.2, 0.8, pos.y);
    float pattern = mix(swirl, star, mixFactor);
    
    // Create color palette transformation.
    vec3 cosmic = vec3(0.2, 0.0, 0.4) + vec3(0.3, 0.2, 0.5) * sin(time + pos.xyx * 10.0);
    vec3 organic = vec3(0.0, 0.6, 0.3) + vec3(0.5, 0.5, 0.2) * cos(time + pos.yxy * 8.0);
    
    // Blend colors based on the generated pattern.
    vec3 color = mix(cosmic, organic, pattern);
    
    // Final modulation and output.
    gl_FragColor = vec4(color, 1.0);
}