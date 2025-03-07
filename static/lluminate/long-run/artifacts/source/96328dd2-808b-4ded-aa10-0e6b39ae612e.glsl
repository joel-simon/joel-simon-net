precision mediump float;
varying vec2 uv;
uniform float time;

// A simple hash function for pseudo randomness
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// 2D noise based on hash and interpolation
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    // Four corners
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));

    // Smooth interpolation using smoothstep
    vec2 u = smoothstep(0.0, 1.0, f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Apply a swirl effect based on center offset and noise modulation
vec2 swirl(vec2 pos, float strength) {
    float radius = length(pos);
    float angle = strength * exp(-radius * 2.0) * sin(radius * 10.0 - time * 3.0);
    float s = sin(angle);
    float c = cos(angle);
    return vec2(pos.x * c - pos.y * s, pos.x * s + pos.y * c);
}

// Create a soft radial gradient backdrop
vec3 radialGradient(vec2 pos) {
    float r = length(pos);
    return mix(vec3(0.1, 0.0, 0.2), vec3(0.8, 0.3, 0.9), smoothstep(0.0, 0.7, r));
}

// Generate a star-like sparkle field using noise over polar coordinates
vec3 starField(vec2 pos) {
    float star = noise(pos * 20.0 + time);
    star = smoothstep(0.98, 1.0, star);
    return vec3(star);
}

void main(){
    // Step 1: Center coordinates around (0,0)
    vec2 centered = uv - 0.5;
    
    // Step 2: Apply a dynamic swirl effect with medium association
    vec2 swirled = swirl(centered, 4.0);
    
    // Step 3: Create radial gradient background
    vec3 bgColor = radialGradient(swirled);
    
    // Step 4: Introduce organic undulations with noise modulation
    float n = noise(swirled * 3.0 + time * 0.5);
    vec3 organic = vec3(0.3 + 0.7 * sin(n * 6.2831 + time),
                        0.2 + 0.8 * cos(n * 6.2831 - time),
                        0.5 + 0.5 * sin(n * 3.1415 - time * 0.5));
    
    // Step 5: Mix the background and organic color considering distance from center
    float mixFactor = smoothstep(0.2, 0.5, length(swirled));
    vec3 color = mix(organic, bgColor, mixFactor);
    
    // Step 6: Overlay subtle star-field sparkles for digital texture
    vec3 stars = starField(swirled);
    color += stars * 0.8;
    
    gl_FragColor = vec4(color, 1.0);
}