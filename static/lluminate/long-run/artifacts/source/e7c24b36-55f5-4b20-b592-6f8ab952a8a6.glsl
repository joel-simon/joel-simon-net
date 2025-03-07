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
    return mix(mix(hash(i + vec2(0.0, 0.0)),
                   hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)),
                   hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

// Implicit heart shape function.
float heartShape(vec2 pos) {
    pos.x *= 1.2;
    float x = pos.x;
    float y = pos.y;
    return (x*x + y*y - 1.0) * (x*x + y*y - 1.0) * (x*x + y*y - 1.0) - x*x*y*y*y;
}

// Function for a brain-like shape with noise wrinkles.
float brainShape(vec2 st) {
    st.x *= 1.3;
    float ellipse = smoothstep(0.45, 0.44, dot(st, st));
    float wrinkles = noise(st * 8.0 + time * 0.5);
    wrinkles = smoothstep(0.4, 0.6, wrinkles);
    return mix(ellipse, wrinkles, 0.3);
}

// Glitch offset function.
vec2 glitchOffset(vec2 pos, float t) {
    float amt = 0.05;
    float shift = fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453123 + t) * amt;
    pos.x += shift;
    return pos;
}

// Striped glitch effect.
float stripedGlitch(vec2 pos, float t) {
    pos = glitchOffset(pos, t);
    float stripes = step(0.5, sin(pos.y * 20.0 + t * 5.0));
    float n = noise(pos * t);
    float noiseStrip = smoothstep(0.3, 0.7, n);
    return mix(stripes, noiseStrip, 0.3);
}

// Distorted circular glitch.
float distortedCircle(vec2 pos, float t) {
    pos = pos * 2.0 - 1.0;
    float radius = length(pos);
    float angle = atan(pos.y, pos.x);
    float glitch = smoothstep(0.0, 1.0, noise(vec2(angle, t)));
    return smoothstep(0.4 + glitch * 0.1, 0.41 + glitch * 0.1, radius);
}

// Color modulation combining glitch patterns.
vec3 colorModulation(vec2 pos, float t) {
    float base = sin(t + pos.x * 10.0) * 0.5 + 0.5;
    float stripes = stripedGlitch(pos, t);
    float circle = distortedCircle(pos, t);
    vec3 colorA = vec3(0.1, 0.8, 0.7);
    vec3 colorB = vec3(0.9, 0.2, 0.3);
    vec3 color = mix(colorA, colorB, stripes);
    color = mix(color, vec3(0.0), circle);
    color.r += (noise(pos + t) - 0.5) * 0.1;
    color.g += (noise(pos - t) - 0.5) * 0.1;
    color.b += (noise(pos * 1.5) - 0.5) * 0.1;
    return color;
}

void main() {
    // Center uv coordinates from [0,1] to [-1,1]
    vec2 st = uv * 2.0 - 1.0;
    
    // Create a dynamic swirling background.
    float rad = length(st);
    float angle = atan(st.y, st.x);
    float swirl = sin(6.0 * rad - time * 1.8 + angle);
    float dynamicNoise = noise(st * 4.0 + time);
    float backgroundPattern = mix(swirl, dynamicNoise, 0.5);
    vec3 bgColor = mix(vec3(0.05, 0.05, 0.15), vec3(0.1, 0.05, 0.1), backgroundPattern);
    
    // Generate an organic brain texture.
    vec2 brainCoord = st;
    brainCoord.y *= 1.2;
    float bShape = brainShape(brainCoord);
    vec3 brainColor = vec3(0.8, 0.5, 0.6) * (1.0 - bShape);
    
    // Generate an implicit heart shape (now reinterpreted as symbolic of emotion).
    float heart = heartShape(st * 1.8);
    float heartMask = smoothstep(0.0, 0.02, -heart);
    
    // Apply global fractal noise for added organic detail.
    float n = 0.0;
    vec2 pos = st * 3.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        n += amplitude * noise(pos);
        pos *= 1.7;
        amplitude *= 0.5;
    }
    vec3 organicColor = vec3(0.2 + 0.8 * sin(n + time),
                               0.2 + 0.8 * cos(n - time),
                               0.5 + 0.5 * sin(n * 3.0 + time));
    
    // Apply glitch effects.
    vec2 glitchUV = uv;
    float angleRot = time * 0.4;
    float s = sin(angleRot);
    float c = cos(angleRot);
    mat2 rotation = mat2(c, -s, s, c);
    glitchUV = rotation * (glitchUV - 0.5) + 0.5;
    float glitchPattern = stripedGlitch(glitchUV, time) + distortedCircle(glitchUV, time);
    
    // Combine organic and glitch aesthetics.
    vec3 combinedColor = mix(organicColor, colorModulation(glitchUV, time), 0.5 + 0.5 * sin(time));
    
    // Merge central brain (intellect) with heart/emotion symbol and glitch
    vec3 finalColor = mix(bgColor, brainColor, smoothstep(0.45, 0.4, dot(brainCoord, brainCoord)));
    finalColor = mix(finalColor, combinedColor, glitchPattern);
    finalColor = mix(finalColor, brainColor, heartMask);
    
    gl_FragColor = vec4(finalColor, 1.0);
}