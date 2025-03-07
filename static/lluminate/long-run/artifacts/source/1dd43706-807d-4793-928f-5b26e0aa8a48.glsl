precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for noise.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1,311.7))) * 43758.5453123);
}

// Classic 2D noise.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0,0.0)), hash(i + vec2(1.0,0.0)), u.x),
               mix(hash(i + vec2(0.0,1.0)), hash(i + vec2(1.0,1.0)), u.x), u.y);
}

// Fractal Brownian Motion function.
float fbm(vec2 p) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 6; i++) {
        value += amplitude * noise(p);
        p *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

// Polar coordinate transformation.
vec2 polarTransform(vec2 pos, float angle) {
    float c = cos(angle);
    float s = sin(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

// Glitch effect that displaces x coordinates.
vec2 glitch(vec2 pos, float t) {
    float shift = sin(pos.y * 50.0 + t) * 0.005 + noise(pos * 20.0 + t) * 0.01;
    pos.x += shift;
    return pos;
}

// Organic texture pattern blending noise and radial decay.
vec3 organicPattern(vec2 pos) {
    float n = fbm(pos * 3.0 + time * 0.3);
    float r = length(pos);
    float cell = smoothstep(0.45, 0.4, abs(n - r));
    vec3 col = mix(vec3(0.15, 0.5, 0.35), vec3(0.9, 0.8, 0.3), n);
    return col * cell;
}

// Digital glitch pattern using stripes and noise.
vec3 digitalPattern(vec2 pos) {
    vec2 grid = fract(pos * 30.0 + time);
    float line = smoothstep(0.0, 0.02, abs(grid.y - 0.5));
    float glitchBurst = step(0.95, hash(pos * 1.3 + vec2(time)));
    vec3 col = mix(vec3(0.05, 0.05, 0.25), vec3(0.6, 0.9, 1.0), line);
    return col + glitchBurst * 0.3;
}

void main(){
    // Center uv
    vec2 pos = uv - 0.5;
    
    // Apply polar rotation based on fbm noise to evoke organic growth.
    float angle = fbm(pos * 3.0 + time) * 6.2831 * 0.2;
    vec2 rotatedPos = polarTransform(pos, angle);
    
    // Apply glitch offset to add digital fragmentation.
    vec2 glitchedPos = glitch(rotatedPos + 0.5, time);

    // Generate organic texture.
    vec3 organic = organicPattern(pos);
    
    // Generate digital elements.
    vec3 digital = digitalPattern(glitchedPos);
    
    // Blend the digital and organic elements using radial distance as mask.
    float mixFactor = smoothstep(0.6, 0.2, length(pos));
    vec3 colorMix = mix(organic, digital, mixFactor);
    
    // Introduce subtle bursts to enhance transformation effects.
    float burst = step(0.98, hash(glitchedPos * (time * 2.0))) * 0.25;
    vec3 finalColor = colorMix + burst;
    
    gl_FragColor = vec4(finalColor, 1.0);
}