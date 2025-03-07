precision mediump float;
varying vec2 uv;
uniform float time;

// Pseudo-random function based on UV coordinates.
float random(vec2 st) {
    return fract(sin(dot(st, vec2(17.0, 43.0))) * 43758.5453123);
}

// Noise function using smooth interpolation.
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) +
           (c - a)* u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

// Apply a ripple distortion inspired by "Honor thy error as a hidden intention"
vec2 ripple(vec2 pos, float t) {
    vec2 centered = pos - 0.5;
    float dist = length(centered);
    float angle = atan(centered.y, centered.x);
    // Introduce an error term that intentionally distorts the radial distance.
    float error = noise(vec2(angle * 3.0, t * 0.5));
    float rippleEffect = sin(dist * 20.0 - t * 4.0 + error * 6.2831);
    float distortion = 0.02 * rippleEffect;
    // Offset position slightly using the error based distortion.
    pos += distortion * vec2(cos(angle), sin(angle));
    return pos;
}

// Generate a dynamic grid pattern with glitch-like offsets.
float grid(vec2 pos, float t) {
    // Create a base grid.
    vec2 gridUV = fract(pos * 10.0);
    float line = step(0.05, gridUV.x) * step(0.05, gridUV.y);
    // Apply a random jitter to the grid lines.
    float jitter = noise(pos * 5.0 + t);
    return mix(line, 1.0 - line, smoothstep(0.3, 0.7, jitter));
}

// Dynamic color modulation using time and unexpected glitches.
vec3 dynamicColor(vec2 pos, float t) {
    // Use polar coordinates for a radial gradient.
    vec2 centered = pos - 0.5;
    float radius = length(centered);
    // Base colors shift over time.
    vec3 colorA = vec3(0.2 + 0.3 * sin(t), 0.4, 0.6 + 0.4 * cos(t));
    vec3 colorB = vec3(0.8, 0.3 + 0.3 * sin(t * 1.3), 0.2 + 0.2 * cos(t));
    // Mix based on radius.
    vec3 col = mix(colorA, colorB, smoothstep(0.2, 0.5, radius));
    // Inject glitch errors into each channel.
    col.r += (random(pos + t) - 0.5) * 0.2;
    col.g += (random(pos * 1.3 - t) - 0.5) * 0.2;
    col.b += (random(vec2(pos.y, pos.x) + t*0.5) - 0.5) * 0.2;
    return col;
}

void main() {
    // Interpret the directive "Honor thy error as a hidden intention" to embrace distortions.
    vec2 pos = uv;
    pos = ripple(pos, time);

    // Apply a subtle rotating matrix to further disrupt predictability.
    float angle = 0.1 * sin(time * 0.7);
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    pos = rot * pos;
    
    // Combine grid pattern with the distorted ripple.
    float pattern = grid(pos, time);
    
    // Create a dynamic color based on the transformed coordinates.
    vec3 color = dynamicColor(pos, time);
    
    // Use the grid pattern to modulate brightness: highlighting errors as creative intent.
    color *= mix(0.7, 1.3, pattern);
    
    gl_FragColor = vec4(color, 1.0);
}