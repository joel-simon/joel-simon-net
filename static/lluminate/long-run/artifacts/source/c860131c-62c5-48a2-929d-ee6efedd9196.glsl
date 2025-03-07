precision mediump float;
varying vec2 uv;
uniform float time;

// Hash for noise
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// Basic noise function
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Fractal Brownian Motion
float fbm(vec2 p) {
    float f = 0.0;
    float amp = 0.5;
    for(int i = 0; i < 5; i++){
        f += amp * noise(p);
        p *= 2.0;
        amp *= 0.5;
    }
    return f;
}

// Glitch offset function
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898,78.233))) * 43758.5453123 + t) * amt;
    pos.x += shift;
    return pos;
}

// Digital glitch function: stripes and distortions
float glitchPattern(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, abs(sin(pos.y * 20.0 + t * 5.0)));
    float n = noise(pos * 10.0 + t);
    float glitchMix = smoothstep(0.3, 0.7, n);
    return mix(stripes, glitchMix, 0.4);
}

// Organic shape: brain-like with subtle noise wrinkles
float organicShape(vec2 pos) {
    pos.x *= 1.2;
    float base = smoothstep(0.45, 0.44, dot(pos, pos));
    float wrinkles = fbm(pos * 8.0 + time * 0.5);
    wrinkles = smoothstep(0.4, 0.6, wrinkles);
    return mix(base, wrinkles, 0.3);
}

// Implicit heart shape function for emotional symbol
float heartShape(vec2 pos) {
    pos.x *= 1.2;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0) * (x*x + y*y - 1.0) * (x*x + y*y - 1.0) - x*x*y*y*y;
}

// Organic layer simulating natural growth
vec3 organicLayer(vec2 pos, float t) {
    float n = fbm(pos * 3.0 + t * 0.5);
    float growth = smoothstep(0.4, 0.6, n);
    vec3 col1 = vec3(0.1, 0.6, 0.3);
    vec3 col2 = vec3(0.8, 0.9, 0.4);
    return mix(col1, col2, growth);
}

// Digital layer simulating synthetic, glitch effects
vec3 digitalLayer(vec2 pos, float t) {
    vec2 gp = glitchOffset(pos, t);
    float stripe = step(0.5, abs(sin(gp.y * 30.0 + t * 3.0)));
    float d = noise(gp * 10.0 + t);
    float mixVal = smoothstep(0.3, 0.7, d);
    vec3 colA = vec3(0.9, 0.2, 0.3);
    vec3 colB = vec3(0.2, 0.3, 0.9);
    return mix(colA, colB, mixVal) * stripe;
}

// Synthesize organic and digital domains with time modulation.
vec3 layeredSynthesis(vec2 pos, float t) {
    vec3 organic = organicLayer(pos, t);
    vec3 digital = digitalLayer(pos, t);
    float blend = 0.5 + 0.5 * sin(t + pos.x * 3.0);
    return mix(organic, digital, blend);
}

void main() {
    // Map uv coordinates from [0,1] to [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Create a swirling background using polar transformation
    float radius = length(st);
    float angle = atan(st.y, st.x);
    float swirl = sin(radius * 10.0 - time * 2.0 + angle * 3.0);
    float pattern = smoothstep(0.35, 0.36, radius + 0.1 * swirl);
    vec3 bgColor = mix(vec3(0.05, 0.05, 0.15), vec3(0.1,0.05,0.1), fbm(st * 4.0 + time));
    
    // Organic details layer with brain-like structure
    float bShape = organicShape(st);
    vec3 organicColor = vec3(0.8, 0.5, 0.6) * (1.0 - bShape);
    
    // Emotional heart layer
    float heart = heartShape(st * 1.8);
    float heartMask = smoothstep(0.0, 0.02, -heart);
    
    // Glitch effects based on digital synthesis
    vec2 glitchUV = uv;
    float angleRot = time * 0.4;
    float s = sin(angleRot);
    float c = cos(angleRot);
    mat2 rotation = mat2(c, -s, s, c);
    glitchUV = rotation * (glitchUV - 0.5) + 0.5;
    float glitchEff = glitchPattern(glitchUV, time);
    
    // Blend organic and digital elements dynamically
    vec3 synthColor = layeredSynthesis(st, time);
    vec3 combinedColor = mix(synthColor, digitalLayer(glitchUV, time), glitchEff);
    
    // Merge background with central organic detail and emotional heart element
    vec3 finalColor = mix(bgColor, organicColor, smoothstep(0.45, 0.4, dot(st, st)));
    finalColor = mix(finalColor, combinedColor, glitchEff);
    finalColor = mix(finalColor, organicColor, heartMask);
    
    // Darken edges for depth
    finalColor *= smoothstep(1.0, 0.7, radius);
    
    gl_FragColor = vec4(finalColor, 1.0);
}