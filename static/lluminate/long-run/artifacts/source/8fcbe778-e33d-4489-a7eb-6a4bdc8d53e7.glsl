precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Function to simulate organic tree branch growth.
float treeBranch(vec2 pos, float seed) {
    pos.y += time * 0.3;
    float branch = smoothstep(0.02, 0.0, abs(pos.x + sin(pos.y * 3.0 + seed) * 0.1));
    return branch;
}

// Implicit heart shape function (symbolizing emotion).
float heartShape(vec2 pos) {
    pos.x *= 1.2;
    float x = pos.x;
    float y = pos.y;
    float a = x*x + y*y - 1.0;
    return a * a * a - x*x*y*y*y;
}

// Glitch offset function.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453123 + t)*amt;
    pos.x += shift;
    return pos;
}

// Striped glitch effect.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t*5.0));
    float n = noise(pos * t);
    float noiseStrip = smoothstep(0.3, 0.7, n);
    return mix(stripes, noiseStrip, 0.3);
}

// Create fractal noise.
float fbm(vec2 p) {
    float total = 0.0;
    float amplitude = 0.5;
    for(int i = 0; i < 5; i++){
        total += noise(p) * amplitude;
        p *= 1.7;
        amplitude *= 0.5;
    }
    return total;
}

void main() {
    // Center uv coordinates from [0,1] to [-1,1]
    vec2 st = uv * 2.0 - 1.0;

    // Organic tree branch growth pattern.
    float tree = treeBranch(st, 1.0);
    vec3 treeColor = vec3(0.1, 0.6, 0.2) * tree;
    
    // Create a dynamic background with swirling nebula like color tones.
    float rad = length(st);
    float angle = atan(st.y, st.x);
    float swirl = sin(6.0 * rad - time*1.2 + angle);
    float dynamicNoise = noise(st * 4.0 + time);
    float bgPattern = mix(swirl, dynamicNoise, 0.5);
    vec3 bgColor = mix(vec3(0.05,0.05,0.15), vec3(0.2,0.1,0.25), bgPattern);
    
    // Implicit heart shape to represent emotion layered over the scene.
    float heart = heartShape(st * 1.5);
    float heartMask = smoothstep(0.0, 0.02, -heart);
    vec3 heartColor = vec3(0.8, 0.2, 0.3) * heartMask;
    
    // Apply glitched effects over the whole image.
    vec2 glitchUV = uv;
    float angleRot = time * 0.4;
    float s = sin(angleRot);
    float c = cos(angleRot);
    mat2 rotation = mat2(c, -s, s, c);
    glitchUV = rotation * (glitchUV - 0.5) + 0.5;
    float glitchPattern = stripedGlitch(glitchUV, time) + fbm(glitchUV * 3.0);
    
    // Composite colors: mix background with organic tree and heart emotion.
    vec3 combined = mix(bgColor, treeColor, 0.5 + 0.5 * sin(time));
    combined = mix(combined, heartColor, heartMask);
    combined = mix(combined, vec3(0.0, 0.0, 0.0), glitchPattern * 0.3);
    
    gl_FragColor = vec4(combined, 1.0);
}