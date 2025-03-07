precision mediump float;
varying vec2 uv;
uniform float time;

float random (in vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233))) * 43758.5453123);
}

float noise (in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
           (c - a) * u.y * (1.0 - u.x) +
           (d - b) * u.x * u.y;
}

float fbm(in vec2 st) {
    float value = 0.0;
    float amplitude = 0.5;
    for (int i = 0; i < 5; i++) {
        value += amplitude * noise(st);
        st *= 2.0;
        amplitude *= 0.5;
    }
    return value;
}

vec2 glitch(in vec2 p) {
    float n = fbm(p * 10.0 + time * 0.5);
    p.x += smoothstep(0.3, 0.7, n) * 0.04 * sin(time * 10.0);
    p.y += smoothstep(0.3, 0.7, n) * 0.04 * cos(time * 10.0);
    return p;
}

// Constructs a tree shape composed of a trunk and a canopy.
// The trunk is defined by a vertical band whose half-width decreases with height,
// and the canopy is defined as a circle at the top.
float treeShape(in vec2 p) {
    // Distort coordinates for glitch effect
    p = glitch(p);
    
    // Trunk: center the trunk around x = 0.5
    // Thickness: thicker at bottom (p.y=0) and narrower at top (p.y=1)
    float thickness = mix(0.15, 0.05, p.y);
    float trunk = thickness - abs(p.x - 0.5);
    float trunkShape = smoothstep(0.01, -0.01, trunk);
    
    // Canopy: circle centered at (0.5, 0.8) with radius 0.2
    float d = length(p - vec2(0.5, 0.8)) - 0.2;
    float canopyShape = smoothstep(0.01, -0.01, -d);
    
    // Blend trunk and canopy together
    return max(trunkShape, canopyShape);
}

void main() {
    vec2 pos = uv;
    
    // Obtain the tree shape mask.
    float shape = treeShape(pos);
    
    // Create dynamic organic patterns using fbm noise for internal texturing
    float texture = fbm(pos * 10.0 + time);
    
    // Define colors: a resilient tree with brown trunk and green canopy.
    // Introduce glitch-influenced digital streaks with a pale highlight.
    vec3 trunkColor = vec3(0.4, 0.25, 0.1);
    vec3 canopyColor = vec3(0.0, 0.6, 0.1);
    vec3 glitchColor = vec3(1.0) * smoothstep(0.4, 0.6, texture);
    
    // Mix trunk and canopy based on vertical position.
    float blendFactor = smoothstep(0.3, 0.8, pos.y);
    vec3 treeColor = mix(trunkColor, canopyColor, blendFactor);
    
    // Apply pulsating effect to simulate organic growth resilience.
    float pulse = abs(sin(time * 3.0)) * 0.3 + 0.7;
    treeColor *= pulse;
    
    // Blend in the glitch effect to give a digital distortion twist.
    vec3 color = mix(treeColor, glitchColor, 0.3);
    
    // Background is a deep midnight blue.
    vec3 bg = vec3(0.0, 0.0, 0.1);
    
    // Final composition: tree shape over the background.
    vec3 finalColor = mix(bg, color, shape);
    
    gl_FragColor = vec4(finalColor, 1.0);
}