precision mediump float;
varying vec2 uv;
uniform float time;

// Hash function for pseudo randomness.
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

// Simple noise function.
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// Polar coordinate transformation.
vec2 toPolar(vec2 p) {
    float r = length(p);
    float theta = atan(p.y, p.x);
    return vec2(r, theta);
}

// Function to simulate digital circuits growing like organic branches.
// Here, trait "resilience" is represented by an oak tree (symbol) being replaced with a digital circuit (subject)
// in a high-voltage context where resilience is essential for conduction.
float digitalBranch(vec2 p) {
    // Convert to polar coordinates and modulate the angle.
    vec2 polar = toPolar(p);
    float r = polar.x;
    float theta = polar.y;
    
    // Create branch structures by overlaying sinusoidal oscillations.
    float branch = 0.0;
    branch += sin(10.0 * theta + time * 2.0) * 0.5;
    branch += sin(5.0 * theta - time) * 0.3;
    
    // Emphasize branch structures along a "circuit trace" by a smooth step.
    float trace = smoothstep(0.45, 0.5, abs(fract(r * 4.0 + branch * 0.2) - 0.5));
    return trace;
}

// Background noise simulating high voltage sparks.
float sparkNoise(vec2 p) {
    float n = noise(p * 3.0 + time);
    return smoothstep(0.7, 1.0, n);
}

void main(void) {
    // Center coordinates.
    vec2 p = (uv - 0.5) * 2.0;
    
    // Rotate slowly.
    float angle = time * 0.4;
    mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));
    p = rot * p;
    
    // Digital branch effect.
    float branchTrace = digitalBranch(p);
    
    // High voltage spark effect at the edges.
    float sparks = sparkNoise(p + vec2(sin(time), cos(time)) * 0.3);
    float edgeMask = smoothstep(0.3, 1.0, length(p));
    
    // Compose final digital circuit scene.
    vec3 branchColor = vec3(0.0, 0.8, 1.0) * branchTrace;
    vec3 sparkColor = vec3(1.0, 0.9, 0.3) * sparks * edgeMask;
    vec3 baseColor = vec3(0.05, 0.05, 0.1);
    
    vec3 color = baseColor + branchColor + sparkColor;
    
    gl_FragColor = vec4(color, 1.0);
}