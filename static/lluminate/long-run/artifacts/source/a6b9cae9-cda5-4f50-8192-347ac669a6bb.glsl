precision mediump float;
varying vec2 uv;
uniform float time;

//
// SCAMPER Applied: Base concept is a brain-inspired structure transformed by
// combining organic heart shapes with glitchy spiral distortions and magnified dynamic color transitions.
//

// Function to create a heart shape using modified polar coordinates.
float heartShape(vec2 p, vec2 center, float scale) {
    vec2 pos = (p - center) * 2.0;
    pos.x *= 1.2;
    float a = atan(pos.x, pos.y);
    float r = length(pos);
    // Heart implicit function adjustment
    float h = pow(r, 0.5) - 0.5 * sin(a * 3.0 + time);
    return smoothstep(scale, scale - 0.01, h);
}

// Function to create a swirling glitch pattern that overlays the shape.
float glitchPattern(vec2 p) {
    vec2 gp = p * 10.0;
    float wave = sin(gp.x + time) * cos(gp.y - time);
    // Introduce glitchy distortion by mixing coordinate offsets.
    float glitch = step(0.0, fract(sin(dot(gp ,vec2(12.9898,78.233)))*43758.5453) - 0.5);
    return abs(wave) * glitch;
}

void main() {
    // Base background: dynamic swirling nebula with gradient from dark to rich color.
    vec2 p = uv;
    vec2 center = vec2(0.5, 0.5);
    float dist = length(uv - center);
    vec3 bgColor = mix(vec3(0.05, 0.02, 0.1), vec3(0.2, 0.1, 0.35), 0.5 + 0.5 * sin(time + dist * 12.0));

    // Apply a swirling coordinate transformation to create a spiral effect.
    float angle = atan(p.y - center.y, p.x - center.x);
    float radius = length(p - center);
    float spiral = sin(radius * 15.0 - time * 3.0 + angle * 4.0);
    
    // Create a heart shape modified by the spiral distortion.
    float heart = heartShape(uv + 0.02 * vec2(cos(time), sin(time)) * spiral, center, 0.45);
    
    // Introduce a glitch overlay that evolves over time.
    float glitch = glitchPattern(uv + vec2(sin(time), cos(time)) * 0.02);
    
    // Combine the heart mask with the glitch effects.
    float mask = clamp(heart + 0.3 * glitch, 0.0, 1.0);
    
    // Define dynamic heart colors blending fiery pinks and deep reds.
    vec3 heartColor = mix(vec3(0.8, 0.2, 0.5), vec3(0.9, 0.1, 0.2), uv.y + 0.2 * sin(time * 2.0));
    
    // Synthesize the final color via blending the background with the heart layer.
    vec3 color = mix(bgColor, heartColor, mask);
    
    gl_FragColor = vec4(color, 1.0);
}