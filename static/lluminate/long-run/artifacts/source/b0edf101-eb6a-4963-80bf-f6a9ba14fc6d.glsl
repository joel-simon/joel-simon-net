precision mediump float;
varying vec2 uv;
uniform float time;

float digitalVine(vec2 p) {
    // Shift to center
    p = p - 0.5;
    
    // Convert to polar coordinates
    float angle = atan(p.y, p.x);
    float radius = length(p);
    
    // Create digital stripes pattern using sine modulation; these represent circuit pathways.
    float stripe = abs(sin(10.0 * angle + time * 2.0)) * 0.5;
    
    // Introduce organic distortion: radial sine waves simulating vine growth.
    float organic = sin(radius * 20.0 - time * 3.0) * 0.25 + 0.5;
    
    // Combine patterns with a digital thresholding to yield a crisp structure
    float combined = smoothstep(0.4, 0.5, stripe * organic);
    
    return combined;
}

void main() {
    // Create two domains: digital (circuitry) and organic (vines)
    vec2 p = uv;
    
    // Background: a gradient mix of deep blues and purples, evoking a cosmic digital realm.
    vec3 bgColor = mix(vec3(0.05, 0.0, 0.2), vec3(0.0, 0.0, 0.15), p.y);
    
    // Digital vine pattern
    float pattern = digitalVine(p);
    
    // Organic flourish: add soft glows along the digital vines
    vec3 glow = vec3(0.1, 0.4, 0.6) * pattern;
    
    // Further enhance with a subtle pulse, representing the heartbeat of a living digital network.
    float pulse = sin(time + length(p - 0.5) * 30.0) * 0.5 + 0.5;
    vec3 pulseColor = vec3(0.2, 0.7, 0.9) * pulse * pattern;
    
    vec3 color = bgColor + glow + pulseColor;
    
    gl_FragColor = vec4(color, 1.0);
}